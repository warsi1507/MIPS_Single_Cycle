/*
    -----------------------------------------------------------------------------
     Module: Instruction_Memory
     Description: 
     This module implements an instruction memory for a single-cycle MIPS processor. 
     It stores instructions in a memory array and outputs the instruction 
     corresponding to the provided read address. The memory consists of 128 
     32-bit words.
        
     Inputs:
     - clk: Clock signal.
     - read_address: 32-bit address used to fetch the instruction.
        
     Outputs:
     - instruction_out: 32-bit instruction retrieved from memory.
        
     Notes:
     - The memory is initialized from an external file ("instructions.txt").
     - Only the lower 7 bits of the read address are used, as the memory is 
       word-aligned and the lower 2 bits are ignored.
    -----------------------------------------------------------------------------
*/
module Instruction_Memory (
    input wire [31:0] read_address,
    output reg [31:0] instruction_out
);

    reg [31:0] memory [0:127];
    initial begin
        $readmemh("instructions.txt", memory);
    end

    // Word-aligned address fetch
    always @(*) begin
        instruction_out <= memory[read_address[8:2]];
    end

endmodule
