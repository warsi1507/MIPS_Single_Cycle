/*
    Module: funct_to_ALU_control
    ----------------------------
    Description:
        This module maps the 6-bit function code (`funct`) from the instruction
        to a 3-bit ALU control signal (`ALU_control_out`). It uses basic logic
        gates to generate the control signals based on specific bits of the
        function code.

    Inputs:
        - funct [5:0]: 6-bit function code from the instruction.

    Outputs:
        - ALU_control_out [2:0]: 3-bit ALU control signal for the ALU.

    Module: ALU_control
    --------------------
    Description:
        This module generates the final 3-bit ALU control signal (`ALU_control_out`)
        based on the 2-bit ALU operation (`ALUOp`) and the 6-bit function code (`funct`).
        It uses the `funct_to_ALU_control` module to process the function code and a
        4-to-1 multiplexer (`mux_4_1_3`) to select the appropriate control signal
        based on the ALU operation.

    Inputs:
        - ALUOp [1:0]: 2-bit ALU operation code indicating the type of operation.
        - funct [5:0]: 6-bit function code from the instruction.

    Outputs:
        - ALU_control_out [2:0]: 3-bit ALU control signal for the ALU.
*/

module funct_to_ALU_control(
    input  [5:0] funct,
    output [2:0] ALU_control_out
);
    wire and_f3_f1, n_f2;

    and(and_f3_f1 , funct[3], funct[1]);
    or(ALU_control_out[0], and_f3_f1, funct[0]);

    not(n_f2, funct[2]);
    or(ALU_control_out[1], n_f2, funct[3]);

    assign ALU_control_out[2] = funct[1];
endmodule


module ALU_control(
    input  [1:0] ALUOp,
    input  [5:0] funct,
    output [2:0] ALU_control_out
);
    wire [2:0] funct_control_out;
    funct_to_ALU_control f2a(.funct(funct), .ALU_control_out(funct_control_out));
    mux_4_1_3 m1(.in0(3'b010), .in1(3'b110), .in2(funct_control_out), .in3(3'b101), .sel(ALUOp), .out(ALU_control_out));
endmodule