`include "definitions.svh"

`define PM_FETCH_DELAY 1
`define PM_SIZE 304

module proc_tb ();
    reg clk;
    reg res;

    instr_t instr_read;
    word instr_addr;
    logic instr_req;
    logic instr_valid;

    word data_read;
    word data_write;
    word data_addr;
    logic data_req;
    logic data_valid;
    logic data_write_enable;
    logic [3:0] data_be;

    logic irq;
    logic [4:0] irq_id;
    logic irq_ack;
    logic [4:0] irq_ack_id;

    reg [7:0] program_memory[`PM_SIZE];

    proc dut (.*);
    always #1 clk = ~clk;

    int  pm_fetch_state = 0;
    word pm_fetch_addr;
    word last_pm_fetch_addr;

    always_ff @(posedge clk) begin
        if (instr_req == 0) begin
            instr_valid <= 0;
            pm_fetch_state <= 0;
            instr_read <= 0;
        end else if (pm_fetch_state == 0 && instr_req == 1) begin
`ifdef DEBUG
            $display("l %0d", instr_addr - `PC_INIT_ADDR);
`endif
            pm_fetch_state <= 1;
            pm_fetch_addr  <= instr_addr - `PC_INIT_ADDR;
        end else if (pm_fetch_state == `PM_FETCH_DELAY) begin
            if (pm_fetch_addr >= `PM_SIZE) begin
                $info("Trying to fetch next instruction, but there is nothing to fetch :(!");
                $finish;
            end
            instr_valid <= 1;
            instr_read <= {
                program_memory[pm_fetch_addr],
                program_memory[pm_fetch_addr+1],
                program_memory[pm_fetch_addr+2],
                program_memory[pm_fetch_addr+3]
            };
            pm_fetch_state <= pm_fetch_state + 1;
`ifdef DEBUG
            $display("li %8h", {program_memory[pm_fetch_addr], program_memory[pm_fetch_addr+1],
                                program_memory[pm_fetch_addr+2], program_memory[pm_fetch_addr+3]});
`endif
        end else if (pm_fetch_state > 0) begin
            pm_fetch_state <= pm_fetch_state + 1;
        end

    end

    initial begin
        clk = 0;
        res = 1;
        #2;
        res = 0;

        $readmemh("asm/test.mem", program_memory);
        #1000000;
        $display("Out of time. What happened?");
        $finish;

    end



endmodule
