`timescale 1 ns / 1 ps

module dut_tb();

reg A, B, clk, rst;
wire X, Z;

initial clk = 0;
always #(`CLOCK_PERIOD/2) clk <= ~clk;

dut dut ( .A(A), .B(B), .clk(clk), .rst(rst), .X(X), .Z(Z) );

initial begin
  $vcdpluson;

  // Reset asserted at start
  rst <= 1'b1;
  A   <= 1'b0;
  B   <= 1'b0;
  @(negedge clk) rst <= 1'b0;  // release reset

  // --- Timing based on waveform diagram ---
  // A goes high for one cycle starting second posedge
  // B goes high earlier and stays high for multiple cycles

  // cycle 1: B=1, A=1
  @(negedge clk) begin
    B <= 1'b1;  
    A <= 1'b1;
  end

  // cycle 2: B still 1, A goes low
  @(negedge clk) A <= 1'b0;

  // cycle 3: B goes low
  @(negedge clk) B <= 1'b0;

  // stay low for a couple cycles
  repeat(2) @(negedge clk);

  $vcdplusoff;
  $finish;
end

endmodule
