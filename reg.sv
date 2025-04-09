// Jacob Panov
// This module implements a 32-bit register with synchronous reset and enable functionality.
// reg.sv

`include "definitions.v"

module reg (
    input logic clk, // Clock signal
    input logic rst, // Reset signal
    input logic enable, // Enable signal
    input logic [`WORD_SIZE-1:0] reg_in, // 32-bit input data
    output logic [`WORD_SIZE-1:0] reg_out // 32-bit output data
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_out <= 0; // Reset the register to 0
        end else if (enable) begin
            reg_out <= reg_in; // Load the input data into the register
        end
    end
endmodule