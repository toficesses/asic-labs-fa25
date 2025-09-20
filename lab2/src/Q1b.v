module q1b (
    input [1:0] A, B,
    output Y
);
    assign Y = & ( ~(A ^ B) );
endmodule
