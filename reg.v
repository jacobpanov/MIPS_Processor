// Jacob Panov
// This module implements a 32-bit register with synchronous reset and enable functionality.
// reg.v

`include "definitions.v"

module reg (clk, rst, enable, reg_in, reg_out);
    input wire clk; // Clock signal
    input wire rst; // Reset signal
    input wire enable; // Enable signal
    input wire [`WORD_SIZE-1:0] reg_in; // 32-bit input data
    output reg [`WORD_SIZE-1:0] reg_out; // 32-bit output data

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_out <= 0; // Reset the register to 0
        end else if (enable) begin
            reg_out <= reg_in; // Load the input data into the register
        end
    end
endmodule