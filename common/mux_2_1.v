/*
 File: mux_2_1.v
 Description: 2x1 Multiplexer (Gate-Level Implementation)
    This module implements a 2-to-1 multiplexer using gate-level modeling.
    It selects one of the two input signals (in0 or in1) based on the value
    of the select signal (sel) and outputs the selected signal on the output (out).
*/

module mux_2_1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);

    // Internal wires for intermediate signals
    wire sel_n;
    wire and0_out;   
    wire and1_out;

    not(sel_n, sel);
    and(and0_out, in0, sel_n);
    and(and1_out, in1, sel);
    or(out, and0_out, and1_out);

endmodule