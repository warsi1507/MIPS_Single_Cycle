/*
   -----------------------------------------------------------------------------
   Module: Register_File
   Description:
   This file implements a 32-register file with 32-bit wide registers for a 
   single-cycle MIPS processor. It provides two read ports and one write port 
   for simultaneous operations. The module includes the following components:
  
   1. `decoder_5to32`: A 5-to-32 decoder to generate write enable signals for 
      the registers based on the write address and enable signal.
  
   2. `mux_32_1_32bit`: A 32-to-1 multiplexer to select the output data from 
      the specified register for the read ports.
  
   3. `register_32bit_en`: A 32-bit register with enable and asynchronous reset 
      functionality, used to implement each of the 32 registers.
  
   Features:
   - Two read ports (`read_data1`, `read_data2`) for simultaneous data reads.
   - One write port (`write_data`) with write enable control.
   - Asynchronous reset (`rst`) to clear all registers.
   - Clock signal (`clk`) to synchronize write operations.
   -----------------------------------------------------------------------------
*/

module decoder_5to32 (
    input [4:0] in,        // 5-bit input
    input enable,          // Enable signal
    output [31:0] out      // 32-bit output
);
    wire [4:0] n;          // Inverted inputs
    wire [31:0] raw_out;   // Raw decoded output before enabling

    // Invert each bit of input
    not (n[0], in[0]);
    not (n[1], in[1]);
    not (n[2], in[2]);
    not (n[3], in[3]);
    not (n[4], in[4]);

    // Generate raw decoded output using AND gates
    and (raw_out[0],  n[4], n[3], n[2], n[1], n[0]);
    and (raw_out[1],  n[4], n[3], n[2], n[1],  in[0]);
    and (raw_out[2],  n[4], n[3], n[2],  in[1], n[0]);
    and (raw_out[3],  n[4], n[3], n[2],  in[1],  in[0]);
    and (raw_out[4],  n[4], n[3],  in[2], n[1], n[0]);
    and (raw_out[5],  n[4], n[3],  in[2], n[1],  in[0]);
    and (raw_out[6],  n[4], n[3],  in[2],  in[1], n[0]);
    and (raw_out[7],  n[4], n[3],  in[2],  in[1],  in[0]);
    and (raw_out[8],  n[4],  in[3], n[2], n[1], n[0]);
    and (raw_out[9],  n[4],  in[3], n[2], n[1],  in[0]);
    and (raw_out[10], n[4],  in[3], n[2],  in[1], n[0]);
    and (raw_out[11], n[4],  in[3], n[2],  in[1],  in[0]);
    and (raw_out[12], n[4],  in[3],  in[2], n[1], n[0]);
    and (raw_out[13], n[4],  in[3],  in[2], n[1],  in[0]);
    and (raw_out[14], n[4],  in[3],  in[2],  in[1], n[0]);
    and (raw_out[15], n[4],  in[3],  in[2],  in[1],  in[0]);
    and (raw_out[16],  in[4], n[3], n[2], n[1], n[0]);
    and (raw_out[17],  in[4], n[3], n[2], n[1],  in[0]);
    and (raw_out[18],  in[4], n[3], n[2],  in[1], n[0]);
    and (raw_out[19],  in[4], n[3], n[2],  in[1],  in[0]);
    and (raw_out[20],  in[4], n[3],  in[2], n[1], n[0]);
    and (raw_out[21],  in[4], n[3],  in[2], n[1],  in[0]);
    and (raw_out[22],  in[4], n[3],  in[2],  in[1], n[0]);
    and (raw_out[23],  in[4], n[3],  in[2],  in[1],  in[0]);
    and (raw_out[24],  in[4],  in[3], n[2], n[1], n[0]);
    and (raw_out[25],  in[4],  in[3], n[2], n[1],  in[0]);
    and (raw_out[26],  in[4],  in[3], n[2],  in[1], n[0]);
    and (raw_out[27],  in[4],  in[3], n[2],  in[1],  in[0]);
    and (raw_out[28],  in[4],  in[3],  in[2], n[1], n[0]);
    and (raw_out[29],  in[4],  in[3],  in[2], n[1],  in[0]);
    and (raw_out[30],  in[4],  in[3],  in[2],  in[1], n[0]);
    and (raw_out[31],  in[4],  in[3],  in[2],  in[1],  in[0]);

    // Enable-controlled output: out[i] = enable & raw_out[i]
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : enable_block
            and (out[i], enable, raw_out[i]);
        end
    endgenerate

endmodule

module mux_32_1_1bit (
    input [31:0] in,   // 32 one-bit inputs
    input [4:0] sel,   // 5-bit selector
    output out         // selected one-bit output
);
    wire [15:0] l1;
    wire [7:0]  l2;
    wire [3:0]  l3;
    wire [1:0]  l4;

    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1)
            mux_2_1 m1 (.in0(in[2*i]), .in1(in[2*i+1]), .sel(sel[0]), .out(l1[i]));

        for (i = 0; i < 8; i = i + 1)
            mux_2_1 m2 (.in0(l1[2*i]), .in1(l1[2*i+1]), .sel(sel[1]), .out(l2[i]));

        for (i = 0; i < 4; i = i + 1)
            mux_2_1 m3 (.in0(l2[2*i]), .in1(l2[2*i+1]), .sel(sel[2]), .out(l3[i]));

        for (i = 0; i < 2; i = i + 1)
            mux_2_1 m4 (.in0(l3[2*i]), .in1(l3[2*i+1]), .sel(sel[3]), .out(l4[i]));
    endgenerate

    mux_2_1 m5 (.in0(l4[0]), .in1(l4[1]), .sel(sel[4]), .out(out));
endmodule

module mux_32_1_32bit (
    input [1023:0] in,      // Flattened  32 inputs of 32-bits each
    input [4:0] sel,        // 5-bit selector
    output [31:0] out       // 32-bit selected output
);
    genvar i, j;
    wire [31:0] bit_in [31:0];

    // wires from stacked registers
    generate
        for (i = 0; i < 32; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                assign bit_in[i][j] = in[i*32 + j];
            end
        end
    endgenerate

    // Use 32 1-bit multiplexers to select each bit of the output
    generate
        for (i = 0; i < 32; i = i + 1) begin : mux_bits
            mux_32_1_1bit bit_mux (
                .in({bit_in[31][i], bit_in[30][i], bit_in[29][i], bit_in[28][i], 
                      bit_in[27][i], bit_in[26][i], bit_in[25][i], bit_in[24][i], 
                      bit_in[23][i], bit_in[22][i], bit_in[21][i], bit_in[20][i], 
                      bit_in[19][i], bit_in[18][i], bit_in[17][i], bit_in[16][i], 
                      bit_in[15][i], bit_in[14][i], bit_in[13][i], bit_in[12][i], 
                      bit_in[11][i], bit_in[10][i], bit_in[9][i], bit_in[8][i], 
                      bit_in[7][i], bit_in[6][i], bit_in[5][i], bit_in[4][i], 
                      bit_in[3][i], bit_in[2][i], bit_in[1][i], bit_in[0][i]}),
                .sel(sel),
                .out(out[i])
            );
        end
    endgenerate
endmodule

module Register_File (
    input wire [4:0] read_reg1,   
    input wire [4:0] read_reg2,   
    input wire [4:0] write_reg,   
    input wire [31:0] write_data, 
    input wire write_en,          
    input wire clk,              
    input wire rst,              
    output wire [31:0] read_data1,
    output wire [31:0] read_data2 
);

    // 32 registers, each 32 bits wide
    wire [1023:0] registers;
    wire [31:0] write_enable;

    // Decoder to generate write enable signals for each register
    decoder_5to32 write_decoder (
        .in(write_reg),
        .enable(write_en),
        .out(write_enable)
    );

    // Generate 32 registers
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : reg_block
            register_32bit_en reg_inst (
                .D(write_data),
                .CLK(clk),
                .EN(write_enable[i]),
                .RST(rst),
                .Q(registers[i*32 + 31 : i*32]),
                .QN()
            );
        end
    endgenerate


    // Read data from the selected registers
    mux_32_1_32bit read_mux1 (
        .in(registers),
        .sel(read_reg1),
        .out(read_data1)
    );

    mux_32_1_32bit read_mux2 (
        .in(registers),
        .sel(read_reg2),
        .out(read_data2)
    );



endmodule