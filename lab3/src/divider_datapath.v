//=========================================================================
// RTL Model Divider Datapath (Algorithm 1)
//
// Author: Tofic Esses
//-------------------------------------------------------------------------
//
module divider_datapath #( parameter W )
(
    // global inputs
    input clk, reset,

    // control input signals
    input load, // load operands into registers
    input iter_en, // one iteration per clock cycle
    
    // operands inputs
    input [W-1:0] divisor,
	input [W-1:0] dividend,

    // result outputs
    output [W-1:0] quotient,
    output [W-1:0] remainder
);

localparam TOTW = 2*W;

// state registers of values
wire [TOTW-1:0] divisor_q; reg [TOTW-1:0] divisor_d;
wire [TOTW-1:0] remainder_q; reg [TOTW-1:0] remainder_d;

wire [W-1:0] quotient_q; reg [W-1:0] quotient_d;

// Combinational
// ------------
// tmp subtract and decision
wire [TOTW-1:0] remainder_tmp = remainder_q - divisor_q;

// if remainder_tmp[TOTW-1] = 1, negative remainder_tmp -> restore remainder
// else, positive remainder_tmp -> take remainder_tmp
wire take = ~remainder_tmp[TOTW-1];

// next values
wire [TOTW-1:0] remainder_next = take ? remainder_tmp : remainder_q;
wire [W-1:0] quotient_next = {quotient_q[W-2:0], take}; // shift left and set LSB = take
wire [TOTW-1:0] divisor_next = {1'b0, divisor_q[TOTW-1:1]}; // shift right by 1


always @(*) begin
    // hold values by default
    remainder_d = remainder_q;
    quotient_d = quotient_q;
    divisor_d = divisor_q;

    if (load) begin
        // load initial values
        remainder_d = { {W{1'b0}}, dividend }; // zero-extend dividend to TOTW bits
        quotient_d = {W{1'b0}}; // initialize quotient to 0
        divisor_d = {divisor, {W{1'b0}}}; // left shift divisor by W bits
    end else if (iter_en) begin
        // update values for next iteration
        remainder_d = remainder_next;
        quotient_d = quotient_next;
        divisor_d = divisor_next;
    end
end

// Sequential
// ----------
wire ce_all = load | iter_en;

REGISTER_R_CE #(.N(TOTW), .INIT({TOTW{1'b0}}))
    remainder_reg (.q(remainder_q), .d(remainder_d), .rst(reset), .ce(ce_all), .clk(clk));

REGISTER_R_CE #(.N(TOTW), .INIT({TOTW{1'b0}}))
    divisor_reg (.q(divisor_q), .d(divisor_d), .rst(reset), .ce(ce_all), .clk(clk));

REGISTER_R_CE #(.N(W), .INIT({W{1'b0}}))
    quotient_reg (.q(quotient_q), .d(quotient_d), .rst(reset), .ce(ce_all), .clk(clk));

// output assignments
assign quotient = quotient_q;
assign remainder = remainder_q[W-1:0]; // lower W bits of remainder

endmodule