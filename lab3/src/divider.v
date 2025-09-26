`include "/home/ff/eecs151/verilog_lib/EECS151.v"

//=========================================================================
// RTL Model Divider (Algorithm 1)
//
// Author: Tofic Esses
//-------------------------------------------------------------------------

// top level module
module divider #(
    parameter W = 32
) (
  input clk,
  input reset,

  input [W-1:0] dividend,
  input [W-1:0] divisor,

  input operands_val,
  output operands_rdy,

  output [W-1:0] quotient,
  output [W-1:0] remainder,

  output result_val,
  input result_rdy
);

  // Internal control signals
  wire load;      
  wire iter_en;

  // Instantiate control module
  divider_control #( .W(W) ) ctrl (
      .clk(clk),
      .reset(reset),
      .operands_val(operands_val),
      .result_rdy(result_rdy),
      .operands_rdy(operands_rdy),
      .result_val(result_val),
      .load(load),
      .iter_en(iter_en)
  );

  // Instantiate datapath module
  divider_datapath #( .W(W) ) dp (
      .clk(clk),
      .reset(reset),
      .load(load),
      .iter_en(iter_en),
      .divisor(divisor),
      .dividend(dividend),
      .quotient(quotient),
      .remainder(remainder)
  );

endmodule
