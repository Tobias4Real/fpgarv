`include "definitions.svh"

// Register Set that prioritizes reset over write
module regset #(
    parameter REGISTER_COUNT = `REGISTER_COUNT,
    parameter ENABLE_RESET   = 0
) (
    input word write,
    input regnum write_reg,
    output word q0,
    input regnum q0_reg,
    output word q1,
    input regnum q1_reg,
    input write_enable,
    input res,
    input clk
);

    word regset[REGISTER_COUNT-1:1];

    assign q0 = (q0_reg == 0) ? 0 : regset[q0_reg];
    assign q1 = (q1_reg == 0) ? 0 : regset[q1_reg];

    always @(posedge clk) begin
        if (ENABLE_RESET) begin
            if (res) begin
                for (integer i = 0; i < REGISTER_COUNT; i += 1) begin
                    regset[i] <= 0;
                end
            end else if (write_enable && write_reg != 0) begin
                regset[write_reg] <= write;
            end
        end else if (write_enable && write_reg != 0) begin
            regset[write_reg] <= write;
        end
    end

endmodule
