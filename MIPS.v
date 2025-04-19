module MIPS_TOP(
    input  clk,       
    input  reset,
    output done   
);

    wire [31:0] PC_out;                 // Output of Program_Counter
    wire [31:0] PC_in;                  // next PC value
    wire [31:0] PC_plus_4;              // Wire to hold the result of PC + 4 operation
    
    wire [31:0] instruction;            // Output of Instruction_Memory
    wire [4:0]  reg_write_addr;         // address to write in register file
    wire [4:0]  reg_write_mux_in;       // Output of mux selecting between instruction[20:16] or instruction[15:11]

    wire [31:0] extended_value;         // 16bit immediate value is extended to 32bit
    wire [31:0] extended_shifted_value; // extended value left shifted by 2bit
    wire [31:0] branch_target_addr;     // Target address for branching
    wire [31:0] jump_target_addr;       // Target address for jumping
    wire [31:0] jump_branch_mux;

    wire [31:0] reg_read_data1;         // Data read from register 1
    wire [31:0] reg_read_data2;         // Data read from register 2
    wire [31:0] alu_input2;             // output of mux to select between read_data2 and immediate value
    wire [2:0]  alu_ctrl;               // control signal for ALU
    wire [31:0] alu_result;             // result from ALU

    wire [31:0] data_mem_out;           // data from data_memory
    wire [31:0] wb_mux_out;
    wire [31:0] write_data_reg;         // final data to be written in register file

    // Wires for control unit
    wire RegDataJ, RegDst, RegDstJ, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0]  ALUOp;

    // Instantiate Control Unit
    Control_Unit CU (
        .opcode(instruction[31:26]),
        .RegDataJ(RegDataJ),
        .RegDst(RegDst),
        .RegDstJ(RegDstJ),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .Done(done)
    );

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
        .read_address(PC_out),
        .instruction_out(instruction)
    );

    // Instantiate Register File
    mux_2_1_5 write_reg_mux1 (
        .in0(instruction[20:16]),
        .in1(instruction[15:11]),
        .sel(RegDst),
        .out(reg_write_mux_in)
    );

    mux_2_1_5 write_reg_mux2 (
        .in0(reg_write_mux_in),
        .in1(5'd31),
        .sel(RegDstJ),
        .out(reg_write_addr)
    );

    Register_File RF(
        .read_reg1(instruction[25:21]),
        .read_reg2(instruction[20:16]),
        .write_reg(reg_write_addr),
        .write_data(write_data_reg),
        .write_en(RegWrite),
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

    // Instantiate jump address provider
    Jump_Address_Provider jap(
        .instruction(instruction[25:0]),
        .pc_4(PC_plus_4[31:28]),
        .jump_addr(jump_target_addr)
    );

    // Instantiate adder to calculate target branch address
    Adder_32bit add_branch_addr(
        .a(PC_plus_4),
        .b(extended_shifted_value),
        .cin(1'b0),
        .sum(jump_branch_mux),
        .cout() // it will never be used
    );

    wire branch_out, alu_zero;
    and(branch_out, Branch, alu_zero);
    mux_2_1_32 pc_in_mux1 (
        .in0(PC_plus_4),
        .in1(jump_branch_mux),
        .sel(branch_out),
        .out(branch_target_addr)
    );
    mux_2_1_32 pc_in_mux2 (
        .in0(branch_target_addr),
        .in1(jump_target_addr),
        .sel(Jump),
        .out(PC_in)
    );

    // Instantiate ALU 
    mux_2_1_32 alu_in_mux(
        .in0(reg_read_data2),
        .in1(extended_value),
        .sel(ALUSrc),
        .out(alu_input2)
    );

    ALU_32_bit ALU(
        .A(reg_read_data1),
        .B(alu_input2),
        .ctrl(alu_ctrl),
        .result(alu_result),
        .zero(alu_zero),
        .overflow() // might use as response flag in future
    );

    // Instantiate alu control unit
    ALU_control alu_ctrl_unit(
        .ALUOp(ALUOp),
        .funct(instruction[5:0]),
        .ALU_control_out(alu_ctrl)
    );

    // Instantiate dataMemory
    Data_Memory DM (
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite),
        .MemRead(MemRead), 
        .address(alu_result),
        .WriteData(reg_read_data2),
        .ReadData(data_mem_out)
    );
    mux_2_1_32 wb_mux1 (
        .in0(alu_result),
        .in1(data_mem_out),
        .sel(MemtoReg),
        .out(wb_mux_out)
    );
    mux_2_1_32 wb_mux2 (
        .in0(wb_mux_out),
        .in1(PC_plus_4),
        .sel(RegDataJ),
        .out(write_data_reg)
    );

    // Monitor signal for PC_out
    always @(posedge clk) begin
        $display("PC_out: %h", PC_out);
    end

endmodule