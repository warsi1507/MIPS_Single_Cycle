/*
  Module: shiftLeft2
  Description: This module performs a logical left shift operation by 2 positions
               on a 32-bit input signal. The two least significant bits (LSBs) 
               of the output are filled with zeros.
 
  Ports:
    - input [31:0] in:
        The 32-bit input signal to be shifted left by 2 positions.
    - output [31:0] out:
        The 32-bit output signal resulting from the left shift operation.
 
  Functionality:
    - The input signal `in` is shifted left by 2 positions.
    - The two least significant bits of the output `out` are set to 0.
    - The most significant bits of the output `out` are filled with the 
      corresponding bits from the input `in`.
*/

module shiftLeft2(
    input [31:0] in,
    output [31:0] out
);
    // Shift left by 2 positions
    assign out[31:2] = in[29:0];
    assign out[1:0] = 2'b00;
endmodule