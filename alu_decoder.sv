// Jacob Panov
// This module implements the decoder for the ALU control signals in a MIPS processor.
// alu_decoder.sv

module alu_decoder (
    input logic [5:0] funct, // Function code for R-type instructions
    input logic [1:0] aluop, // ALU operation code from the main decoder
    output logic [2:0] alucontrol // ALU control signal
);
    always_comb begin
        case (aluop)
            2'b00: alucontrol = 3'b010; // ADD (for LW/SW/ADDI)
            2'b01: alucontrol = 3'b110; // SUB (for BEQ)
            2'b11: alucontrol = 3'b111; // SLT (for SLTI)
            default: begin
                case (funct) // R-type instructions
                    6'b100000: alucontrol = 3'b010; // ADD
                    6'b100010: alucontrol = 3'b110; // SUB
                    6'b100100: alucontrol = 3'b000; // AND
                    6'b100101: alucontrol = 3'b001; // OR
                    6'b101010: alucontrol = 3'b111; // SLT
                    6'b000000: alucontrol = 3'b100; // SLL
                    6'b000010: alucontrol = 3'b101; // SRL
                    default: alucontrol = 3'bxxx; // Undefined
                endcase
            end
        endcase
    end
endmodule

