`include "definitions.svh"

// Register Set that prioritizes reset over write
module regset #(
    parameter int   RegisterCount = `REGISTER_COUNT,
    parameter logic EnableReset   = 0
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

    word regset[RegisterCount-1:1];

    assign q0 = (q0_reg == 0) ? 0 : regset[q0_reg];
    assign q1 = (q1_reg == 0) ? 0 : regset[q1_reg];

    always @(posedge clk) begin
        if (EnableReset) begin
            if (res) begin
                for (integer i = 0; i < RegisterCount; i += 1) begin
                    regset[i] <= 0;
                end
            end else if (write_enable && write_reg != 0) begin
                regset[write_reg] <= write;
            end
        end else if (write_enable && write_reg != 0) begin
            regset[write_reg] <= write;
`ifdef DEBUG
            $display("write (%0d) in (x%2d)", $signed(write), write_reg);
`endif
        end
    end

endmodule
