// Jacob Panov
// This module implements a sign extension unit for a 16-bit input to a 32-bit output.
// sign_extend.sv

`include "definitions.v"

module sign_extend (
    input logic [`WORD_SIZE/2-1:0] in, // 16-bit input
    output logic [`WORD_SIZE-1:0] out // 32-bit output
);
    always_comb begin
        out = { {`WORD_SIZE/2{in[`WORD_SIZE/2-1]}}, in }; // Sign extend the 16-bit input to 32 bits
    end
endmodule
