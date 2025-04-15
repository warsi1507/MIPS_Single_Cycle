/*
 -----------------------------------------------------------------------------
  Module: SignExtend
  Description: This module performs sign extension on a 16-bit input to 
               produce a 32-bit output. The sign extension replicates the 
               most significant bit (MSB) of the input to fill the upper 
               16 bits of the output.
 -----------------------------------------------------------------------------
*/

module SignExtend (
    input      [15:0] inst15_0,   // 16-bit input to be sign-extended
    output reg [31:0] Extend32    // 32-bit sign-extended output
);

    always @(*) begin
        // Perform sign extension by replicating the MSB of the input
        Extend32 <= {{16{inst15_0[15]}}, inst15_0};
    end
endmodule