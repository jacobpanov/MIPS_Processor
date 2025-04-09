// Jacob Panov
// This module implements a data memory for a MIPS processor with read and write functionality.
// data_mem.sv

`include "defines.sv"

module data_mem #(
    parameter MEM_CELL_SIZE = 8, // Width of each memory cell
    parameter DATA_MEM_SIZE = 1024 // Number of memory cells
) (
    input logic clk, // Clock signal
    input logic rst, // Reset signal
    input logic read_en, // Read enable signal
    input logic write_en, // Write enable signal
    input logic [`WORD_SIZE-1:0] addr, // Address input
    input logic [`WORD_SIZE-1:0] data_in, // Data input
    output logic [`WORD_SIZE-1:0] data_out // Data output
);
    localparam ADDR_WIDTH = $clog2(DATA_MEM_SIZE); // Address width based on memory size
    logic [MEM_CELL_SIZE-1:0] dataMem [0:DATA_MEM_SIZE-1]; // Data memory array
    logic [ADDR_WIDTH-1:0] base_address; // Effective base address

    integer i;

    // Reset or write logic
    always_ff @(posedge clk) begin
        if (rst) begin
            // Reset all memory cells to 0
            for (i = 0; i < DATA_MEM_SIZE; i = i + 1) begin
                dataMem[i] <= 0;
            end
        end else if (write_en) begin
            // Write 32-bit data across four 8-bit memory cells
            {dataMem[base_address], dataMem[base_address + 1], dataMem[base_address + 2], dataMem[base_address + 3]} <= data_in;
        end
    end

    // Calculate the base address (aligned to 4 bytes)
    assign base_address = ((addr & 32'hFFFFFFFC) >> 2) << 2;

    // Read logic
    assign data_out = (read_en && addr >= 1024) ?
        {dataMem[base_address], dataMem[base_address + 1], dataMem[base_address + 2], dataMem[base_address + 3]} :
        32'b0; // Return 0 if read is disabled or address is invalid
endmodule


