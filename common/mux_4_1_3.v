/*
    Description:
    This module implements a 3-bit wide 4-to-1 multiplexer. It takes four 3-bit input vectors
    (in0, in1, in2, in3) and selects one of them based on a 2-bit select signal (sel). The selected
    3-bit output is provided on the 'out' port. Internally, it instantiates three single-bit 4-to-1
    multiplexers (mux_4_1) to handle each bit of the 3-bit input vectors.

    Ports:
    - input wire [2:0] in0, in1, in2, in3: Four 3-bit input vectors.
    - input wire [1:0] sel: 2-bit select signal to choose one of the four input vectors.
    - output wire [2:0] out: 3-bit output vector corresponding to the selected input.

    Dependencies:
    - This module depends on the 'mux_4_1' module, which implements a single-bit 4-to-1 multiplexer.
*/

module mux_4_1_3 (
    input wire [2:0] in0,
    input wire [2:0] in1,
    input wire [2:0] in2,
    input wire [2:0] in3,
    input wire [1:0] sel,
    output wire [2:0] out
);
    mux_4_1 m1 (.in0(in0[0]), .in1(in1[0]), .in2(in2[0]), .in3(in3[0]), .sel(sel), .out(out[0]));
    mux_4_1 m2 (.in0(in0[1]), .in1(in1[1]), .in2(in2[1]), .in3(in3[1]), .sel(sel), .out(out[1]));
    mux_4_1 m3 (.in0(in0[2]), .in1(in1[2]), .in2(in2[2]), .in3(in3[2]), .sel(sel), .out(out[2]));
endmodule
