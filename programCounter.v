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
        input             clk,       
        input             reset,     
        input      [31:0] PC_in,     
        output     [31:0] PC_out    
);
        wire [31:0] PC_out_wire;
        wire [31:0] mux_out;

        // Instantiate the 2-to-1 multiplexer
        mux_2_1_32 mux_inst (
                .sel(reset),         
                .in0(PC_in),         
                .in1(32'h00000000),  
                .out(mux_out)        
        );

        // Instantiate the register
        register_32bit reg_inst (
            .D(mux_out),        
            .CLK(clk),          
            .RST(reset),        
            .Q(PC_out_wire),  
            .QN()             
        );

        assign PC_out = PC_out_wire;
endmodule