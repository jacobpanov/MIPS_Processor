// Jacob Panov
// This module implements a 32-bit ALU (Arithmetic Logic Unit) with various operations.
// alu.sv

module alu (
    input logic [31:0] a, // ALU input 1
    input logic [31:0] b, // ALU input 2
    input logic [2:0] alucontrol, // ALU control signal (3 bits)
    input logic [4:0] shamt, // Shift amount for shift operations
    output logic [31:0] y, // ALU output
    output logic zero // Zero flag
);
    always_comb begin
        case (alucontrol)
            3'b000: y = a & b; // AND
            3'b001: y = a | b; // OR
            3'b010: y = a + b; // ADD
            3'b110: y = a - b; // SUB
            3'b111: y = (a < b) ? 32'b1 : 32'b0; // SLT
            3'b100: y = b << shamt; // SLL
            3'b101: y = b >> shamt; // SRL
            default: y = 32'bx; // Undefined operation
        endcase

        // Set zero flag if output is zero
        zero = (y == 0);
    end
endmodule