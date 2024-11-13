`include "definitions.svh"
`include "isa_definitions.svh"

`define ALU_SRC_IMMEDIATE 1
`define ALU_SRC_NONIMMEDIATE 0

`define START_STATE 4'd0
`define OP_STATE 4'd1
`define OP_IMM_STATE 4'd2
`define LUI_STATE 4'd3
`define AUIPC_STATE 4'd4
`define BRANCH_STATE 4'd5

module ctrl (
    input clk,
    input res,

    input  instr_t instr_read,
    output logic   instr_req,
    input  logic   instr_valid,

    output logic alusrc_pc,
    output logic immediatetoreg,
    output logic pc_enable,
    output logic branch,
    output logic memtoreg,
    output logic memwrite,
    output logic alusrc,
    output logic regwrite
);

    wire tk_tick;
    reg  tk_res;

    timekeeper #(
        .Wait(2),
        .TimerBits(2)
    ) tk (
        .clk (clk),
        .res (tk_res),
        .tick(tk_tick)
    );

    logic is_end_state;
    logic processing;
    logic [3:0] state;

    always_comb begin
        instr_req = 0;
        pc_enable = 0;
        branch = 0;
        memtoreg = 0;
        memwrite = 0;
        regwrite = 0;
        alusrc = `ALU_SRC_NONIMMEDIATE;
        immediatetoreg = 0;
        alusrc_pc = 0;

        if (is_end_state) pc_enable = 1;

        unique casez (state)
            `START_STATE: instr_req = 1;
            `BRANCH_STATE: begin
                alusrc = `ALU_SRC_NONIMMEDIATE;
            end
            `LUI_STATE: begin
                immediatetoreg = 1;
                regwrite = is_end_state;
            end
            `AUIPC_STATE: begin
                alusrc_pc = 1;
                alusrc = `ALU_SRC_IMMEDIATE;
                regwrite = is_end_state;
            end
            `OP_STATE: begin
                alusrc   = `ALU_SRC_NONIMMEDIATE;
                regwrite = is_end_state;
            end
            `OP_IMM_STATE: begin
                alusrc   = `ALU_SRC_IMMEDIATE;
                regwrite = is_end_state;
            end
            default: ;
        endcase
    end

    always_ff @(posedge clk) begin
        if (res) begin
            state <= `START_STATE;
            processing <= 0;
            is_end_state <= 0;
        end else if (state == `START_STATE && instr_valid == 1) begin
            unique case (instr_read[6:2])
                `ISA_OPMAP_OP_IMM: state <= `OP_IMM_STATE;
                `ISA_OPMAP_OP: state <= `OP_STATE;
                `ISA_OPMAP_LUI: state <= `LUI_STATE;
                `ISA_OPMAP_AUIPC: state <= `AUIPC_STATE;
                `ISA_OPMAP_BRANCH: state <= `BRANCH_STATE;

                default: begin
                    $display("Unsupported instruction %8h!", instr_read);
                    $fatal;
                end
            endcase

            processing <= 1;
            tk_res <= 1;
        end else if (processing && tk_tick) begin
            processing   <= 0;
            is_end_state <= 1;
        end else if (is_end_state) begin
            state <= `START_STATE;
            is_end_state <= 0;
        end else begin
            tk_res <= 0;
        end
    end

endmodule
