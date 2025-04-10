// Jacob Panov
// This module implements the coprocessor for a pipelined MIPS processor.
// coprocessor.sv

`include "definitions.v"

module coprocessor (
    input logic [31:0] src_a, src_b, // Source operands (rs -> src_a, rt -> src_b)
    input logic [5:0] funct_decode, // Function code from the instruction
    output logic [31:0] hilo // Output for HI/LO register values
);
    logic [31:0] hi, lo; // HI and LO registers

    always_comb begin
        case (funct_decode)
            6'b011000: {hi, lo} = src_a * src_b; // MULT: Multiply src_a and src_b
            6'b011010: begin // DIV: Divide src_a by src_b
                lo = src_a / src_b; // LO gets the quotient
                hi = src_a % src_b; // HI gets the remainder
            end
            6'b010000: hilo = hi; // MFHI: Move from HI register
            6'b010010: hilo = lo; // MFLO: Move from LO register
            default: hilo = 32'bx; // Undefined operation
        endcase
    end
endmodule

