module Q1c (
    input A, clk,
    output X, Y
);
    REGISTER ff_1(.q(X), .d(A), .clk(clk));

    assign Y = X & A;
endmodule
                                                                                                                            
