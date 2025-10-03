//=========================================================================
// FIFO Top-Level Module
//
// Author: Tofic Esses
//-------------------------------------------------------------------------

`include "/home/ff/eecs151/verilog_lib/EECS151.v"

module fifo #(parameter WIDTH = 8, parameter LOGDEPTH = 3) (
    input clk,
    input reset,

    input enq_val,
    input [WIDTH-1:0] enq_data,
    output enq_rdy,

    output deq_val,
    output [WIDTH-1:0] deq_data,
    input deq_rdy

);

localparam DEPTH = (1 << LOGDEPTH);

// internal control signals
wire [LOGDEPTH-1:0] rptr, wptr;
wire r_en, w_en;

// instantiate the control module
fifo_control #( .LOGDEPTH(LOGDEPTH) ) ctrl (
    .clk(clk),
    .reset(reset),
    .enq_val(enq_val),
    .enq_rdy(enq_rdy),
    .deq_val(deq_val),
    .deq_rdy(deq_rdy),
    .r_en(r_en),
    .w_en(w_en),
    .rptr(rptr),
    .wptr(wptr)
);

// instantiate the datapath module
fifo_datapath #( .WIDTH(WIDTH), .LOGDEPTH(LOGDEPTH) ) dp (
    .clk(clk),
    .reset(reset),
    .r_en(r_en),
    .w_en(w_en),
    .enq_data(enq_data),
    .deq_data(deq_data),
    .rptr(rptr),
    .wptr(wptr)
);

endmodule
