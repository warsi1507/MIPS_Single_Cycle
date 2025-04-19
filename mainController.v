/*
-------------------------------------------------------------------------------
 Module: Control_Unit
 Description: This module implements the main control unit for a single-cycle
              MIPS processor. It generates control signals based on the 
              opcode of the instruction being executed. The control signals 
              are used to configure various components of the processor, 
              such as the ALU, register file, memory, and datapath.

              The module supports the following instructions:
              - R-type instructions
              - Load word (lw)
              - Store word (sw)
              - Add immediate (addi)
              - Jump (j)
              - Jump and link (jal)
              - Jump register (jr)
              - Branch on equal (beq)
              - Halt (custom instruction)

 Inputs:
   - opcode: 6-bit instruction opcode that determines the type of instruction.

 Outputs:
   - JumpR: Control signal for enabling jump register instructions.
   - RegDataJ: Control signal for selecting data for the register file in JAL.
   - RegDst: Control signal for selecting the destination register.
   - RegDstJ: Control signal for selecting the destination register in JAL.
   - Jump: Control signal for enabling jump instructions.
   - Branch: Control signal for enabling branch instructions.
   - MemRead: Control signal for enabling memory read operations.
   - MemtoReg: Control signal for selecting data from memory to write to a register.
   - ALUOp: 2-bit control signal for selecting the ALU operation.
   - MemWrite: Control signal for enabling memory write operations.
   - ALUSrc: Control signal for selecting the ALU input source.
   - RegWrite: Control signal for enabling register write operations.
   - Done: Control signal indicating the halt state for the processor.
-------------------------------------------------------------------------------
*/

module Control_Unit (
    input  wire [5:0] opcode,
    output reg        JumpR,
    output reg        RegDataJ,
    output reg        RegDst,
    output reg        RegDstJ,
    output reg        Jump,
    output reg        Branch,
    output reg        MemRead,
    output reg        MemtoReg,
    output reg  [1:0] ALUOp,
    output reg        MemWrite,
    output reg        ALUSrc,
    output reg        RegWrite,
    output reg        Done
);

    always @(*) begin
        case (opcode)
            6'b000000: begin // R-type
                JumpR     = 0;
                RegDataJ  = 0;
                RegDst    = 1;
                RegDstJ   = 0;
                Jump      = 0;
                Branch    = 0;
                MemRead   = 0;
                MemtoReg  = 0;
                ALUOp     = 2'b10;
                MemWrite  = 0;
                ALUSrc    = 0;
                RegWrite  = 1;
                Done      = 0;
            end
            6'b100011: begin // lw
                JumpR     = 0;
                RegDataJ  = 0;
                RegDst    = 0;
                RegDstJ   = 0;
                Jump      = 0;
                Branch    = 0;
                MemRead   = 1;
                MemtoReg  = 1;
                ALUOp     = 2'b00;
                MemWrite  = 0;
                ALUSrc    = 1;
                RegWrite  = 1;
                Done      = 0;
            end
            6'b101011: begin // sw
                JumpR     = 0;
                RegDataJ  = 0; // Don't care
                RegDst    = 0; // Don't care
                RegDstJ   = 0; // Don't care
                Jump      = 0;
                Branch    = 0;
                MemRead   = 0;
                MemtoReg  = 0; // Don't care
                ALUOp     = 2'b00;
                MemWrite  = 1;
                ALUSrc    = 1;
                RegWrite  = 0;
                Done      = 0;
            end
            6'b001000: begin // addi
                JumpR     = 0; 
                RegDataJ  = 0;
                RegDst    = 0;
                RegDstJ   = 0;
                Jump      = 0;
                Branch    = 0;
                MemRead   = 0;
                MemtoReg  = 0;
                ALUOp     = 2'b00;
                MemWrite  = 0;
                ALUSrc    = 1; 
                RegWrite  = 1;
                Done      = 0;
            end
            6'b000010: begin // j
                JumpR     = 0;
                RegDataJ  = 0; // Don't care
                RegDst    = 0; // Don't care
                RegDstJ   = 0; // Don't care
                Jump      = 1;
                Branch    = 0; // Don't care
                MemRead   = 0;
                MemtoReg  = 0; // Don't care
                ALUOp     = 2'b00; // Don't care
                MemWrite  = 0;
                ALUSrc    = 0; // Don't care
                RegWrite  = 0;
                Done      = 0;
            end
            6'b000011: begin // jal
                JumpR     = 0;
                RegDataJ  = 1;
                RegDst    = 0; // Don't care
                RegDstJ   = 1;
                Jump      = 1;
                Branch    = 0; // Don't care
                MemRead   = 0;
                MemtoReg  = 0; // Don't care
                ALUOp     = 2'b00; // Don't care
                MemWrite  = 0;
                ALUSrc    = 0; // Don't care
                RegWrite  = 1;
                Done      = 0;
            end
            6'b000001: begin // jr
                JumpR     = 1;
                RegDataJ  = 0; // Don't care
                RegDst    = 0; // Don't care
                RegDstJ   = 0; // Don't care
                Jump      = 0;
                Branch    = 0;
                MemRead   = 0; // Don't care
                MemtoReg  = 0; // Don't care
                ALUOp     = 2'b00; // Don't care
                MemWrite  = 0;
                ALUSrc    = 0; // Don't care
                RegWrite  = 0;
                Done      = 0;
            end
            6'b000100: begin // beq
                JumpR     = 0;
                RegDataJ  = 0; // Don't care
                RegDst    = 0; // Don't care
                RegDstJ   = 0; // Don't care
                Jump      = 0;
                Branch    = 1;
                MemRead   = 0;
                MemtoReg  = 0; // Don't care
                ALUOp     = 2'b01;
                MemWrite  = 0;
                ALUSrc    = 0;
                RegWrite  = 0;
                Done      = 0;
            end
            6'b111111: begin // halt (custom instruction)
                JumpR     = 0;
                RegDataJ  = 0;
                RegDst    = 0;
                RegDstJ   = 0;
                Jump      = 0;
                Branch    = 0;
                MemRead   = 0;
                MemtoReg  = 0;
                ALUOp     = 2'b00;
                MemWrite  = 0;
                ALUSrc    = 0;
                RegWrite  = 0;
                Done      = 1;
            end
        endcase
    end

endmodule