module MIPS_TOP(
    input clk,       // Clock signal
    input reset      // Reset signal
);

    // Wires to connect Program_Counter and Instruction_Memory
    wire [31:0] PC_out;          // Output of Program_Counter
    wire [31:0] instruction;     // Output of Instruction_Memory

    // Instantiate Program_Counter
    Program_Counter PC (
        .clk(clk),
        .reset(reset),
        .PC_in(),          // For now, connect PC_out back to PC_in (loopback)
        .PC_out(PC_out)
    );

    // Instantiate Instruction_Memory
    Instruction_Memory IM (
        .clk(clk),
        .read_address(PC_out),   // Use PC_out as the read address
        .instruction_out(instruction)
    );

endmodule