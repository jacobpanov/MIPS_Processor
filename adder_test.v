// Jacob Panov
// This module serves as a testbench for the adder modules.
// adder_test.v

module half_adder_test;
    reg a, b;
    wire sum, carry;

    // Instantiate the half adder
    half_adder ha (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        // Test cases for half adder
        $monitor("Half Adder: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        
        $finish;
    end
endmodule

module one_bit_full_adder_test;
    reg a, b, carry_in;
    wire sum, carry_out;

    // Instantiate the one-bit full adder
    one_bit_full_adder f1 (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin
        // Test cases for one-bit full adder
        $monitor("One Bit Full Adder: a=%b, b=%b, carry_in=%b, sum=%b, carry_out=%b", a, b, carry_in, sum, carry_out);
        
        a = 0; b = 0; carry_in = 0; #10;
        a = 0; b = 1; carry_in = 0; #10;
        a = 1; b = 0; carry_in = 0; #10;
        a = 1; b = 1; carry_in = 0; #10;
        a = 0; b = 0; carry_in = 1; #10;
        a = 0; b = 1; carry_in = 1; #10;
        a = 1; b = 0; carry_in = 1; #10;
        a = 1; b = 1; carry_in = 1; #10;
        
        $finish;
    end
endmodule

module four_bit_full_adder_test;
    reg [3:0] a, b;
    reg carry_in;
    wire [3:0] sum;
    wire carry_out;

    // Instantiate the four-bit full adder
    four_bit_full_adder f4 (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin
        // Test cases for four-bit full adder
        $monitor("Four Bit Full Adder: a=%b, b=%b, carry_in=%b, sum=%b, carry_out=%b", a, b, carry_in, sum, carry_out);
        
        a = 4'b0000; b = 4'b0000; carry_in = 0; #10;
        a = 4'b0001; b = 4'b0001; carry_in = 0; #10;
        a = 4'b0010; b = 4'b0010; carry_in = 0; #10;
        a = 4'b0100; b = 4'b0100; carry_in = 0; #10;
        a = 4'b1000; b = 4'b1000; carry_in = 0; #10;
        a = 4'b1111; b = 4'b1111; carry_in = 0; #10;
        a = 4'b0000; b = 4'b0000; carry_in = 1; #10;
        a = 4'b0001; b = 4'b0001; carry_in = 1; #10;
        a = 4'b0010; b = 4'b0010; carry_in = 1; #10;
        a = 4'b0100; b = 4'b0100; carry_in = 1; #10;
        a = 4'b1000; b = 4'b1000; carry_in = 1; #10;
        a = 4'b1111; b = 4'b1111; carry_in = 1; #10;
        a = 4'b1111; b = 4'b0001; carry_in = 0; #10;
        a = 4'b1111; b = 4'b0001; carry_in = 1; #10;
        a = 4'b0001; b = 4'b1111; carry_in = 0; #10;
        a = 4'b0001; b = 4'b1111; carry_in = 1; #10;
        a = 4'b1010; b = 4'b0101; carry_in = 0; #10;
        a = 4'b1010; b = 4'b0101; carry_in = 1; #10;
        a = 4'b1100; b = 4'b0011; carry_in = 0; #10;    
        a = 4'b1100; b = 4'b0011; carry_in = 1; #10;
        $finish;
    end
endmodule

module eight_bit_full_adder_test;
    reg [7:0] a, b;
    reg carry_in;
    wire [7:0] sum;
    wire carry_out;

    // Instantiate the eight-bit full adder
    eight_bit_full_adder f8 (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin
        // Test cases for eight-bit full adder
        $monitor("Eight Bit Full Adder: a=%b, b=%b, carry_in=%b, sum=%b, carry_out=%b", a, b, carry_in, sum, carry_out);
        
        a = 8'b00000000; b = 8'b00000000; carry_in = 0; #10;
        a = 8'b00000001; b = 8'b00000001; carry_in = 0; #10;
        a = 8'b00000010; b = 8'b00000010; carry_in = 0; #10;
        a = 8'b00000100; b = 8'b00000100; carry_in = 0; #10;
        a = 8'b00001000; b = 8'b00001000; carry_in = 0; #10;
        a = 8'b00010000; b = 8'b00010000; carry_in = 0; #10;
        a = 8'b00100000; b = 8'b00100000; carry_in = 0; #10;
        a = 8'b01000000; b = 8'b01000000; carry_in = 0; #10;
        a = 8'b10000000; b = 8'b10000000; carry_in = 0; #10;
        a = 8'b11111111; b = 8'b11111111; carry_in = 0; #10;
        
        $finish;
    end
endmodule

module thirty_two_bit_full_adder_test;
    reg [31:0] a, b;
    reg carry_in;
    wire [31:0] sum;
    wire carry_out;

    // Instantiate the thirty-two bit full adder
    thirty_two_bit_full_adder f32 (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin
        // Test cases for thirty-two bit full adder
        $monitor("Thirty Two Bit Full Adder: a=%b, b=%b, carry_in=%b, sum=%b, carry_out=%b", a, b, carry_in, sum, carry_out);
        
        a = 32'b00000000000000000000000000000000; b = 32'b00000000000000000000000000000000; carry_in = 0; #10;
        a = 32'b00000000000000000000000000000001; b = 32'b00000000000000000000000000000001; carry_in = 0; #10;
        a = 32'b11111111111111111111111111111111; b = 32'b00000000000000000000000000000001; carry_in = 0; #10;
        a = 32'b11111111111111111111111111111111; b = 32'b00000000000000000000000000000001; carry_in = 1; #10;
        a = 32'b10101010101010101010101010101010; b = 32'b01010101010101010101010101010101; carry_in = 0; #10;
        a = 32'b10101010101010101010101010101010; b = 32'b01010101010101010101010101010101; carry_in = 1; #10;
        a = 32'b11110000111100001111000011110000; b = 32'b00001111000011110000111100001111; carry_in = 0; #10;
        a = 32'b11110000111100001111000011110000; b = 32'b00001111000011110000111100001111; carry_in = 1; #10;
        a = 32'b00000000000000000000000000000000; b = 32'b11111111111111111111111111111111; carry_in = 0; #10;
        a = 32'b00000000000000000000000000000000; b = 32'b11111111111111111111111111111111; carry_in = 1; #10;

        $finish;
    end
endmodule