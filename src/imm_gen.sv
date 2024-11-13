`include "definitions.svh"
`include "isa_definitions.svh"

module imm_gen (
    input instr_t inst,
    output word immediate
);
    always_comb begin
        // See page 25 of "The RISC-V instuction Set Manual Volume 1 (2024-04-11)."
        unique case (inst[6:2])
            // S-immediate
            `ISA_OPMAP_STORE, `ISA_OPMAP_STORE_FP: immediate = $signed({inst[31:25], inst[11:7]});

            // B-immediate
            `ISA_OPMAP_BRANCH:
            immediate = $signed({inst[31], inst[7], inst[30:25], inst[11:8], 1'b0});

            // U-immediate
            `ISA_OPMAP_LUI, `ISA_OPMAP_AUIPC: immediate = {inst[31:12], 12'b0};

            // J-immediate
            `ISA_OPMAP_JAL:
            immediate = $signed({inst[31], inst[19:12], inst[20], inst[30:21], 1'b0});

            /**
            I-immediate

            `ISA_OPMAP_OP_IMM,
            `ISA_OPMAP_OP_IMM_32,
            `ISA_OPMAP_OP_LOAD,
            `ISA_OPMAP_OP_LOAD_FP,
            `ISA_OPMAP_OP_MISC_MEM,
            `ISA_OPMAP_OP_JALR
            **/
            default: immediate = $signed(inst[31:20]);
        endcase


    end
endmodule
