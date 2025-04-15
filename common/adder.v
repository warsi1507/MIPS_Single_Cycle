/*
  Description:
  This module implements a 1-bit Full Adder. A Full Adder is a combinational circuit
  that performs the addition of three binary inputs: two significant bits (a and b)
  and a carry-in (cin). It produces two outputs: the sum and a carry-out (cout).
 
  Ports:
  - input wire a: First input bit for the addition.
  - input wire b: Second input bit for the addition.
  - input wire cin: Carry-in bit from the previous stage.
  - output wire sum: Resulting sum bit of the addition.
  - output wire cout: Carry-out bit to the next stage.
 
  Internal Logic:
  - The sum is calculated using two XOR gates: one for the inputs a and b, and another
    for the result of the first XOR and the carry-in (cin).
  - The carry-out is determined using two AND gates and one OR gate. The carry is
    generated if both a and b are 1 (carry_gen), or if the XOR of a and b is 1 and
    cin is also 1 (carry_prop).
*/

module FullAdder_1bit (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Internal wires
    wire ab_xor, carry_prop, carry_gen;

    // Logic for Sum
    xor (ab_xor, a, b);
    xor (sum, ab_xor, cin);

    // Logic for Carry Out
    and (carry_gen, a, b);
    and (carry_prop, ab_xor, cin);
    or  (cout, carry_gen, carry_prop);

endmodule
