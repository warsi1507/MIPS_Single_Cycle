module Jump_Address_Provider (
    input  [25:0] instruction,   // from instruction[25:0]
    input  [3:0]  pc_4,          // from PC+4[31:28]
    output [31:0] jump_addr
);
    assign jump_addr = {pc_4, instruction, 2'b00};
endmodule