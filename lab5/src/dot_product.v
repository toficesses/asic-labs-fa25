//=========================================================================
// Dot Product Module
//
// Author: Tofic Esses
//-------------------------------------------------------------------------

module dot_product #(
  localparam ADDR_WIDTH = 6, // 6 bits to represent up to 64 words
  localparam WIDTH = 32 // Width of data
) (
  // Global signals
  input clk,
  input rst,

  // Input vector length
  input [ADDR_WIDTH-1:0] len,

  // Input vector a
  input [WIDTH-1:0] a_data,
  input a_valid,
  output reg a_ready,

  // Input vector b
  input [WIDTH-1:0] b_data,
  input b_valid,
  output reg b_ready,

  // Dot product result c
  output [WIDTH-1:0] c_data,
  output reg c_valid,
  input c_ready
);

// State encodings
localparam STATE_READ = 2'd0;
localparam STATE_CALC_LOAD_A = 2'd1;
localparam STATE_CALC_LOAD_B = 2'd2;
localparam STATE_CALC_DONE = 2'd3;

// ================================== //
//        Combinational Logic         //
// ================================== //

// Combinational logic for control signals
wire a_fire, b_fire, c_fire;
assign a_fire = a_valid && a_ready;
assign b_fire = b_valid && b_ready;
assign c_fire = c_valid && c_ready;

// SRAM signals
reg we; // Write enable
wire [3:0] wmask = 4'b1111; // Write mask (always write all 4 bytes)
reg [ADDR_WIDTH-1:0] addr; // Address
reg [WIDTH-1:0] din; // Data in
wire [WIDTH-1:0] dout; // Data out

// Instantiate sram module
sram22_64x32m4w8 sram (
  .clk(clk),
  .we(we),
  .wmask(wmask),
  .addr(addr),
  .din(din),
  .dout(dout)
);

//*****************************************//

// State variables
wire [1:0] state;
reg [1:0] nextstate;

// Addresses holders
wire [ADDR_WIDTH-1:0] a_addr;
reg [ADDR_WIDTH-1:0] a_addr_next;

wire [ADDR_WIDTH-1:0] b_addr;
reg [ADDR_WIDTH-1:0] b_addr_next;

// Product wire
wire [WIDTH-1:0] product;

// Accumulated sum of dot product holder
wire [WIDTH-1:0] sum; 
reg [WIDTH-1:0] sum_next;

// Scratchpad: used to store intermediate A value
wire [WIDTH-1:0] value; 
reg [WIDTH-1:0] value_next;

// Continuous assignment
assign product = value * dout;

// Combinational logic for next state
always @(*) begin

  // Default values
  nextstate = state; // Stay in the same state by default
  a_addr_next = a_addr;
  b_addr_next = b_addr;
  sum_next = sum;
  value_next = value;

  // Pull down ready signals by default
  a_ready = 0;
  b_ready = 0;
  c_valid = 0;

  // Default memory signals
  we = 0; // Set no write; read by default
  din = 0;
  addr = 0;

  case (state)

    // READ STATE
    STATE_READ : begin

      // Read A inputs first 
      if ((a_addr < len) && a_valid) begin
        a_ready = 1; b_ready = 0;
        if (a_fire) begin
          din = a_data; // Assign input data of memory
          we = 1; // Enable write
          a_addr_next = a_addr + 1; // Increment by 1
          addr = a_addr; // Assign address
        end
      end

      // Read B inputs next 
      else if ((b_addr < len) && b_valid) begin
        a_ready = 0; b_ready = 1;
        if (b_fire) begin
          din = b_data; // Assign input data of memory
          we = 1; // Enable write
          b_addr_next = b_addr + 1; // Increment by 1
          addr = len + b_addr; // Assign address // 32 + i
        end
      end
      // If neither side is currently valid, assert ready to whichever side still has space
      else if (a_addr < len) begin
        a_ready = 1; b_ready = 0;
      end
      else if (b_addr < len) begin
        a_ready = 0; b_ready = 1;
      end
      // Check if done writing A and B in DRAM
      else begin
        
        // Resets the address holders back two zero
        a_addr_next = 0;
        b_addr_next = 0;

        // Reset values for computation
        sum_next = 0;
        value_next = 0;

        // Initialize addr for next cycle
        addr = 0; // A[0]

        // Move to next state
        nextstate = STATE_CALC_LOAD_A;

      end
    end

    // CALC STATE (includes two sub states)
    /*
      - Alternates between load A and load B
      - Stores intemediate A value in the scratchpad
      - Then loads B
      - Computes the product of loaded values
      - Accumulates the product to the sum
    */
    STATE_CALC_LOAD_A : begin
      value_next = dout; // Loads dout = A[i] 
      a_addr_next = a_addr + 1; // Increment by 1
      addr = len + b_addr; // Set B address for next cycle // base address = len
      nextstate = STATE_CALC_LOAD_B;
    end

    STATE_CALC_LOAD_B : begin
      sum_next = sum + product; // Accumulate product to sum
      b_addr_next = b_addr + 1; // Increment by 1

      // Check if one last B load // avoids redundant move to  STATE_CALC_LOAD_A state
      // if (b_addr == len - 1) begin
      //   // Compute sum for last index of B
      //   addr = len + b_addr; // Set B address for next cycle // base address = len
      //   nextstate = STATE_CALC_LOAD_B; // Remain in same state
      // end

      // B fully loaded
      if (b_addr == len - 1) begin
        // Move to next state
        nextstate = STATE_CALC_DONE; // Finished all computations
      end

      // Alternate between A and B
      else begin
        addr = a_addr; // Set A address for next cycle A[i]
        nextstate = STATE_CALC_LOAD_A;
      end
    end

    // DONE STATE
    STATE_CALC_DONE : begin
      c_valid = 1; // Assert c_valid

      // Go back to previous state
      if (c_fire) begin
        // Reset addresses
        a_addr_next = 0;
        b_addr_next = 0;

        nextstate = STATE_READ;
      end
    end

  endcase
end

// Assign output
assign c_data = sum; // Dot product

// ================================== //
//         Sequential Logic           //
// ================================== //

// Update state at clk rising edge
REGISTER_R #(.N(2), .INIT(STATE_READ)) state_machine (.q(state), .d(nextstate), .rst(rst), .clk(clk));

// Update address holders at clk rising edge
REGISTER_R #(.N(ADDR_WIDTH), .INIT({ADDR_WIDTH{1'b0}})) a_addr_reg (.q(a_addr), .d(a_addr_next), .rst(rst), .clk(clk));
REGISTER_R #(.N(ADDR_WIDTH), .INIT({ADDR_WIDTH{1'b0}})) b_addr_reg (.q(b_addr), .d(b_addr_next), .rst(rst), .clk(clk));

// Update sum
REGISTER_R #(.N(WIDTH), .INIT({WIDTH{1'b0}})) sum_reg (.q(sum), .d(sum_next), .rst(rst), .clk(clk));

// Update scratchpad 
// Initialize scratchpad to 1 to avoid multiplication by 0
REGISTER_R #(.N(WIDTH), .INIT({{(WIDTH-1){1'b0}}, 1'b1})) scratchpad_reg (.q(value), .d(value_next), .rst(rst), .clk(clk));

//============================
// Assertions (SystemVerilog)
//============================

// Addressing bounds
ASSERT_B_INDEX_IN_RANGE:
  assert property (@(posedge clk) disable iff (rst)
                    (state inside {STATE_CALC_LOAD_A, STATE_READ}) |-> (b_addr <= len))
  else
    $error("[%m] b_addr out of range in LOAD_A/READ: b_addr=%0d len=%0d @%0t",
           b_addr, len, $time);

ASSERT_A_INDEX_IN_RANGE:
  assert property (@(posedge clk) disable iff (rst)
                   (state inside {STATE_CALC_LOAD_B, STATE_READ}) |-> (a_addr <= len))
  else
    $error("[%m] a_addr out of range in LOAD_B/READ: a_addr=%0d len=%0d @%0t",
           a_addr, len, $time);

// Control flow
ASSERT_RETURN_TO_READ: // After DONE & c_ready handshake, go back to READ next cycle
  assert property (@(posedge clk) disable iff (rst)
                   (state == STATE_CALC_DONE && c_ready) |=> (state == STATE_READ))
  else
    $error("[%m] Did not return to READ after DONE+c_ready @%0t", $time);

endmodule