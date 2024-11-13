`include "definitions.svh"

// The minimum wait time is 2!
module timekeeper #(
    parameter int Frequency = 2,  // Frequency in hertz
    parameter int Time = 5,  // Time in seconds
    parameter word Wait = Frequency * Time,
    parameter int TimerBits = 32
) (
    input clk,
    input wire res,
    output reg tick
);
    initial begin
        // The minimum wait time is 2!
        assert (Wait >= 2)
        else begin
            $error("The minimum wait time of timekeeper is 2!");
            $fatal;
        end
    end

    reg [TimerBits - 1:0] timer;

    always @(posedge clk) begin
        if (res == 1) begin
            timer <= 0;
            tick  <= 0;
        end else begin
            timer <= timer + 1;

            // Subtract one because it takes one tick for tick <= 1 to be registered!
            if (timer == Wait - 1) begin
                tick <= 1;
            end
        end
    end

endmodule
