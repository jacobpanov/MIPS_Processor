// Jacob Panov
// This module implements the main decoder for a MIPS processor.
// main_decoder.sv

module main_decoder (
    input logic [5:0] opcode, // Opcode field from the instruction
    input logic [5:0] funct, // Function code field for R-type instructions
    output logic [1:0] mem_to_reg, // Memory-to-register control
    output logic mem_write, // Memory write enable
    output logic branch, // Branch control
    output logic alu_src, // ALU source control
    output logic [1:0] reg_dst, // Register destination control
    output logic reg_write, // Register write enable
    output logic jump, // Jump control
    output logic [1:0] alu_op, // ALU operation control
    output logic branch_ne, // Branch not equal control
    output logic jump_pc // Jump to PC control
);
    logic [12:0] control_signals; // Packed control signals

    // Assign control signals to outputs
    assign {reg_write, reg_dst, alu_src, branch, mem_write, mem_to_reg, jump, alu_op, branch_ne, jump_pc} = control_signals;

    // Control logic
    always_comb begin
        case (opcode)
            6'b000000: begin // R-type instructions
                case (funct)
                    6'b011000: control_signals = 13'b0000000000000; // MULT
                    6'b011010: control_signals = 13'b0000000000000; // DIV
                    6'b010000: control_signals = 13'b1010001000000; // MFHI
                    6'b010010: control_signals = 13'b1010001000000; // MFLO
                    6'b001000: control_signals = 13'b0000000100001; // JR
                    default:   control_signals = 13'b1010000001000; // All other R-type
                endcase
            end
            6'b100011: control_signals = 13'b1001000100000; // LW
            6'b101011: control_signals = 13'b0001010000000; // SW
            6'b000100: control_signals = 13'b0000100000100; // BEQ
            6'b000101: control_signals = 13'b0000000000110; // BNE
            6'b001000: control_signals = 13'b1001000000000; // ADDI
            6'b001010: control_signals = 13'b1001000001100; // SLTI
            6'b000010: control_signals = 13'b0000000010000; // J
            6'b000011: control_signals = 13'b1100000010000; // JAL
            6'b100000: control_signals = 13'b1001001100000; // LB
            6'b101000: control_signals = 13'b0001011100000; // SB
            default:   control_signals = 13'bxxxxxxxxxxxxx; // Illegal opcode
        endcase
    end
endmodule