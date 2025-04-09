// Jacob Panov
// This module implements a 2-to-1 and a 3-to-1 multiplexer.
// mux.sv

module mux_2to1 #(parameter int LENGTH = 32) (
    input logic [LENGTH-1:0] in_1, 
    input logic [LENGTH-1:0] in_2,
    input logic sel,
    output logic [LENGTH-1:0] out
);

    // Select between in_1 and in_2 based on sel
    assign out = (sel == 1'b0) ? in_1 : in_2;
endmodule

module mux_3to1 #(parameter int LENGTH = 32) (
    input logic [LENGTH-1:0] in_1, 
    input logic [LENGTH-1:0] in_2, 
    input logic [LENGTH-1:0] in_3, 
    input logic [1:0] sel, 
    output logic [LENGTH-1:0] out
);
    // Select between in_1, in_2, and in_3 based on sel
    assign out = (sel == 2'b00) ? in_1 : 
                 (sel == 2'b01) ? in_2 : 
                 (sel == 2'b10) ? in_3 : 
                 {LENGTH{1'bx}}; // Default to unknown if sel is invalid
endmodule