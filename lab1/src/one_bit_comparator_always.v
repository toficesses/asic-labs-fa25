module one_bit_comparator_always (
    input a,
    input b,
    output reg greater,
    output reg less,
    output reg equal
);
    always @(*) begin

	// preassign to 0
	equal = 1'b0;
        less = 1'b0;
        greater = 1'b0;

        if (a > b) begin
            greater = 1'b1;
        end else if (a < b) begin
            less = 1'b1;
        end else begin
            equal = 1'b1;
        end
    end
endmodule
