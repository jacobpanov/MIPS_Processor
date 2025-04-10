// Jacob Panov
// This module implements the top-level processor for a pipelined MIPS processor.
// processor.sv

`include "definitions.sv"

module processor (
    input logic clk, reset, // Clock and reset signals
    output logic [31:0] pc_fetch, // Program counter in fetch stage
    input logic [31:0] instr_fetch, // Instruction fetched from instruction memory
    output logic mem_write_memory, // Memory write enable signal in memory stage
    output logic [31:0] alu_out_memory, write_data_memory, // ALU output and write data in memory stage
    input logic [31:0] read_data_memory, // Data read from memory in memory stage
    output logic write_or_byte // Write or byte control signal
);
    //--------------------------------Internal Signals and Buses--------------------------------------------------		
    logic [5:0] opcode_decode, funct_decode; // Opcode and function code in decode stage
    logic alu_src_execute, reg_write_execute, reg_write_memory, reg_write_writeback; // Control signals for ALU and register write
    logic [1:0] mem_to_reg_execute, mem_to_reg_memory, mem_to_reg_writeback; // Memory-to-register control signals
    logic [1:0] pc_source_decode, reg_dst_execute, reg_dst_writeback; // PC source and register destination control signals
    logic [2:0] alu_control_execute; // ALU control signal
    logic flush_execute, equal_decode; // Flush signal for execute stage and equality signal for decode stage
    logic branch_decode, branch_not_equal_decode, jump_decode, jump_pc_decode; // Branch and jump control signals

    //------------------------------------Controller--------------------------------------------------------------
    controller control_unit (
        .clk(clk),
        .reset(reset),
        .opcode(opcode_decode),
        .funct(funct_decode),
        .flush_execute(flush_execute),
        .equal_decode(equal_decode),
        .mem_to_reg_execute(mem_to_reg_execute),
        .mem_to_reg_memory(mem_to_reg_memory),
        .mem_to_reg_writeback(mem_to_reg_writeback),
        .mem_write_memory(mem_write_memory),
        .pc_source_decode(pc_source_decode),
        .branch_decode(branch_decode),
        .alu_src_execute(alu_src_execute),
        .reg_dst_execute(reg_dst_execute),
        .reg_dst_writeback(reg_dst_writeback),
        .reg_write_execute(reg_write_execute),
        .reg_write_memory(reg_write_memory),
        .reg_write_writeback(reg_write_writeback),
        .jump_decode(jump_decode),
        .alu_control_execute(alu_control_execute),
        .branch_not_equal_decode(branch_not_equal_decode),
        .write_or_byte(write_or_byte),
        .jump_pc_decode(jump_pc_decode)
    );

    //---------------------------------Data-path------------------------------------------------------------------	
    datapath data_path_unit (
        .clk(clk),
        .reset(reset),
        .mem_to_reg_execute(mem_to_reg_execute),
        .mem_to_reg_memory(mem_to_reg_memory),
        .mem_to_reg_writeback(mem_to_reg_writeback),
        .pc_source_decode(pc_source_decode),
        .branch_decode(branch_decode),
        .alu_src_execute(alu_src_execute),
        .reg_dst_execute(reg_dst_execute),
        .reg_dst_writeback(reg_dst_writeback),
        .reg_write_execute(reg_write_execute),
        .reg_write_memory(reg_write_memory),
        .reg_write_writeback(reg_write_writeback),
        .jump_decode(jump_decode),
        .alu_control_execute(alu_control_execute),
        .equal_decode(equal_decode),
        .pc_fetch(pc_fetch),
        .instr_fetch(instr_fetch),
        .alu_out_memory(alu_out_memory),
        .write_data_memory(write_data_memory),
        .read_data_memory(read_data_memory),
        .opcode_decode(opcode_decode),
        .funct_decode(funct_decode),
        .flush_execute(flush_execute),
        .branch_not_equal_decode(branch_not_equal_decode),
        .jump_pc_decode(jump_pc_decode)
    );
endmodule

