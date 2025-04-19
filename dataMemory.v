/*
   -----------------------------------------------------------------------------
   Submodule: Data_Memory
   Description: Implements a 128x32-bit memory module with read and write 
                capabilities. It uses a 7-to-128 decoder for address decoding 
                and 32-bit registers for storage.
  
   Inputs:
   - clk: Clock signal for synchronous operations.
   - reset: Reset signal to clear memory contents.
   - MemWrite: Enable signal for write operations.
   - MemRead: Enable signal for read operations.
   - address: 32-bit address input to select memory location.
   - WriteData: 32-bit data input to be written to memory.
  
   Outputs:
   - ReadData: 32-bit data output read from the selected memory location.
  
   Notes:
   - Address bits [8:2] are used for decoding, allowing 128 memory locations.
   -----------------------------------------------------------------------------
*/

module Equality_7bit (
    input wire [6:0] a,
    input wire [6:0] b,
    output wire eq
);
    wire [6:0] xnor_bits;

    // Bitwise equality using XNOR for each bit
    xnor (xnor_bits[0], a[0], b[0]);
    xnor (xnor_bits[1], a[1], b[1]);
    xnor (xnor_bits[2], a[2], b[2]);
    xnor (xnor_bits[3], a[3], b[3]);
    xnor (xnor_bits[4], a[4], b[4]);
    xnor (xnor_bits[5], a[5], b[5]);
    xnor (xnor_bits[6], a[6], b[6]);

    // AND all xnor bits to get final equality result
    and (eq, xnor_bits[0], xnor_bits[1], xnor_bits[2], 
              xnor_bits[3], xnor_bits[4], xnor_bits[5], xnor_bits[6]);
endmodule


module Decoder_7_to_128 (
    input wire [6:0] in,
    input wire enable,
    output wire [127:0] out
);
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin : decode_block
            wire eq;

            // Check if input matches current index i
            Equality_7bit eq_checker (
                .a(in),
                .b(i[6:0]),
                .eq(eq)
            );

            // Output line is high only if match and enabled
            and (out[i], eq, enable);
        end
    endgenerate
endmodule


module Data_Memory (
    input wire        clk,
    input wire        reset,
    input wire        MemWrite,
    input wire        MemRead,
    input wire [31:0] address,
    input wire [31:0] WriteData,
    output reg [31:0] ReadData
);
    wire [31:0] memory [0:127];
    wire [127:0] reg_write_en;

    // Decoder for address
    Decoder_7_to_128 decode_addr(
        .in(address[8:2]),
        .enable(MemWrite),
        .out(reg_write_en)
    );

    // Instantiate 128 32-bit memory register
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin
            register_32bit_en reg_inst (
                .D(WriteData),
                .CLK(clk),
                .EN(reg_write_en[i]),
                .RST(reset),
                .Q(memory[i]),
                .QN()
            );
        end
    endgenerate

    // Tri-state buffer for 32-bit data using bufif1 gates
    wire [31:0] tri_state_out;
    genvar j;
    generate
        for (j = 0; j < 32; j = j + 1) begin
            bufif1(tri_state_out[j], memory[address[8:2]][j], MemRead);
        end
    endgenerate

    always @(negedge clk ) begin
        ReadData <= tri_state_out;
    end
    
endmodule
