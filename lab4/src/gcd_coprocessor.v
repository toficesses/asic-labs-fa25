//=========================================================================
// GCD Coprocessor Module
//
// Author: Tofic Esses
//-------------------------------------------------------------------------

module gcd_coprocessor #( parameter W = 32 ) (
  input clk,
  input reset,

  input operands_val,
  input [W-1:0] operands_bits_A,
  input [W-1:0] operands_bits_B,
  output operands_rdy,

  output result_val,
  output [W-1:0] result_bits,
  input result_rdy

);

  // CONTROL SIGNALS
  // =================================================
  // Wires between GCD control and GCD datapath
  wire B_mux_sel, A_en, B_en, B_zero, A_lt_B;
  wire [1:0] A_mux_sel;

  // Wires between FIFO and GCD
  // Control signals
  wire req_enq_rdy;
  wire req_deq_val;
  wire req_deq_rdy;

  wire resp_enq_rdy;

  wire gcd_in_rdy;
  wire gcd_in_val = req_deq_val;
  wire gcd_out_val;
  wire gcd_out_rdy;

  // Data signals
  wire [2*W-1:0] req_deq_data;
  wire [W-1:0] gcd_out_bits;
  wire [W-1:0] A_in = req_deq_data[2*W-1:W];
  wire [W-1:0] B_in = req_deq_data[W-1:0];

  // IO Assignments
  assign operands_rdy = req_enq_rdy;
  assign req_deq_rdy  = gcd_in_rdy;
  assign gcd_out_rdy  = resp_enq_rdy;
  

  
  // MODULE INSTANCES
  // =================================================
  // Instantiate gcd_datapath
  gcd_datapath #( .W(W) ) GCDdpath0(
    .operands_bits_A(A_in),
    .operands_bits_B(B_in),
    .result_bits_data(gcd_out_bits),

    .clk(clk),
    .reset(reset),

    // internal (between ctrl and dpath)
    .A_mux_sel(A_mux_sel[1:0]),
    .A_en(A_en),
    .B_en(B_en),
    .B_mux_sel(B_mux_sel),
    .B_zero(B_zero),
    .A_lt_B(A_lt_B)
  );

  // Instantiate gcd_control
  gcd_control GCDctrl0(
    .clk(clk),
    .reset(reset),
    .operands_val(gcd_in_val),
    .result_rdy(gcd_out_rdy),
    .B_zero(B_zero),
    .A_lt_B(A_lt_B),

    .result_val(gcd_out_val),
    .operands_rdy(gcd_in_rdy),

    .A_mux_sel(A_mux_sel[1:0]),
    .B_mux_sel(B_mux_sel),
    .A_en(A_en),
    .B_en(B_en)
  );

  // Instantiate request FIFO
  fifo #( .WIDTH(2*W), .LOGDEPTH(2) ) req_fifo (
    .clk(clk),
    .reset(reset),
    .enq_val(operands_val),
    .enq_data({operands_bits_A, operands_bits_B}),
    .enq_rdy(req_enq_rdy),
    .deq_val(req_deq_val),
    .deq_data(req_deq_data),
    .deq_rdy(req_deq_rdy)
  );

  // Instantiate response FIFO
  fifo #( .WIDTH(W), .LOGDEPTH(2) ) resp_fifo (
    .clk(clk),
    .reset(reset),
    .enq_val(gcd_out_val),
    .enq_data(gcd_out_bits),
    .enq_rdy(resp_enq_rdy),
    .deq_val(result_val),
    .deq_data(result_bits),
    .deq_rdy(result_rdy)
  );

endmodule
