// Jacob Panov
// This module implements the datapath for a pipelined MIPS processor.

`include "definitions.sv"

module data_path (
    input logic clk, reset, // Clock and reset signals
    input logic [1:0] mem_to_reg_execute, mem_to_reg_memory, mem_to_reg_writeback, // Memory-to-register control signals
    input logic [1:0] pc_source_decode, // PC source control signal
    input logic branch_decode, // Branch control signal
    input logic alu_src_execute, // ALU source control signal
    input logic [1:0] reg_dst_execute, reg_dst_writeback, // Register destination control signals
    input logic reg_write_execute, reg_write_memory, reg_write_writeback, // Register write enable signals
    input logic jump_decode, // Jump control signal
    input logic [2:0] alu_control_execute, // ALU control signal
    output logic equal_decode, // Equality signal for decode stage
    output logic [31:0] pc_fetch, // Program counter in fetch stage
    input logic [31:0] instr_fetch, // Instruction fetched from instruction memory
    output logic [31:0] alu_out_memory, write_data_memory, // ALU output and write data in memory stage
    input logic [31:0] read_data_memory, // Data read from memory in memory stage
    output logic [5:0] opcode_decode, funct_decode, // Opcode and function code in decode stage
    output logic flush_execute, // Flush signal for execute stage
    input logic branch_not_equal_decode, jump_pc_decode // Branch not equal and jump PC signals
);
    //---------------------------Internal Signals and Buses-------------------------------------------
    logic forward_a_decode, forward_b_decode; // Forwarding signals for decode stage
    logic [1:0] forward_a_execute, forward_b_execute; // Forwarding signals for execute stage
    logic stall_fetch, stall_decode; // Stall signals for fetch and decode stages
    logic [4:0] rs_decode, rt_decode, rd_decode, rs_execute, rt_execute, rd_execute; // Register addresses
    logic [4:0] shamt_decode, shamt_execute; // Shift amount
    logic [5:0] funct_execute; // Function code in execute stage
    logic [4:0] write_reg_execute, write_reg_memory, write_reg_writeback; // Write register addresses
    logic flush_decode; // Flush signal for decode stage
    logic [31:0] pc_next_fetch, pc_branch_decode; // Next PC and branch PC
    logic [31:0] sign_imm_decode, sign_imm_execute, sign_imm_shifted_decode; // Sign-extended immediate values
    logic [31:0] src_a_decode, src_a_forwarded_decode, src_a_execute, src_a_forwarded_execute; // Source A signals
    logic [31:0] src_b_decode, src_b_forwarded_decode, src_b_execute, src_b_forwarded_execute, src_b_muxed_execute; // Source B signals
    logic [31:0] pc_plus_4_fetch, pc_plus_4_decode, pc_plus_4_execute, pc_plus_4_memory, pc_plus_4_writeback, instr_decode; // PC + 4 values
    logic [31:0] alu_out_execute, alu_out_writeback; // ALU outputs
    logic [31:0] read_data_writeback, result_writeback, byte_data_writeback; // Writeback stage data
    logic [31:0] hilo_execute, hilo_memory, hilo_writeback; // HI/LO register values
    logic [31:0] jump_address; // Jump address
    logic [31:0] alu_or_jal_writeback; // ALU or JAL result
    logic zero_flag; // Zero flag from ALU

    //---------------------------Hazard Unit---------------------------------------------------------
    hazard_unit hazard_unit_inst (
        .branch_decode(branch_decode),
        .rs_decode(rs_decode),
        .rt_decode(rt_decode),
        .rs_execute(rs_execute),
        .rt_execute(rt_execute),
        .write_reg_execute(write_reg_execute),
        .mem_to_reg_execute(mem_to_reg_execute),
        .reg_write_execute(reg_write_execute),
        .write_reg_memory(write_reg_memory),
        .mem_to_reg_memory(mem_to_reg_memory),
        .reg_write_memory(reg_write_memory),
        .write_reg_writeback(write_reg_writeback),
        .reg_write_writeback(reg_write_writeback),
        .stall_fetch(stall_fetch),
        .stall_decode(stall_decode),
        .forward_a_decode(forward_a_decode),
        .forward_b_decode(forward_b_decode),
        .flush_execute(flush_execute),
        .forward_a_execute(forward_a_execute),
        .forward_b_execute(forward_b_execute),
        .branch_not_equal_decode(branch_not_equal_decode),
        .jump_pc_decode(jump_pc_decode)
    );

    //---------------------------Next PC Logic (Fetch and Decode Stage)------------------------------
    mux2 #(32) pc_mux1 (
        .a({pc_plus_4_decode[31:28], instr_decode[25:0], 2'b00}),
        .b(src_a_forwarded_decode),
        .sel(jump_pc_decode),
        .y(jump_address)
    );
    mux3 #(32) pc_mux2 (
        .a(pc_plus_4_fetch),
        .b(pc_branch_decode),
        .c(jump_address),
        .sel(pc_source_decode),
        .y(pc_next_fetch)
    );

    // Register file
    reg_file reg_file_inst (
        .clk(clk),
        .reset(reset),
        .write_en(reg_write_writeback),
        .src1(rs_decode),
        .src2(rt_decode),
        .dest(write_reg_writeback),
        .write_val(result_writeback),
        .reg1(src_a_decode),
        .reg2(src_b_decode)
    );

    // Fetch Stage Logic
    flopenr #(32) pc_reg (
        .clk(clk),
        .reset(reset),
        .en(~stall_fetch),
        .d(pc_next_fetch),
        .q(pc_fetch)
    );
    adder pc_adder (
        .a(pc_fetch),
        .b(32'b100),
        .y(pc_plus_4_fetch)
    );

    //--------------------------Register File Logic (Decode Stage)-----------------------------------
    // Pipeline registers
    flopenrc #(32) reg1_decode (
        .clk(clk),
        .reset(reset),
        .en(~stall_decode),
        .clear(flush_decode),
        .d(pc_plus_4_fetch),
        .q(pc_plus_4_decode)
    );
    flopenrc #(32) reg2_decode (
        .clk(clk),
        .reset(reset),
        .en(~stall_decode),
        .clear(flush_decode),
        .d(instr_fetch),
        .q(instr_decode)
    );

    // Immediate Handling
    sign_extender #(16) sign_extender_inst (
        .in(instr_decode[15:0]),
        .out(sign_imm_decode)
    );
    shift_left_2 imm_shift (
        .in(sign_imm_decode),
        .out(sign_imm_shifted_decode)
    );
    adder pc_branch_adder (
        .a(pc_plus_4_decode),
        .b(sign_imm_shifted_decode),
        .y(pc_branch_decode)
    );

    // Branch Forwarding Handling
    mux2 #(32) rd1_mux (
        .a(src_a_decode),
        .b(alu_out_memory),
        .sel(forward_a_decode),
        .y(src_a_forwarded_decode)
    );
    mux2 #(32) rd2_mux (
        .a(src_b_decode),
        .b(alu_out_memory),
        .sel(forward_b_decode),
        .y(src_b_forwarded_decode)
    );
    equality_comparator #(32) comparator (
        .a(src_a_forwarded_decode),
        .b(src_b_forwarded_decode),
        .equal(equal_decode)
    );

    // Declaration of Buses
    assign opcode_decode = instr_decode[31:26];
    assign funct_decode = instr_decode[5:0];
    assign rs_decode = instr_decode[25:21];
    assign rt_decode = instr_decode[20:16];
    assign rd_decode = instr_decode[15:11];
    assign shamt_decode = instr_decode[10:6];
    assign flush_decode = pc_source_decode[0] | pc_source_decode[1];

    //--------------------------Execute Stage--------------------------------------------------------
    // Pipeline registers
    floprc #(32) reg1_execute (.clk(clk), .reset(reset), .clear(flush_execute), .d(src_a_decode), .q(src_a_execute));
    floprc #(32) reg2_execute (.clk(clk), .reset(reset), .clear(flush_execute), .d(src_b_decode), .q(src_b_execute));
    floprc #(5) reg3_execute (.clk(clk), .reset(reset), .clear(flush_execute), .d(rs_decode), .q(rs_execute));
    floprc #(5) reg4_execute (.clk(clk), .reset(reset), .clear(flush_execute), .d(rt_decode), .q(rt_execute));
    floprc #(5) reg5_execute (.clk(clk), .reset(reset), .clear(flush_execute), .d(rd_decode), .q(rd_execute));
    floprc #(32) reg6_execute (.clk(clk), .reset(reset), .clear(flush_execute), .d(sign_imm_decode), .q(sign_imm_execute));
    floprc #(5) reg7_execute (.clk(clk), .reset(reset), .clear(flush_execute), .d(shamt_decode), .q(shamt_execute));
    floprc #(32) reg8_execute (.clk(clk), .reset(reset), .clear(flush_execute), .d(pc_plus_4_decode), .q(pc_plus_4_execute));
    floprc #(6) reg9_execute (.clk(clk), .reset(reset), .clear(flush_execute), .d(funct_decode), .q(funct_execute));

    // Data Forwarding Handling
    mux3 #(32) forward_mux1 (.a(src_a_execute), .b(result_writeback), .c(alu_out_memory), .sel(forward_a_execute), .y(src_a_forwarded_execute));
    mux3 #(32) forward_mux2 (.a(src_b_execute), .b(result_writeback), .c(alu_out_memory), .sel(forward_b_execute), .y(src_b_forwarded_execute));

    // ALU Logic
    mux2 #(32) src_b_mux (.a(src_b_forwarded_execute), .b(sign_imm_execute), .sel(alu_src_execute), .y(src_b_muxed_execute));
    alu alu_inst (.a(src_a_forwarded_execute), .b(src_b_muxed_execute), .alucontrol(alu_control_execute), .y(alu_out_execute), .shamt(shamt_execute), .zero(zero_flag));
    coprocessor coprocessor_inst (.src_a(src_a_forwarded_execute), .src_b(src_b_forwarded_execute), .funct_decode(funct_execute), .hilo(hilo_execute));
    mux3 #(5) write_reg_mux (.a(rt_execute), .b(rd_execute), .c(5'b11111), .sel(reg_dst_execute), .y(write_reg_execute));

    //-------------------------Memory Stage-----------------------------------------------------------
    // Pipeline registers
    flopr #(32) reg1_memory (.clk(clk), .reset(reset), .d(src_b_forwarded_execute), .q(write_data_memory));
    flopr #(32) reg2_memory (.clk(clk), .reset(reset), .d(alu_out_execute), .q(alu_out_memory));
    flopr #(5) reg3_memory (.clk(clk), .reset(reset), .d(write_reg_execute), .q(write_reg_memory));
    flopr #(32) reg4_memory (.clk(clk), .reset(reset), .d(hilo_execute), .q(hilo_memory));
    flopr #(32) reg5_memory (.clk(clk), .reset(reset), .d(pc_plus_4_execute), .q(pc_plus_4_memory));

    //-----------------------Write-back Stage----------------------------------------------------------
    // Pipeline registers
    flopr #(32) reg1_writeback (.clk(clk), .reset(reset), .d(alu_out_memory), .q(alu_out_writeback));
    flopr #(32) reg2_writeback (.clk(clk), .reset(reset), .d(read_data_memory), .q(read_data_writeback));
    flopr #(5) reg3_writeback (.clk(clk), .reset(reset), .d(write_reg_memory), .q(write_reg_writeback));
    flopr #(32) reg4_writeback (.clk(clk), .reset(reset), .d(hilo_memory), .q(hilo_writeback));
    flopr #(32) reg5_writeback (.clk(clk), .reset(reset), .d(pc_plus_4_memory), .q(pc_plus_4_writeback));

    // Write-back address logic
    sign_extender #(8) byte_sign_extender (.in(read_data_writeback[7:0]), .out(byte_data_writeback));
    mux2 #(32) jal_mux (.a(alu_out_writeback), .b(pc_plus_4_writeback), .sel(reg_dst_writeback[1]), .y(alu_or_jal_writeback));
    mux4 #(32) result_mux (.a(alu_or_jal_writeback), .b(read_data_writeback), .c(hilo_writeback), .d(byte_data_writeback), .sel(mem_to_reg_writeback), .y(result_writeback));
endmodule

