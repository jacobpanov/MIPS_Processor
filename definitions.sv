// Jacob Panov
// This file contains parameter definitions for the project.
// definitions.sv

// General parameters
`define WORD_SIZE 32          // Word size in bits
`define BYTE_SIZE 8           // Byte size in bits
`define MEMORY_SIZE 1024      // Memory size in words for data and instruction memory
`define ADDRESS_WIDTH 10      // Address width (log2(MEMORY_SIZE))
`define EXE_LENGTH 4          // Execution length in bytes
`define REG_FILE_ADDR_LEN 5   // Address width for register file (log2(REG_FILE_SIZE))
`define REG_FILE_SIZE 32      // Number of registers in the register file
`define INSTR_MEM_SIZE 1024   // Number of instructions in instruction memory
`define DATA_MEM_SIZE 1024    // Number of memory cells in data memory
`define MEM_CELL_SIZE 8       // Width of each memory cell in bits

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

// Opcode definitions
`define OP_NOP 6'b000000      // No operation
`define OP_ADD 6'b000001      // Add operation
`define OP_SUB 6'b000011      // Subtract operation
`define OP_AND 6'b000101      // AND operation
`define OP_OR 6'b000110       // OR operation
`define OP_NOR 6'b000111      // NOR operation
`define OP_XOR 6'b001000      // XOR operation
`define OP_SLA 6'b001001      // Shift Left Arithmetic
`define OP_SLL 6'b001010      // Shift Left Logical
`define OP_SRA 6'b001011      // Shift Right Arithmetic
`define OP_SRL 6'b001100      // Shift Right Logical
`define OP_ADDI 6'b100000     // Add Immediate operation
`define OP_SUBI 6'b100001     // Subtract Immediate operation
`define OP_LD 6'b100100       // Load operation
`define OP_ST 6'b100101       // Store operation
`define OP_BEZ 6'b101000      // Branch if Equal to Zero operation
`define OP_BNE 6'b101001      // Branch if Not Equal to Zero operation
`define OP_JMP 6'b101010      // Jump operation