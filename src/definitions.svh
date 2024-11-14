`ifndef DEFINITIONS_H_
`define DEFINITIONS_H_
`define DEBUG

`define WORD_SIZE 32
`define INSTRUCTION_SIZE_IN_BYTES 4

`define REGISTER_COUNT 32

typedef logic [`WORD_SIZE-1:0] word;
typedef logic [$clog2(`REGISTER_COUNT)-1:0] regnum;
typedef logic [31:0] instr_t;

`define PC_MODE_INCREMENT 0
`define PC_MODE_JUMP 1
`define PC_INIT_ADDR 32'h1A00_0000
`endif
