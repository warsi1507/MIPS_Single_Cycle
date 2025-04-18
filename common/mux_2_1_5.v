/*
    Module: mux_2_1_5_bits
    Description: This module implements a 5-bit 2-to-1 multiplexer using gate-level modeling.
                             It selects one of the two 5-bit inputs (in0 or in1) based on the select signal (sel).
    Inputs:
        - in0: 5-bit input 0
        - in1: 5-bit input 1
        - sel: 1-bit select signal
    Output:
        - out: 5-bit output based on the selected input
*/

module mux_2_1_5 (
    input [4:0] in0,
    input [4:0] in1,
    input sel,
    output [4:0] out
);

    // Generate 5-bit output using gate-level modeling
    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : mux_bit
            mux_2_1 u_mux_2_1 (
                .in0(in0[i]),
                .in1(in1[i]),
                .sel(sel),
                .out(out[i])
            );
        end
    endgenerate

endmodule
