`include "definitions.svh"

module timekeeper #(
    parameter int Frequency = 2,  // Frequency in hertz
    parameter int Time = 5,  // Time in seconds
    parameter word Wait = Frequency * Time
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
            if (timer == Wait - 1) begin
                tick <= 1;
            end
        end
    end

endmodule
