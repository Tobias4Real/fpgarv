`include "definitions.svh"

/**
* TODO: Fetch new instructions only until the privileged instruction "WFI" (Wait for interrupt) is reached!
*/

module proc (
    input clk,
    input res,

    input instr_t instr_read,
    output word instr_addr,
    output logic instr_req,
    input logic instr_valid,

    input word data_read,
    output word data_write,
    output word data_addr,
    output logic data_req,
    input logic data_valid,
    output logic data_write_enable,
    output logic [3:0] data_be,

    input logic irq,
    input logic [4:0] irq_id,
    input logic irq_ack,
    input logic [4:0] irq_ack_id
);

    instr_t instr_cache;

    word immediate;

    logic ctrl_alusrc_pc;
    logic ctrl_branch;
    logic ctrl_regwrite;
    logic ctrl_memtoreg;
    logic ctrl_alusrc;
    logic ctrl_immediatetoreg;

    logic alu_cmp;
    word alu_result;

    word regset_q0;
    word regset_q1;

    logic pc_enable;

    pc proc_pc (
        .clk(clk),
        .res(res),

        .jmp_addr(immediate + instr_addr),
        .pc(instr_addr),
        .enable(pc_enable),
        .mode(ctrl_branch && alu_cmp)
    );

    ctrl proc_ctrl (
        .clk(clk),
        .res(res),

        .instr_req  (instr_req),
        .instr_valid(instr_valid),
        .instr_read (instr_read),

        .alusrc_pc(ctrl_alusrc_pc),
        .immediatetoreg(ctrl_immediatetoreg),
        .pc_enable(pc_enable),
        .branch(ctrl_branch),
        .memtoreg(ctrl_memtoreg),
        .memwrite(data_write_enable),
        .alusrc(ctrl_alusrc),
        .regwrite(ctrl_regwrite)

    );

    word regset_write;
    assign regset_write = ctrl_immediatetoreg ? immediate :
    (ctrl_memtoreg ? data_read : alu_result);

    regset #(
        .EnableReset(0)
    ) proc_regset (
        .clk(clk),
        .res(res),

        .write(regset_write),
        .write_enable(ctrl_regwrite),
        .write_reg(instr_cache[11:7]),
        .q0_reg(instr_cache[19:15]),
        .q1_reg(instr_cache[24:20]),
        .q0(regset_q0),
        .q1(regset_q1)
    );

    logic [5:0] alu_ctrl;
    word alu_input_b;
    word alu_input_a;
    assign alu_input_a = ctrl_alusrc_pc ? instr_addr : regset_q0;
    assign alu_input_b = ctrl_alusrc ? immediate : regset_q1;
    assign alu_ctrl = ctrl_alusrc_pc ? 0 : {instr_cache[30], instr_cache[14:12], instr_cache[6:5]};

    alu proc_alu (
        .ctrl(alu_ctrl),
        .a(alu_input_a),
        .b(alu_input_b),

        .cmp(alu_cmp),
        .result(alu_result)
    );

    imm_gen proc_imm_gen (
        .inst(instr_cache),
        .immediate(immediate)
    );

    always_ff @(posedge clk) begin
        if (instr_valid == 1) begin
            instr_cache <= instr_read;
        end

`ifdef DEBUG
        $display("(instr: %0h, a: %0d b: %0d, ctrl: %6b, pc: %8h, imm: %0d)", instr_cache,
                 $signed(alu_input_a), $signed(alu_input_b), alu_ctrl, instr_addr, immediate);
`endif

        if (alu_cmp == 1 && pc_enable) begin
            $error("Failure!!");
            $fatal;
        end
    end
endmodule
