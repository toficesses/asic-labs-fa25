//=========================================================================
// FIFO Datapath Module
//
// Author: Tofic Esses
//-------------------------------------------------------------------------

module fifo_datapath #(parameter WIDTH = 8, parameter LOGDEPTH = 3)
(
    // global inputs
    input clk,
    input reset,

    // full enable 
    input r_en,
    input w_en,

    // data inputs and outputs
    input [WIDTH-1:0] enq_data,
    output [WIDTH-1:0] deq_data,

    // read and write pointers
    input [LOGDEPTH-1:0] rptr,
    input [LOGDEPTH-1:0] wptr

);

localparam DEPTH = (1 << LOGDEPTH);

// the FIFO buffer (2D array)
reg [WIDTH-1:0] buffer [DEPTH-1:0];

// Sequential
// ----------
// I choose to implement this behaviorally as it is much simpler to do so
// The state is the contents of the buffer
always @(posedge clk) begin

    if (w_en) begin
        // write data to buffer at wptr location
        buffer[wptr] <= enq_data;
    end

    // if (r_end) begin
    //     deq_data <= buffer[rptr]; // combinational read from buffer at rptr location
    // end

end

// For immediate output
assign deq_data = buffer[rptr]; // combinational read from buffer at rptr location

endmodule