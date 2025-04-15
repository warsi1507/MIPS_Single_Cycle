/*
  Module: 4x1 Multiplexer (mux_4_1)
  Description: This module implements a 4-to-1 multiplexer using gate-level modeling.
               The multiplexer selects one of the four input signals (in0, in1, in2, in3)
               based on the 2-bit select signal (sel) and outputs the selected input on 'out'.
  Inputs:
    - in0, in1, in2, in3: 1-bit input signals
    - sel: 2-bit select signal
  Output:
    - out: 1-bit output signal
*/

module mux_4_1 (
    input  wire in0,
    input  wire in1,
    input  wire in2,
    input  wire in3,
    input  wire [1:0] sel,
    output wire out
);

    // Intermediate wires for AND gates
    wire and0, and1, and2, and3;

    // Decode select lines and generate AND gates
    and (and0, in0, ~sel[1], ~sel[0]);
    and (and1, in1, ~sel[1], sel[0]);
    and (and2, in2, sel[1], ~sel[0]);
    and (and3, in3, sel[1], sel[0]);

    // OR gate to combine the outputs of the AND gates
    or (out, and0, and1, and2, and3);

endmodule