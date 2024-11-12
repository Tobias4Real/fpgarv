`include "definitions.svh"

module timekeeper #(
    parameter word FREQUENCY = 2,  // FREQUENCY IN HERTZ
    parameter word TIME = 5,  // TIME IN SECONDS
    parameter word WAIT = FREQUENCY * TIME
) (
    input clk,
    input wire res,
    output reg tick
);
    word timer;

    always @(posedge clk) begin
        if (res == 1) begin
            timer <= 0;
            tick  <= 0;
        end else begin
            timer <= timer + 1;
            if (timer == WAIT - 1) begin
                tick <= 1;
            end
        end
    end

endmodule
