//=========================================================================
// RTL Model Divider Testbench
//
// Author: Tofic Esses
//
// NOTE: tetsbench inspiration taken from gcd_testbench.v
//-------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module divider_testbench;

  localparam integer W = 32; // width of operands

  //--------------------------------------------------------------------
  // Setup a clock
  //--------------------------------------------------------------------
  reg clk = 0;
  always #(`CLOCK_PERIOD/2) clk = ~clk;

  // DUT signals
  reg reset;
  reg [W-1:0] dividend, divisor;
  reg operands_val;
  wire operands_rdy;

  wire [W-1:0] quotient, remainder;
  wire result_val;
  reg result_rdy;

  // bookkeeping for test cases
  integer tests = 0;
  integer fails = 0;

  // DUT instance
  divider #(.W(W)) dut (
    .clk(clk),
    .reset(reset),
    .dividend(dividend),
    .divisor(divisor),
    .operands_val(operands_val),
    .operands_rdy(operands_rdy),
    .quotient(quotient),
    .remainder(remainder),
    .result_val(result_val),
    .result_rdy(result_rdy)
  );

  //--------------------------------------------------------------------
  // Task to run a single divide operation and check the result
  // For TESTBENCH MODULARITY 
  //--------------------------------------------------------------------

  task run_divide(input [W-1:0] a, input [W-1:0] b);
    reg [W-1:0] exp_quotient, exp_remainder;
    begin
      tests = tests + 1;

      // Wait until DUT ready to accept operands
      @(posedge clk);
      while (!operands_rdy) @(posedge clk);

      // Drive operands, then transmit operands_val for one cycle
      dividend = a;
      divisor  = b;
      operands_val = 1;
      @(posedge clk);
      operands_val = 0;

      // Wait for a valid result
      while (!result_val) @(posedge clk);

      // Compute expected result and compare with simulated result
      exp_quotient = a / b;
      exp_remainder = a % b;

      // Catch mismatch
      if (quotient !== exp_quotient || remainder !== exp_remainder) begin
        $error("FAIL: %0d / %0d -> got q=%0d r=%0d, expected q=%0d r=%0d",
            a, b, quotient, remainder, exp_quotient, exp_remainder);
        fails = fails + 1;
      
      // Pass case
      end else begin
        $display("PASS: %0d / %0d = %0d, remainder = %0d", a, b, quotient, remainder);
      end

      // Handshake result consumption
      result_rdy = 1;
      @(posedge clk);
      result_rdy = 0;
    end
  endtask

  //--------------------------------------------------------------------
  // Test cases
  //--------------------------------------------------------------------
  
  initial begin
    $dumpfile("divider_testbench.vcd");
    $dumpvars(0, divider_testbench);

    // initialize signals
    reset = 1;
    operands_val = 0;
    result_rdy = 0;
    dividend = 0;
    divisor  = 1;

    // hold reset for a few cycles
    repeat (3) @(posedge clk);
    reset = 0; // release reset

    // 4-bit and 32-bit test cases
    run_divide(7, 2);
    run_divide(15, 3);
    run_divide(13, 5);
    run_divide(9, 4);
    run_divide(0, 5);
    run_divide(5, 1);

    // 32-bit cases only
    run_divide(32'hEFFFFFFF, 23256); // all 1's except MSB
    run_divide(32'hFFFFFFFF, 232567); // all 1's

    // Catch test failures
    if (fails) begin
      $display("********FAIL: %0d/%0d tests FAILED", fails, tests);
      $fatal(1);
    
    // If no test failures caught, asssume all tests passed
    end else begin
      $display("********SUCCESS: All %0d tests PASSED", tests);
      $finish;
    end
  end

endmodule
