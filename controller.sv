// Jacob Panov
// This module implements a controller for a simple CPU architecture.
// controller.sv

`include "definitions.sv"

module controller (
    input logic clk, reset, // Clock and reset signals
    input logic [5:0] opcode, funct, // Opcode and function code from the instruction
    input logic flush_execute, equal_decode, // Flush signal for execute stage and equality signal for decode stage
    output logic [1:0] mem_to_reg_execute, mem_to_reg_memory, mem_to_reg_writeback, // Memory-to-register control signals
    output logic mem_write_memory, // Memory write enable signal
    output logic [1:0] pc_source_decode, // PC source control signal
    output logic branch_decode, alu_src_execute, // Branch and ALU source control signals
    output logic [1:0] reg_dst_execute, reg_dst_writeback, // Register destination control signals
    output logic reg_write_execute, reg_write_memory, reg_write_writeback, // Register write enable signals
    output logic jump_decode, // Jump control signal
    output logic [2:0] alu_control_execute, // ALU control signal
    output logic branch_not_equal_decode, // Branch not equal control signal
    output logic write_or_byte, // Write or byte control signal
    output logic jump_pc_decode // Jump to PC control signal
);
    // Internal signals
    logic reg_write_decode, mem_write_decode, alu_src_decode; // Decode stage signals
    logic [2:0] alu_control_decode; // ALU control signal for decode stage
    logic [1:0] alu_op_decode, mem_to_reg_decode, reg_dst_decode, reg_dst_memory; // Decode and memory stage signals
    logic mem_write_execute; // Memory write enable signal for execute stage

    // Main Decoder module (outputs the decode stage signals)
    main_decoder main_dec (
        .opcode(opcode),
        .funct(funct),
        .mem_to_reg(mem_to_reg_decode),
        .mem_write(mem_write_decode),
        .branch(branch_decode),
        .alu_src(alu_src_decode),
        .reg_dst(reg_dst_decode),
        .reg_write(reg_write_decode),
        .jump(jump_decode),
        .alu_op(alu_op_decode),
        .branch_not_equal(branch_not_equal_decode),
        .jump_pc(jump_pc_decode)
    );

    // ALU Decoder module (outputs the ALU control signal)
    alu_decoder alu_dec (
        .funct(funct),
        .aluop(alu_op_decode),
        .alucontrol(alu_control_decode)
    );

    // Assign PC source control signal
    assign pc_source_decode[0] = (branch_decode & equal_decode) | (branch_not_equal_decode & ~equal_decode);
    assign pc_source_decode[1] = jump_decode;

    // Assign write or byte control signal
    assign write_or_byte = mem_to_reg_memory[0] & mem_to_reg_memory[1];

    // Execute stage pipeline register
    floprc #(10) reg_execute (
        .clk(clk),
        .reset(reset),
        .clear(flush_execute),
        .d({mem_to_reg_decode, mem_write_decode, alu_src_decode, reg_dst_decode, reg_write_decode, alu_control_decode}),
        .q({mem_to_reg_execute, mem_write_execute, alu_src_execute, reg_dst_execute, reg_write_execute, alu_control_execute})
    );

    // Memory stage pipeline register
    flopr #(6) reg_memory (
        .clk(clk),
        .reset(reset),
        .d({mem_to_reg_execute, mem_write_execute, reg_write_execute, reg_dst_execute}),
        .q({mem_to_reg_memory, mem_write_memory, reg_write_memory, reg_dst_memory})
    );

    // Write-back stage pipeline register
    flopr #(5) reg_writeback (
        .clk(clk),
        .reset(reset),
        .d({mem_to_reg_memory, reg_write_memory, reg_dst_memory}),
        .q({mem_to_reg_writeback, reg_write_writeback, reg_dst_writeback})
    );
endmodule