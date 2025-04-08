// Jacob Panov
// This file contains parameter definitions for the project.
// definitions.v

// General parameters
`define WORD_SIZE 32          // Word size in bits
`define BYTE_SIZE 8           // Byte size in bits
`define MEMORY_SIZE 1024      // Memory size in words for data and instruction memory
`define ADDRESS_WIDTH 10      // Address width (log2(MEMORY_SIZE))
`define EXE_LENGTH 4          // Execution length in bytes

// ALU operation codes
`define ALU_ADD  4'b0000      // ALU operation: Add
`define ALU_SUB  4'b0010      // ALU operation: Subtract
`define ALU_AND  4'b0100      // ALU operation: AND
`define ALU_OR   4'b0101      // ALU operation: OR
`define ALU_NOR  4'b0110      // ALU operation: NOR
`define ALU_XOR  4'b0111      // ALU operation: XOR
`define ALU_SLA  4'b1001      // ALU operation: Shift Left Arithmetic
`define ALU_SLL  4'b0110      // ALU operation: Shift Left Logical
`define ALU_SRA  4'b1001      // ALU operation: Shift Right Arithmetic
`define ALU_SRL  4'b1010      // ALU operation: Shift Right Logical
`define ALU_NON  4'b1111      // ALU operation: No Operation