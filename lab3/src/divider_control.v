//=========================================================================
// RTL Model Divider Control (Algorithm 1)
//
// Author: Tofic Esses
//-------------------------------------------------------------------------
//

module divider_control #( parameter W )
(
    // global inputs
    input clk, reset,

    input operands_val, // producer has valid operands
    input result_rdy, // consumer is ready for result

    output reg operands_rdy, // divider is ready for new operands
    output reg result_val, // result is valid

    output reg load, // load operands into registers
    output reg iter_en // one iteration per clock cycle
);

// states
localparam IDLE = 2'b00,
           CALC = 2'b01,
           DONE = 2'b10;

// state and nextstate
wire [1:0] state_q; // current state
reg [1:0] state_d; // next state

// counter
wire [W-1:0] count_q; // current count
reg [W-1:0] count_d; // next count

// Finite State Machine
// "I used design pattern 2"
// --------------------
always @(*) begin
    // default hold state
    state_d = state_q;
    count_d = count_q;

    load = 1'b0;
    iter_en = 1'b0;
    operands_rdy = 1'b0;
    result_val = 1'b0;

    case (state_q)
        IDLE: begin
            operands_rdy = 1'b1;
            if (operands_val) begin
                load = 1'b1; // load operands into registers
                count_d = {W{1'b0}}; // initialize counter to 0
                state_d = CALC; // move to CALC state
            end
        end

        CALC: begin
            iter_en = 1'b1; // enable iteration
            count_d = count_q + 1'b1; // increment counter
            if (count_q == W) begin
                state_d = DONE; // move to DONE state after W+1 iterations
            end
        end

        DONE: begin
            result_val = 1'b1; // result is valid
            if (result_rdy) begin
                state_d = IDLE; // move back to IDLE state
            end
        end
    endcase
end

// Sequential logic for state and counter registers
REGISTER_R #(.N(2), .INIT(IDLE))
    state_reg (.q(state_q), .d(state_d), .rst(reset), .clk(clk));

REGISTER_R #(.N(W), .INIT({W{1'b0}}))
    count_reg (.q(count_q), .d(count_d), .rst(reset), .clk(clk));

endmodule
