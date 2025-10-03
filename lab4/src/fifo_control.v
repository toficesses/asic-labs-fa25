
//=========================================================================
// FIFO Control Module
//
// Author: Tofic Esses
//-------------------------------------------------------------------------

module fifo_control #(parameter LOGDEPTH = 3)
(
    // global inputs
    input clk,
    input reset,

    input enq_val,
    output enq_rdy,

    output deq_val,
    input deq_rdy,

    output r_en,
    output w_en,

    // control pointers to datapath
    output [LOGDEPTH-1:0] rptr,
    output [LOGDEPTH-1:0] wptr

);

localparam DEPTH = (1 << LOGDEPTH);

// Combinational
// ------------

// pointers
// read and write pointer states {phase bit, pointer bitS}
// The phase bit is used to determine whether the FIFO is full or empty
reg [LOGDEPTH:0] rptr_d; 
wire [LOGDEPTH:0] rptr_q; 

reg [LOGDEPTH:0] wptr_d;
wire [LOGDEPTH:0] wptr_q;

// extract phase bits
wire w_phase = wptr_q[LOGDEPTH];
wire r_phase = rptr_q[LOGDEPTH];

// extract pointer index bits
wire [LOGDEPTH-1:0] ridx = rptr_q[LOGDEPTH-1:0];
wire [LOGDEPTH-1:0] widx = wptr_q[LOGDEPTH-1:0];

// Flags
wire empty = (rptr_q == wptr_q); // buffer empty state (phase bit and pointer bits are equal)
wire full = (widx == ridx) && (w_phase != r_phase); // the phase bits are different and the pointer bits are equal

// Handshaking signals
assign enq_rdy = ~full;
assign deq_val = ~empty;

// Control signals
assign w_en = enq_val & enq_rdy; // write enable when data is valid and space is available
assign r_en = deq_val & deq_rdy; // read enable when data is valid and consumer is ready

// Next-state logic
always @(*) begin
    // default to hold state
    rptr_d = rptr_q;
    wptr_d = wptr_q;

    if (r_en) begin
        rptr_d = rptr_q + 1'b1; // increment read pointer
    end

    if (w_en) begin
        wptr_d = wptr_q + 1'b1; // increment write pointer
    end
end

// Sequential
// ----------

// holds the states of the read and write pointers
REGISTER_R #(.N(LOGDEPTH+1), .INIT({(LOGDEPTH+1){1'b0}})) rptr_reg (.q(rptr_q), .d(rptr_d), .clk(clk), .rst(reset));
REGISTER_R #(.N(LOGDEPTH+1), .INIT({(LOGDEPTH+1){1'b0}})) wptr_reg (.q(wptr_q), .d(wptr_d), .clk(clk), .rst(reset));

// output assignments
assign rptr = ridx;
assign wptr = widx;

endmodule