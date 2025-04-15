module Instructions;

    reg [31:0] INSTRUCTIONS [0:127];
    initial begin
        INSTRUCTIONS[0] = 32'h20080005;
        INSTRUCTIONS[1] = 32'h8C090000;
        INSTRUCTIONS[2] = 32'h012A4020;
        INSTRUCTIONS[3] = 32'h00000000;
        INSTRUCTIONS[4] = 32'h012A4822;
        INSTRUCTIONS[5] = 32'h00000000;
        INSTRUCTIONS[6] = 32'hAC0A0004;
        INSTRUCTIONS[7] = 32'h08000003;
    end

endmodule