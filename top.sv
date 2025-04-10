// Jacob Panov
// This module implements the top-level module for the pipelined MIPS processor.
// top.sv

`include "definitions.sv"

module top (
    input logic clk, reset, // Clock and reset signals
    output logic [31:0] write_data_memory, data_address_memory, // Write data and data address for memory
    output logic mem_write_memory // Memory write enable signal
);
    //--------------------------------Internal Signals and Buses-----------------------------------------------
    logic [31:0] pc_fetch, instr_fetch, read_data_memory; // Program counter, instruction, and memory read data
    logic write_or_byte; // Write or byte control signal

    //--------------------------------Instantiate Processor----------------------------------------------------
    processor mips_processor (
        .clk(clk),
        .reset(reset),
        .pc_fetch(pc_fetch),
        .instr_fetch(instr_fetch),
        .mem_write_memory(mem_write_memory),
        .alu_out_memory(data_address_memory),
        .write_data_memory(write_data_memory),
        .read_data_memory(read_data_memory),
        .write_or_byte(write_or_byte)
    );

    //--------------------------------Instantiate Instruction Memory-------------------------------------------
    instruction_memory imem (
        .address(pc_fetch[7:2]), // Instruction memory address (word-aligned)
        .instruction(instr_fetch) // Instruction fetched
    );

    //--------------------------------Instantiate Data Memory--------------------------------------------------
    data_memory dmem (
        .clk(clk),
        .mem_write(mem_write_memory),
        .write_or_byte(write_or_byte),
        .address(data_address_memory),
        .write_data(write_data_memory),
        .read_data(read_data_memory)
    );
endmodule

