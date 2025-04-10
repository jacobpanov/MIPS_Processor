`timescale 1ns/1ps

module top_tb;
    // Clock and reset signals
    logic clk;
    logic reset;

    // Outputs from the processor
    logic [31:0] write_data_memory, data_address_memory;
    logic mem_write_memory;

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset),
        .write_data_memory(write_data_memory),
        .data_address_memory(data_address_memory),
        .mem_write_memory(mem_write_memory)
    );

    // Testbench variables
    integer i;

    // Instruction memory initialization
    initial begin
        // Initialize clock and reset
        clk = 0;
        reset = 1;

        // Apply reset
        #10 reset = 0;

        // Load instructions into instruction memory
        // Example: Load a program that tests basic ALU operations
        uut.imem.memory[0] = 32'h20080005; // ADDI $t0, $zero, 5
        uut.imem.memory[1] = 32'h20090003; // ADDI $t1, $zero, 3
        uut.imem.memory[2] = 32'h01095020; // ADD $t2, $t0, $t1
        uut.imem.memory[3] = 32'hAC0A0000; // SW $t2, 0($zero)
        uut.imem.memory[4] = 32'h8C0B0000; // LW $t3, 0($zero)
        uut.imem.memory[5] = 32'h00000000; // NOP

        // Initialize data memory
        for (i = 0; i < 1024; i = i + 1) begin
            uut.dmem.memory[i] = 32'b0;
        end

        // Run the simulation
        #1000 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | PC: %h | MemWrite: %b | DataAddr: %h | WriteData: %h",
                 $time, uut.mips_processor.pc_fetch, mem_write_memory, data_address_memory, write_data_memory);
    end
endmodule