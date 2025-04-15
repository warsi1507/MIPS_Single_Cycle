/*
    File: register_en.v
    Description: Gate-level D Flip-Flop with enable signal using two D latches with asynchronous active-high reset.
                             Includes both 1-bit and 32-bit versions with enable functionality.
*/

///////////////////////////
// 1-Bit D Flip-Flop Register with Enable
///////////////////////////
module register_1bit_en (
        input wire D,     // Data input
        input wire CLK,   // Clock input
        input wire EN,    // Enable signal
        input wire RST,   // Asynchronous reset (active high)
        output wire Q,    // Output
        output wire QN    // Complement output
);

        wire Qm;

        // Master latch (transparent when CLK is low)
        dlatch_en master (
                .D(D),
                .EN(~CLK & EN), // Enable only when CLK is low and EN is high
                .RST(RST),
                .Q(Qm),
                .QN()
        );

        // Slave latch (transparent when CLK is high)
        dlatch_en slave (
                .D(Qm),
                .EN(CLK & EN), // Enable only when CLK is high and EN is high
                .RST(RST),
                .Q(Q),
                .QN(QN)
        );

endmodule

///////////////////////////
// 32-Bit D Flip-Flop Register with Enable
///////////////////////////
module register_32bit_en (
        input wire [31:0] D,    // 32-bit data input
        input wire CLK,         // Clock input
        input wire EN,          // Enable signal
        input wire RST,         // Asynchronous reset
        output wire [31:0] Q,   // 32-bit data output
        output wire [31:0] QN   // 32-bit complement output
);

        genvar i;
        generate
                for (i = 0; i < 32; i = i + 1) begin : reg_bit_en
                        wire QN_unused; // Unused QN, can be wired out if needed
                        register_1bit_en reg_inst (
                                .D(D[i]),
                                .CLK(CLK),
                                .EN(EN),
                                .RST(RST),
                                .Q(Q[i]),
                                .QN(QN[i])
                        );
                end
        endgenerate

endmodule

///////////////////////////
// D Latch with Enable and Asynchronous Reset
///////////////////////////
module dlatch_en (
        input wire D,     // Data input
        input wire EN,    // Enable
        input wire RST,   // Asynchronous reset (active high)
        output wire Q,    // Output
        output wire QN    // Complement output
);

        wire Dn;
        wire S, R;
        wire Qa, Qna;

        // Invert D
        not (Dn, D);

        // AND gates for S and R
        and (S, D, EN);
        and (R, Dn, EN);

        // SR Latch with reset logic
        wire SR_R, SR_S;
        wire rstn;                   
        not (rstn, RST);

        and (SR_S, S, rstn);              // S active only when not in reset
        or  (SR_R, R, RST);               // R is forced high during reset

        // SR latch
        nor (Qa, SR_R, Qna);
        nor (Qna, SR_S, Qa);

        assign Q = Qa;
        assign QN = Qna;

endmodule