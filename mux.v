// Jacob Panov
// mux.v

module mux_2to1 #(parameter integer LENGTH) (in_1, in_2, sel, out);
    input wire [LENGTH-1:0] in_1, in_2;
    input wire sel;
    output wire [LENGTH-1:0] out;

    assign out = (sel == 1'b0) ? in_1 : in_2; // Select between in_1 and in_2 based on sel
endmodule

module mux_3to1 #(parameter integer LENGTH) (in_1, in_2, in_3, sel, out);
    input wire [LENGTH-1:0] in_1, in_2, in_3;
    input wire [1:0] sel;
    output wire [LENGTH-1:0] out;

    assign out = (sel == 2'b00) ? in_1 : 
                 (sel == 2'b01) ? in_2 : 
                 (sel == 2'b10) ? in_3 : 
                 {LENGTH{1'bx}}; // Select between in_1, in_2, and in_3 based on sel
endmodule
    