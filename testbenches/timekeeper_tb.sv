`define CYCLE 2

module timekeeper_tb ();

    reg  clk;
    reg  res;
    wire tick;

    always #1 clk = ~clk;

    timekeeper #(
        .Frequency(2),
        .Time(5)
    ) dut (
        .*
    );

    initial begin
        clk = 0;
        res = 1;
        #(`CYCLE);
        res = 0;
        if (tick !== 0) begin
            $display("Test 1: Reset failed (tick: %0d)!", tick);
            $finish;
        end else begin
            $display("Reset disabled at time: %0t!", $time);
        end

        #(10 * `CYCLE);
        if (tick !== 1) begin
            $display("Test 2: Wait failed!");
            $finish;
        end
        $finish;
    end

endmodule
;
