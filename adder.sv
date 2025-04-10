// Jacob Panov
// This module implements a half adder, a one-bit full adder, a four-bit full adder,
// an eight-bit full adder, and a thirty-two-bit full adder using SystemVerilog.
// adder.sv

`include "definitions.v"

// Half Adder
module half_adder (
    input logic a,
    input logic b,
    output logic sum,
    output logic carry
);
    assign sum = a ^ b; // Sum is the XOR of a and b
    assign carry = a & b; // Carry is the AND of a and b
endmodule

// One-Bit Full Adder
module one_bit_full_adder (
    input logic a,
    input logic b,
    input logic carry_in,
    output logic sum,
    output logic carry_out
);
    logic sum_half, carry_half1, carry_half2;

    // First half adder
    half_adder ha1 (
        .a(a),
        .b(b),
        .sum(sum_half),
        .carry(carry_half1)
    );

    // Second half adder
    half_adder ha2 (
        .a(sum_half),
        .b(carry_in),
        .sum(sum),
        .carry(carry_half2)
    );

    // Final carry out
    assign carry_out = carry_half1 | carry_half2; // OR of the two carries
endmodule

// Four-Bit Full Adder
module four_bit_full_adder (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic carry_in,
    output logic [3:0] sum,
    output logic carry_out
);
    logic c1, c2, c3;

    // Instantiate four one-bit full adders
    one_bit_full_adder f1 (
        .a(a[0]),
        .b(b[0]),
        .carry_in(carry_in),
        .sum(sum[0]),
        .carry_out(c1)
    );

    one_bit_full_adder f2 (
        .a(a[1]),
        .b(b[1]),
        .carry_in(c1),
        .sum(sum[1]),
        .carry_out(c2)
    );

    one_bit_full_adder f3 (
        .a(a[2]),
        .b(b[2]),
        .carry_in(c2),
        .sum(sum[2]),
        .carry_out(c3)
    );

    one_bit_full_adder f4 (
        .a(a[3]),
        .b(b[3]),
        .carry_in(c3),
        .sum(sum[3]),
        .carry_out(carry_out)
    );
endmodule

// Eight-Bit Full Adder
module eight_bit_full_adder (
    input logic [7:0] a,
    input logic [7:0] b,
    input logic carry_in,
    output logic [7:0] sum,
    output logic carry_out
);
    logic c1;

    // Instantiate two four-bit full adders
    four_bit_full_adder f1 (
        .a(a[3:0]),
        .b(b[3:0]),
        .carry_in(carry_in),
        .sum(sum[3:0]),
        .carry_out(c1)
    );

    four_bit_full_adder f2 (
        .a(a[7:4]),
        .b(b[7:4]),
        .carry_in(c1),
        .sum(sum[7:4]),
        .carry_out(carry_out)
    );
endmodule

// Thirty-Two-Bit Full Adder
module thirty_two_bit_full_adder (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic carry_in,
    output logic [31:0] sum,
    output logic carry_out
);
    logic c1, c2, c3;

    // Instantiate four eight-bit full adders
    eight_bit_full_adder f1 (
        .a(a[7:0]),
        .b(b[7:0]),
        .carry_in(carry_in),
        .sum(sum[7:0]),
        .carry_out(c1)
    );

    eight_bit_full_adder f2 (
        .a(a[15:8]),
        .b(b[15:8]),
        .carry_in(c1),
        .sum(sum[15:8]),
        .carry_out(c2)
    );

    eight_bit_full_adder f3 (
        .a(a[23:16]),
        .b(b[23:16]),
        .carry_in(c2),
        .sum(sum[23:16]),
        .carry_out(c3)
    );

    eight_bit_full_adder f4 (
        .a(a[31:24]),
        .b(b[31:24]),
        .carry_in(c3),
        .sum(sum[31:24]),
        .carry_out(carry_out)
    );
endmodule

// Parameterized Adder
module parameterized_adder (
    input logic [`WORD_SIZE-1:0] in_1,
    input logic [`WORD_SIZE-1:0] in_2,
    output logic [`WORD_SIZE-1:0] out
);
    assign out = in_1 + in_2; // Simple addition
endmodule