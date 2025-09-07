module simple_counter (
    input clk,
    input reset,
    output [1:0] counter_out
);
    reg [1:0] counter;

    always @(posedge reset or posedge clk) begin
        if (reset == 1'b1) begin // TODO
            counter <= 2'b00;
        end else begin
            case (counter) // TODO
                // 4 possible cases
                2'b00: counter = 2'b01;
                2'b01: counter = 2'b10;
                2'b10: counter = 2'b11;
                2'b11: counter = 2'b00;
            endcase
        end
    end

    assign counter_out = counter; // TODO
endmodule
