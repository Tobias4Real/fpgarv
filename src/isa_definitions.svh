`ifndef ISA_DEFINITIONS_H_
`define ISA_DEFINITIONS_H_

`define ISA_OPMAP_OP 5'b01100
`define ISA_OPMAP_OP_32 5'b01110

`define ISA_OPMAP_OP_IMM 5'b00100
`define ISA_OPMAP_OP_IMM_32 5'b00110

`define ISA_OPMAP_AUIPC 5'b00101
`define ISA_OPMAP_LUI 5'b01101

`define ISA_OPMAP_LOAD 5'b00000
`define ISA_OPMAP_LOAD_FP 5'b00001

`define ISA_OPMAP_STORE 5'b01000
`define ISA_OPMAP_STORE_FP 5'b01001

`define ISA_OPMAP_BRANCH 5'b11000

`define ISA_OPMAP_JAL 5'b11011
`define ISA_OPMAP_JALR 5'b11001

`define ISA_OPMAP_MISC_MEM 5'b00100

`endif
