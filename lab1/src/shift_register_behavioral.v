module shift_register_behavioral (
    input in,
    input clk,
    output [3:0] out
);
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        shift_reg = shift_reg << 1;
        shift_reg[0]= in;        	
    end
    
    assign out = shift_reg; // TODO
endmodule
