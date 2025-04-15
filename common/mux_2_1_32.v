/*
  Module: mux_2_1_32_bits
  Description: This module implements a 32-bit 2-to-1 multiplexer using gate-level modeling.
             It selects one of the two 32-bit inputs (in0 or in1) based on the select signal (sel).
  Inputs:
    - in0: 32-bit input 0
    - in1: 32-bit input 1
    - sel: 1-bit select signal
  Output:
    - out: 32-bit output based on the selected input
*/


module mux_2_1_32 (
    input [31:0] in0,
    input [31:0] in1,
    input sel,
    output [31:0] out
);

    // Generate 32-bit output using gate-level modeling
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : mux_bit
            wire not_sel, and0, and1;
            not (not_sel, sel);          // NOT gate for sel
            and (and0, in0[i], not_sel); // AND gate for in0 and not_sel
            and (and1, in1[i], sel);     // AND gate for in1 and sel
            or (out[i], and0, and1);     // OR gate to combine the two AND gates
        end
    endgenerate

endmodule