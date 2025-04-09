// Jacob Panov
// This module implements a flip-flop with various configurations.
// flop.sv

`include "definitions.sv"

// Register file flip-flop
module flop_r (
    input logic clk, // Clock signal
    input logic rst, // Reset signal
    input logic [`WORD_SIZE-1:0] d, // Data input
    output logic [`WORD_SIZE-1:0] q // Data output
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0; // Reset output to 0
        end else begin
            q <= d; // Store data on clock edge
        end
    end
endmodule

// Register file flip-flop with clear 
module flop_rc (
    input logic clk, // Clock signal
    input logic rst, // Reset signal
    input logic clear, // Clear signal
    input logic [`WORD_SIZE-1:0] d, // Data input
    output logic [`WORD_SIZE-1:0] q // Data output
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0; // Reset output to 0
        end else if (clear) begin
            q <= 0; // Clear output to 0
        end else begin
            q <= d; // Store data on clock edge
        end
    end
endmodule

// Register file flip-flop with enable
module flop_re (
    input logic clk, // Clock signal
    input logic rst, // Reset signal
    input logic enable, // Enable signal
    input logic [`WORD_SIZE-1:0] d, // Data input
    output logic [`WORD_SIZE-1:0] q // Data output
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0; // Reset output to 0
        end else if (enable) begin
            q <= d; // Store data on clock edge if enabled
        end
    end
endmodule

// Register file flip-flop with enable and clear
module flop_rec (
    input logic clk, // Clock signal
    input logic rst, // Reset signal
    input logic enable, // Enable signal
    input logic clear, // Clear signal
    input logic [`WORD_SIZE-1:0] d, // Data input
    output logic [`WORD_SIZE-1:0] q // Data output
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0; // Reset output to 0
        end else if (clear) begin
            q <= 0; // Clear output to 0
        end else if (enable) begin
            q <= d; // Store data on clock edge if enabled
        end
    end
endmodule

