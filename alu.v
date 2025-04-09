// Jacob Panov
// This module implements a 32-bit ALU (Arithmetic Logic Unit) with various operations.
// alu.v

`include "definitions.v"

module alu (in_1, in_2, alu_op, out, zero);
    input wire [`WORD_SIZE-1:0] in_1, in_2; // 32-bit inputs
    input wire [3:0] alu_op; // ALU operation code
    output reg [`WORD_SIZE-1:0] out; // 32-bit output
    output reg zero; // Zero flag

    always @(*) begin
        case (alu_op)
            `ALU_ADD: out = in_1 + in_2;
            `ALU_SUB: out = in_1 - in_2;
            `ALU_AND: out = in_1 & in_2;
            `ALU_OR:  out = in_1 | in_2;
            `ALU_NOR: out = ~(in_1 | in_2);
            `ALU_XOR: out = in_1 ^ in_2;
            `ALU_SLA: out = in_1 << 1; // Shift left arithmetic
            `ALU_SLL: out = in_1 << 1; // Shift left logical
            `ALU_SRA: out = in_1 >> 1; // Shift right arithmetic
            `ALU_SRL: out = in_1 >> 1; // Shift right logical
            default:  out = {`WORD_SIZE{1'bx}}; // Undefined operation
        endcase

        zero = (out == 0); // Set zero flag if output is zero
    end
endmodule