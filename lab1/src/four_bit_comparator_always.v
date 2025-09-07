module four_bit_comparator_always (
    input [3:0] a, // TODO
    input [3:0] b, // TODO
    output reg greater,
    output reg less,
    output reg equal
);

    always @(*) begin
	equal = 1'b0;
        less = 1'b0;
        greater = 1'b0;

        if (a > b) begin // TODO
            greater = 1'b1;
        end else if (a < b) begin // TODO
            less = 1'b1;
        end else begin
            equal = 1'b1;
        end
    end
endmodule
