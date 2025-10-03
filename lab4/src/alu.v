//=========================================================================
// RTL ALU Module
//
// Author: Tofic Esses
//-------------------------------------------------------------------------

`include "alu_op.vh"

module alu(
    input [31:0] a, b,
    input [3:0] alu_op,
    output [31:0] out
);

// Internal signal
reg [31:0] out_sig;

// Combinational logic for ALU operations
always @(*) begin
    case(alu_op)
        `ALU_ADD: out_sig = a + b;
        `ALU_SUB: out_sig = a - b;
        `ALU_AND: out_sig = a & b;
        `ALU_OR:  out_sig = a | b;
        `ALU_XOR: out_sig = a ^ b;
        `ALU_SLT: out_sig = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
        `ALU_SLTU: out_sig = (a < b) ? 32'b1 : 32'b0;
        `ALU_SLL: out_sig = a << b[4:0];
        `ALU_SRA: out_sig = $signed(a) >>> b[4:0];
        `ALU_SRL: out_sig = a >> b[4:0];
        `ALU_COPY_B: out_sig = b;
        default: out_sig = 32'b0; // XXX: Default case to handle unexpected alu values
    endcase
end

assign out = out_sig;

endmodule
