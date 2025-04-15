/*
  -----------------------------------------------------------------------------
   Module: Instruction_Memory
   Description: 
   This module represents an instruction memory for a single-cycle MIPS processor. 
   It uses a memory array to store instructions and outputs the instruction 
   corresponding to the given read address. The memory is organized as 128 words 
   of 32-bit width.
    
   Inputs:
   - clk: Clock signal.
   - read_address: 32-bit address to read the instruction from.
    
   Outputs:
   - instruction_out: 32-bit instruction fetched from memory.
    
   Note:
   - The memory is initialized using a generate block that instantiates 128 
       32-bit registers.
   - Only the lower 7 bits of the read address are used, and the address is 
       word-aligned, so the lower 2 bits of the address are ignored.
  -----------------------------------------------------------------------------
*/
module Instruction_Memory (
    input             clk,
    input wire [31:0] read_address,
    output reg [31:0] instruction_out
);

    wire [31:0] memory [0:127];
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin : instruction_bank
            register_32bit reg_inst (
                .D(Instructions.INSTRUCTIONS[i]),
                .CLK(clk),
                .RST(1'b0),
                .Q(memory[i]),
                .QN()
            );
        end
    endgenerate

    // Word-aligned address fetch
    always @(posedge clk) begin
        instruction_out = memory[read_address[8:2]];  // 7-bit index (128 entries)
    end

endmodule
