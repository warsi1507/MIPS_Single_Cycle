/*
  -----------------------------------------------------------------------------
   Module: ALU_32_bit
   Description: 
    This file contains the Verilog implementation of a 32-bit ALU (Arithmetic Logic Unit) 
    for a single-cycle MIPS processor. The ALU supports basic arithmetic and logical 
    operations, including addition, subtraction, AND, OR, and set-on-less-than (SLT). 
    It also computes the zero flag and overflow flag for certain operations.
    The file includes the following sub-modules:

    1. `alu_1bit`: A 1-bit ALU that performs AND, OR, addition, and SLT operations.
    2. `alu_last_bit`: A 1-bit ALU for the most significant bit with overflow and SLT support.
    3. `or_reduce_32_bit`: Reduces a 32-bit input to a single bit using an OR tree.
  -----------------------------------------------------------------------------
  
 `ALU_32_bit`: The top-level 32-bit ALU module.
   - Inputs:
     - `A`, `B`: 32-bit operands.
     - `ctrl`: 3-bit control signal for operation selection.
   - Outputs:
     - `result`: 32-bit operation result.
     - `zero`: Indicates if the result is zero.
     - `overflow`: Overflow flag for addition.
   - Structure:
     - Instantiates 1-bit ALUs for each bit of the operands.
     - Handles subtraction by inverting `B` and setting carry-in.
     - Computes `zero` using `or_reduce_32_bit`.
*/

module alu_1bit (
    input  wire       a,
    input  wire       b,
    input  wire       less,
    input  wire       cin,
    input  wire       b_inv,
    input  wire [1:0] ops,
    output wire       cout,
    output wire       result
);

    // Internal signals
    wire b_inverted, ab_and, ab_or, ab_sum, b_mux_out;

    // Generate inverted b if b_inv is asserted
    not u_not(b_inverted, b);
    mux_2_1 u_mux_b(
        .in0(b), 
        .in1(b_inverted), 
        .sel(b_inv), 
        .out(b_mux_out)
    );

    // Perform AND, OR, and addition operations
    and u_and(ab_and, a, b);
    or  u_or(ab_or, a, b);
    FullAdder_1bit u_fa(
        .a(a), 
        .b(b_mux_out), 
        .cin(cin), 
        .sum(ab_sum), 
        .cout(cout)
    );

    // Select the final result based on ops
    mux_4_1 u_mux_result(
        .in0(ab_and), 
        .in1(ab_or), 
        .in2(ab_sum), 
        .in3(less), 
        .sel(ops), 
        .out(result)
    );

endmodule

module alu_last_bit (
    input  wire       a,
    input  wire       b,
    input  wire       less,
    input  wire       cin,
    input  wire       b_inv,
    input  wire [1:0] ops,
    output wire       set,
    output wire       overflow,
    output wire       result
);

    // Internal signals
    wire b_inverted, ab_and, ab_or, ab_sum, b_mux_out, cout;

    // Generate inverted b if b_inv is asserted
    not u_not(b_inverted, b);
    mux_2_1 u_mux_b(
        .in0(b), 
        .in1(b_inverted), 
        .sel(b_inv), 
        .out(b_mux_out)
    );

    // Perform AND, OR, and addition operations
    and u_and(ab_and, a, b);
    or  u_or(ab_or, a, b);
    FullAdder_1bit u_fa(
        .a(a), 
        .b(b_mux_out), 
        .cin(cin), 
        .sum(ab_sum), 
        .cout(cout)
    );

    // Select the final result based on ops
    mux_4_1 u_mux_result(
        .in0(ab_and), 
        .in1(ab_or), 
        .in2(ab_sum), 
        .in3(less), 
        .sel(ops), 
        .out(result)
    );

    // Compute overflow and set signals
    wire xor1_out, xor2_out, and_out;

    // Compute overflow using gate-level implementation
    xor u_xor1(xor1_out, a, ab_sum);
    xor u_xor2(xor2_out, b_mux_out, ab_sum);
    and u_and1(and_out, xor1_out, xor2_out);

    assign overflow = and_out;
    xor(set, ab_sum, overflow);

endmodule

module or_reduce_32_bit (
    input  wire [31:0] A,
    output wire        result
);

    // Gate-level implementation of OR reduction
    wire [15:0] or_stage1;
    wire [7:0]  or_stage2;
    wire [3:0]  or_stage3;
    wire [1:0]  or_stage4;

    // First stage: OR pairs of bits
    or u_or1(or_stage1[0], A[0], A[1]);
    or u_or2(or_stage1[1], A[2], A[3]);
    or u_or3(or_stage1[2], A[4], A[5]);
    or u_or4(or_stage1[3], A[6], A[7]);
    or u_or5(or_stage1[4], A[8], A[9]);
    or u_or6(or_stage1[5], A[10], A[11]);
    or u_or7(or_stage1[6], A[12], A[13]);
    or u_or8(or_stage1[7], A[14], A[15]);
    or u_or9(or_stage1[8], A[16], A[17]);
    or u_or10(or_stage1[9], A[18], A[19]);
    or u_or11(or_stage1[10], A[20], A[21]);
    or u_or12(or_stage1[11], A[22], A[23]);
    or u_or13(or_stage1[12], A[24], A[25]);
    or u_or14(or_stage1[13], A[26], A[27]);
    or u_or15(or_stage1[14], A[28], A[29]);
    or u_or16(or_stage1[15], A[30], A[31]);

    // Second stage: OR pairs of results from the first stage
    or u_or17(or_stage2[0], or_stage1[0], or_stage1[1]);
    or u_or18(or_stage2[1], or_stage1[2], or_stage1[3]);
    or u_or19(or_stage2[2], or_stage1[4], or_stage1[5]);
    or u_or20(or_stage2[3], or_stage1[6], or_stage1[7]);
    or u_or21(or_stage2[4], or_stage1[8], or_stage1[9]);
    or u_or22(or_stage2[5], or_stage1[10], or_stage1[11]);
    or u_or23(or_stage2[6], or_stage1[12], or_stage1[13]);
    or u_or24(or_stage2[7], or_stage1[14], or_stage1[15]);

    // Third stage: OR pairs of results from the second stage
    or u_or25(or_stage3[0], or_stage2[0], or_stage2[1]);
    or u_or26(or_stage3[1], or_stage2[2], or_stage2[3]);
    or u_or27(or_stage3[2], or_stage2[4], or_stage2[5]);
    or u_or28(or_stage3[3], or_stage2[6], or_stage2[7]);

    // Fourth stage: OR pairs of results from the third stage
    or u_or29(or_stage4[0], or_stage3[0], or_stage3[1]);
    or u_or30(or_stage4[1], or_stage3[2], or_stage3[3]);

    // Final stage: OR the last two results
    or u_or31(result, or_stage4[0], or_stage4[1]);

endmodule

module ALU_32_bit (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [2:0]  ctrl,
    output wire [31:0] result,
    output wire        zero,
    output wire        overflow
);

    // Internal signals
    wire [30:0] carry;
    wire        set_wire, zero_inv, cin;

    // cin = 1 if subtraction
    mux_2_1 mux_cin(
        .in0(1'b0),
        .in1(1'b1),
        .sel(ctrl[2]),
        .out(cin)
    );

    // Instantiate the least significant bit ALU
    alu_1bit alu_0(
        .a(A[0]), 
        .b(B[0]), 
        .less(set_wire), 
        .cin(cin), 
        .b_inv(ctrl[2]), 
        .ops(ctrl[1:0]), 
        .cout(carry[0]), 
        .result(result[0])
    );

    // Generate ALU instances for intermediate bits
    genvar i;
    generate
        for (i = 1; i < 31; i = i + 1) begin
            alu_1bit u_alu(
                .a(A[i]), 
                .b(B[i]), 
                .less(1'b0), 
                .cin(carry[i-1]), 
                .b_inv(ctrl[2]), 
                .ops(ctrl[1:0]), 
                .cout(carry[i]), 
                .result(result[i])
            );
        end
    endgenerate

    // Instantiate the most significant bit ALU
    alu_last_bit alu_31(
        .a(A[31]),
        .b(B[31]),
        .less(1'b0),
        .cin(carry[30]),
        .b_inv(ctrl[2]),
        .ops(ctrl[1:0]),
        .set(set_wire),
        .overflow(overflow),
        .result(result[31])
    );


    // Compute the zero flag using OR reduction
    or_reduce_32_bit u_or_bits(
        .A(result),
        .result(zero_inv)
    );
    
    not(zero, zero_inv);
endmodule
