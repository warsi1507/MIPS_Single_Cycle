/*
    -----------------------------------------------------------------------------
    Module Name: Program_Counter
    Description: This module implements a Program Counter (PC) for a single-cycle
                             MIPS processor using a 2-to-1 multiplexer and a register module.
    -----------------------------------------------------------------------------

    Input Ports:
    - clk   : Clock signal. The PC is updated on the rising edge of this signal.
    - reset : Active-high reset signal. When asserted, the PC is reset to 0x00000000.
    - PC_in : 32-bit input representing the next instruction address to be loaded 
                        into the PC.

    Output Ports:
    - PC_out: 32-bit output representing the current value of the Program Counter.
*/

module Program_Counter(
        input                 clk,       // Clock signal
        input                 reset,     // Active-high reset signal
        input          [31:0] PC_in,     // 32-bit input for the next instruction address
        output reg     [31:0] PC_out     // 32-bit output for the current PC value
);
        wire [31:0] PC_out_wire;
        wire [31:0] mux_out; // Output of the multiplexer

        // Instantiate the 2-to-1 multiplexer
        mux_2_1_32 mux_inst (
                .sel(reset),         // Select signal (reset acts as the select signal)
                .in0(PC_in),         // Input 0 (next instruction address)
                .in1(32'h00000000),  // Input 1 (reset value)
                .out(mux_out)        // Output of the multiplexer
        );

        // Instantiate the register
        register_32bit reg_inst (
            .D(mux_out),        // Data input
            .CLK(clk),          // Clock input
            .RST(reset),        // Reset input
            .Q(PC_out_wire),    // Output
            .QN()               // Unused complement output
        );

        always @(*) begin
            PC_out = PC_out_wire;
        end
endmodule