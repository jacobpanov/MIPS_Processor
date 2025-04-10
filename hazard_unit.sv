// Jacob Panov
// This module implements the hazard detection unit for a pipelined MIPS processor.
// hazard_unit.sv

`include "definitions.sv"

module hazard_unit (
    input logic branch_decode, // Branch signal in decode stage
    input logic [4:0] rs_decode, rt_decode, rs_execute, rt_execute, // Register source and target addresses
    input logic [4:0] write_reg_execute, // Write register in execute stage
    input logic [1:0] mem_to_reg_execute, // Memory-to-register control in execute stage
    input logic reg_write_execute, // Register write enable in execute stage
    input logic [4:0] write_reg_memory, // Write register in memory stage
    input logic [1:0] mem_to_reg_memory, // Memory-to-register control in memory stage
    input logic reg_write_memory, // Register write enable in memory stage
    input logic [4:0] write_reg_writeback, // Write register in writeback stage
    input logic reg_write_writeback, // Register write enable in writeback stage
    output logic stall_fetch, stall_decode, // Stall signals for fetch and decode stages
    output logic forward_a_decode, forward_b_decode, // Forwarding signals for decode stage
    output logic flush_execute, // Flush signal for execute stage
    output logic [1:0] forward_a_execute, forward_b_execute, // Forwarding signals for execute stage
    input logic branch_not_equal_decode, jump_pc_decode // Branch not equal and jump PC signals
);

    // Internal signals
    logic load_word_stall_decode, branch_stall_decode;

    // Forwarding sources to decode stage
    assign forward_a_decode = (rs_decode != 0) & (rs_decode == write_reg_memory) & reg_write_memory;
    assign forward_b_decode = (rt_decode != 0) & (rt_decode == write_reg_memory) & reg_write_memory;

    // Forwarding sources to execute stage
    always_comb begin
        forward_a_execute = 2'b00;
        forward_b_execute = 2'b00;

        // Source A forwarding logic
        if (rs_execute != 0) begin
            if ((rs_execute == write_reg_memory) & reg_write_memory)
                forward_a_execute = 2'b10;
            else if ((rs_execute == write_reg_writeback) & reg_write_writeback)
                forward_a_execute = 2'b01;
        end

        // Source B forwarding logic
        if (rt_execute != 0) begin
            if ((rt_execute == write_reg_memory) & reg_write_memory)
                forward_b_execute = 2'b10;
            else if ((rt_execute == write_reg_writeback) & reg_write_writeback)
                forward_b_execute = 2'b01;
        end
    end

    // Stalling logic
    assign load_word_stall_decode = mem_to_reg_execute[0] & (rt_execute == rs_decode | rt_execute == rt_decode);
    assign branch_stall_decode = (branch_decode | branch_not_equal_decode | jump_pc_decode) &
                                 ((reg_write_execute & (write_reg_execute == rs_decode | write_reg_execute == rt_decode)) |
                                  (mem_to_reg_memory[0] & (write_reg_memory == rs_decode | write_reg_memory == rt_decode)));
    assign stall_decode = load_word_stall_decode | branch_stall_decode;
    assign stall_fetch = stall_decode;

    // Flush execute stage if decode stage is stalled
    assign flush_execute = stall_decode;

endmodule



