`define CYCLE 2
`define TIMEKEEPER_WAIT 24

module trafficlight_tb ();
    reg clk;
    reg btn;
    reg resn;

    reg [2:0] exp;
    wire [2:0] rgb;

    trafficlight dut (.*);


    always #1 clk = ~clk;

    initial begin
        clk  = 0;
        btn  = 0;
        resn = 0;
        #`CYCLE;
        resn = 1;

        exp  = 3'b100;
        assert (rgb === exp)
        else begin
            $error("Test case 1 failed (value: %3b, expected: %3b)!", rgb, exp);
            $fatal;
        end

        #100;

        exp = 3'b100;
        assert (rgb === exp)
        else begin
            $error("Test case 2 failed (value: %3b, expected: %3b)!", rgb, exp);
            $fatal;
        end

        btn = 1;
        #2;
        btn = 0;
        $display("BUTTON pressed!");
        #20 exp = 3'b110;
        assert (rgb === exp)
        else begin
            $error("Test case 3 failed (value: %3b, expected: %3b)!", rgb, exp);
            $fatal;
        end

        #20 exp = 3'b010;
        assert (rgb === exp)
        else begin
            $error("Test case 4 failed (value: %3b, expected: %3b)!", rgb, exp);
            $fatal;
        end

        #20 exp = 3'b110;
        assert (rgb === exp)
        else begin
            $error("Test case 5 failed (value: %3b, expected: %3b)!", rgb, exp);
            $fatal;
        end

        #20 exp = 3'b100;
        assert (rgb === exp)
        else begin
            $error("Test case 6 failed (value: %3b, expected: %3b)!", rgb, exp);
            $fatal;
        end


        #100;
        exp = 3'b100;
        assert (rgb === exp)
        else begin
            $error("Test case 7 failed (value: %3b, expected: %3b)!", rgb, exp);
            $fatal;
        end

        $finish;

    end

endmodule
