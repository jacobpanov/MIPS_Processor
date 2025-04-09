// Jacob Panov
// This module implements a sign extension unit for a 16-bit input to a 32-bit output.
// sign_extend.v

`include "definitions.v"

module sign_extend (
    input wire [`WORD_SIZE/2-1:0] in, // 16-bit input
    output reg [`WORD_SIZE-1:0] out // 32-bit output
);
    always @(*) begin
        out = { {`WORD_SIZE/2{in[`WORD_SIZE/2-1]}}, in }; // Sign extend the 16-bit input to 32 bits
    end
endmodule
