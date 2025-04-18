/*
    Description:
    This module implements a 32-bit Ripple Carry Adder. It performs the addition of two
    32-bit binary numbers (a and b) along with an optional carry-in (cin) and produces
    a 32-bit sum and a carry-out (cout). The adder is constructed using 32 instances of
    1-bit Full Adders connected in a ripple-carry configuration.

    Ports:
    - input wire [31:0] a: First 32-bit input operand.
    - input wire [31:0] b: Second 32-bit input operand.
    - input wire cin: Carry-in bit for the least significant bit addition.
    - output wire [31:0] sum: 32-bit result of the addition.
    - output wire cout: Carry-out bit from the most significant bit addition.

    Internal Logic:
    - The addition is performed bit by bit using Full Adders. The carry-out of each
      Full Adder is propagated to the carry-in of the next Full Adder in the chain.
*/

module Adder_32bit (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire cin,
    output wire [31:0] sum,
    output wire cout
);
    // Internal carry signals
    wire [31:0] carry;

    // Instantiate 32 Full Adders
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : full_adder_chain
            if (i == 0) begin
                // First Full Adder (uses cin as carry-in)
                FullAdder_1bit FA (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else begin
                // Remaining Full Adders (use carry from previous stage)
                FullAdder_1bit FA (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate

    assign cout = carry[31];

endmodule
