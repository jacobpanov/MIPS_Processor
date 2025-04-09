// Jacob Panov
// This module implements an instruction memory for a MIPS processor.
// instruction_mem.sv

// The memory is initialized with instructions from a file.

`include "definitions.v"

module instruction_mem #(
    parameter MEM_CELL_SIZE = 8, // Width of each memory cell
    parameter INSTR_MEM_SIZE = 256 // Number of memory cells
) (
    input logic [`WORD_SIZE-1:0] addr, // Address input
    input logic rst, // Reset signal
    output logic [`WORD_SIZE-1:0] instruction // Instruction output
);
    localparam ADDR_WIDTH = $clog2(INSTR_MEM_SIZE); // Address width based on memory size
    logic [ADDR_WIDTH-1:0] address; // Effective address
    logic [MEM_CELL_SIZE-1:0] instMem [0:INSTR_MEM_SIZE-1]; // Instruction memory array

    // Preload instructions from a file
    initial begin
        $readmemh("instructions.hex", instMem);
    end

    /* Optional: Clear memory on reset
    always_ff @(posedge rst) begin
        integer i;
        for (i = 0; i < INSTR_MEM_SIZE; i = i + 1) begin
            instMem[i] <= 0; // Clear memory cells
        end
    end
    */

    // Optional: Display instruction memory contents for debugging
    initial begin
        integer i;
        for (i = 0; i < INSTR_MEM_SIZE; i = i + 1) begin
            $display("Instruction Memory[%0d]: %h", i, instMem[i]);
        end
    end

    // Calculate the effective address
    assign address = addr[ADDR_WIDTH-1:0];

    // Concatenate four memory cells to form a 32-bit instruction
    assign instruction = (address + 3 < INSTR_MEM_SIZE) ?
        {instMem[address], instMem[address + 1], instMem[address + 2], instMem[address + 3]} :
        32'b0; // Return 0 if out of bounds

endmodule