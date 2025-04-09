// Jacob Panov
// This module implements a register file for a MIPS processor with read and write functionality.
// reg_file.sv

`include "definitions.sv"

module reg_file #(
    parameter REG_FILE_SIZE = 32, // Number of registers
    parameter REG_FILE_ADDR_LEN = 5 // Address width for register file
) (
    input logic clk, // Clock signal
    input logic rst, // Reset signal
    input logic write_en, // Write enable signal
    input logic [REG_FILE_ADDR_LEN-1:0] src1, // Source register 1 address
    input logic [REG_FILE_ADDR_LEN-1:0] src2, // Source register 2 address
    input logic [REG_FILE_ADDR_LEN-1:0] dest, // Destination register address
    input logic [`WORD_SIZE-1:0] write_val, // Value to write to the destination register
    output logic [`WORD_SIZE-1:0] reg1, // Output value from source register 1
    output logic [`WORD_SIZE-1:0] reg2 // Output value from source register 2
);
    logic [`WORD_SIZE-1:0] reg_mem [0:REG_FILE_SIZE-1]; // Register memory array
    integer i;

    // Reset or write logic
    always_ff @(posedge clk) begin
        if (rst) begin
            // Reset all registers to 0
            for (i = 0; i < REG_FILE_SIZE; i = i + 1) begin
                reg_mem[i] <= 0;
            end
        end else if (write_en && dest != 0) begin
            // Write value to the destination register
            reg_mem[dest] <= write_val;
        end
        // Ensure register 0 is always 0
        reg_mem[0] <= 0;
    end

    // Read logic
    assign reg1 = reg_mem[src1]; // Read value from source register 1
    assign reg2 = reg_mem[src2]; // Read value from source register 2
endmodule