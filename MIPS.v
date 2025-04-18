module MIPS_TOP(
    input clk,       
    input reset      
);

    wire [31:0] PC_out;          // Output of Program_Counter
    wire [31:0] instruction;     // Output of Instruction_Memory
    wire [4:0]  reg_write_addr;  // address to write in register file
    wire [31:0] extended_value;  // 16bit immediate value is extended to 32bit
    wire [31:0] extended_shifted_value; // extended value left shifted by 2bit
    wire [31:0] branch_target_addr;     // Target address for branching
    wire [31:0] PC_plus_4;       // Wire to hold the result of PC + 4 operation
    wire [31:0] PC_in;           // next PC value
    wire [31:0] reg_read_data1;  // Data read from register 1
    wire [31:0] reg_read_data2;  // Data read from register 2
    wire [31:0] alu_input2;      // output of mux to select between read_data2 and immediate value

    // Instantiate Program_Counter
    Program_Counter PC (
        .clk(clk),
        .reset(reset),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );

    // Instantiate PC Adder (PC = PC + 4)
    Adder_32bit PC_add_4 (
        .a(PC_out),
        .b(32'd4),
        .cin(1'b0),
        .sum(PC_plus_4),
        .cout() // it will never be used
    );

    // Instantiate Instruction_Memory
    Instruction_Memory IM (
        .clk(clk),
        .read_address(PC_out),   // Use PC_out as the read address
        .instruction_out(instruction)
    );

    // Instantiate Register File
    mux_2_1_5 write_reg_mux(
        .in0(instruction[20:16]),
        .in1(instruction[15:11]),
        .sel(), // TODO RegDst From main Controller
        .out(reg_write_addr)
    );
    Register_File RF(
        .read_reg1(instruction[25:21]),
        .read_reg2(instruction[20:16]),
        .write_reg(reg_write_addr),
        .write_data(), // TODO op from data memory
        .write_en(), // TODO regWrite from main controller
        .clk(clk),
        .rst(reset),
        .read_data1(reg_read_data1),
        .read_data2(reg_read_data2)
    );

    // Instantiate Sign-Extender
    SignExtend signEx(
        .inst15_0(instruction[15:0]),
        .Extend32(extended_value)
    );

    // Instantiate Shift left by 2
    shiftLeft2 shiftLf(
        .in(extended_value),
        .out(extended_shifted_value)
    );

    // Instantiate adder to calculate target branch address
    Adder_32bit add_branch_addr(
        .a(PC_plus_4),
        .b(extended_shifted_value),
        .cin(1'b0),
        .sum(branch_target_addr),
        .cout() // it will never be used
    );
    mux_2_1_32 pc_in_mux(
        .in0(PC_plus_4),
        .in1(branch_target_addr),
        .sel(), // TODO Branch & zero (main ctrl and ALU)
        .out(PC_in)
    );

    // Instantiate ALU 
    mux_2_1_32 alu_in_mux(
        .in0(reg_read_data2),
        .in1(extended_value),
        .sel(), // TODO ALUSrc from main control
        .out(alu_input2)
    );

    ALU_32_bit ALU(
        .A(reg_read_data1),
        .B(alu_input2),
        .ctrl(), // TODO ALU control
        .result(), // TODO send to data_memory
        .zero(), // TODO send to and with branch from main control
        .overflow() // might use as response flag in future
    );

endmodule