//=========================================================================
// RTL ALU Model Testbench
//
// Author: Tofic Esses
//-------------------------------------------------------------------------

`timescale 1 ns / 100 ps
`include "alu_op.vh"

module alu_testbench;

  // Parameters
  localparam integer W = 32;
  localparam integer NUM_PER_OPERATION = 100;
  localparam integer CLOCK_PERIOD = 10;

  //--------------------------------------------------------------------
  // Clock (for neatness; DUT is combinational)
  //--------------------------------------------------------------------
  reg clk = 0;
  always #(CLOCK_PERIOD/2) clk = ~clk;

  // DUT signals
  reg  [W-1:0] a, b;
  reg  [3:0] alu_op;          
  wire [W-1:0] out;

  // Bookkeeping
  integer tests = 0;
  integer fails = 0;

  // DUT
  alu dut (
    .a(a),
    .b(b),
    .alu_op(alu_op),
    .out(out)
  );

  // Reference model
  function [W-1:0] alu_ref;

    input [W-1:0] a_ref, b_ref;
    input [3:0]   alu_op_ref;

    begin
      case (alu_op_ref)
        `ALU_ADD   : alu_ref = a_ref + b_ref;
        `ALU_SUB   : alu_ref = a_ref - b_ref;
        `ALU_AND   : alu_ref = a_ref & b_ref;
        `ALU_OR    : alu_ref = a_ref | b_ref;
        `ALU_XOR   : alu_ref = a_ref ^ b_ref;
        `ALU_SLT   : alu_ref = ($signed(a_ref) < $signed(b_ref)) ? 32'd1 : 32'd0;
        `ALU_SLTU  : alu_ref = (a_ref < b_ref) ? 32'd1 : 32'd0;
        `ALU_SLL   : alu_ref = a_ref << b_ref[4:0];
        `ALU_SRL   : alu_ref = a_ref >> b_ref[4:0];
        `ALU_SRA   : alu_ref = $signed(a_ref) >>> b_ref[4:0];
        `ALU_COPY_B: alu_ref = b_ref;
        default    : alu_ref = 32'd0; 
      endcase
    end
  endfunction

  // Task to run a single test
  task run_one(input [3:0] t_alu_op, input [W-1:0] ta, input [W-1:0] tb);
    reg [W-1:0] exp;

    begin
      tests = tests + 1;
      a = ta; b = tb; alu_op = t_alu_op;
      @(posedge clk);
      exp = alu_ref(ta, tb, t_alu_op);

      if (out !== exp) begin
        $error("FAIL: op=%0d a=0x%08x b=0x%08x -> out=0x%08x exp=0x%08x",
               t_alu_op, ta, tb, out, exp);
        fails = fails + 1;
      end
    end
  endtask

  // Task to create 100 random tests for a given operation
  task automatic run_tests(input [3:0] t_alu_op);
    // Automatic tasks allow for local variables to be stack allocated.
    // Therefore, at every call, the variables are re-initialized.
    integer i;
    integer k = 0;// local test counter
    integer prev_fails = fails;

    begin
      // Edge cases
      run_one(t_alu_op, 32'h00000000, 32'h00000000);
      run_one(t_alu_op, 32'hFFFFFFFF, 32'h00000001);
      run_one(t_alu_op, 32'h80000000, 32'h0000001F); 
      run_one(t_alu_op, 32'h7FFFFFFF, 32'hFFFFFFFF);

      k = k + 4;

      // Shift cases, shifting by large amounts
      if (t_alu_op==`ALU_SLL || t_alu_op==`ALU_SRL || t_alu_op==`ALU_SRA) begin
        run_one(t_alu_op, 32'h00000001, 32'd32);     // 32 -> masks to 0
        k = k + 1;
      end
      
      // Random tests
      for (i = 0; i < NUM_PER_OPERATION; i = i + 1) begin
        run_one(t_alu_op, $urandom, $urandom);
        k = k + 1;
      end

      if (fails - prev_fails == 0) begin
        $display("  All %0d tests passed", k);
      end else begin
        $display("  %0d/%0d tests failed", fails - prev_fails, k);
      end
      $display("----------------------------------");

    end
    
  endtask

  // Display banner for each operation
  task banner(input [127:0] name);
    begin
      $display("----------------------------------");
      $display("  Testing %s", name);
    end
  endtask

  // Main test sequence
  initial begin

    $dumpfile("alu_testbench.vcd");
    $dumpvars(0, alu_testbench);

    // Init
    a = '0; b = '0; alu_op = '0;
    repeat (3) @(posedge clk);

    // Run all operations
    banner("ADD");    run_tests(`ALU_ADD);
    banner("SUB");    run_tests(`ALU_SUB);
    banner("AND");    run_tests(`ALU_AND);
    banner("OR");     run_tests(`ALU_OR);
    banner("XOR");    run_tests(`ALU_XOR);
    banner("SLT");    run_tests(`ALU_SLT);
    banner("SLTU");   run_tests(`ALU_SLTU);
    banner("SLL");    run_tests(`ALU_SLL);
    banner("SRL");    run_tests(`ALU_SRL);
    banner("SRA");    run_tests(`ALU_SRA);
    banner("COPY_B"); run_tests(`ALU_COPY_B);

    // Display results
    if (fails) begin
      $display("********FAIL: %0d/%0d tests FAILED", fails, tests);
      $fatal(1);                        
    end else begin
      $display("********SUCCESS: All %0d tests PASSED", tests);
      $finish;
    end
  end

endmodule
