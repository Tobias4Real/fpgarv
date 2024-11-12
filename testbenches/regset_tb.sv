`include "definitions.svh"

module regset_tb ();
    word write;
    regnum write_reg;
    word q0;
    regnum q0_reg;
    word q1;
    regnum q1_reg;
    reg write_enable;
    reg res;
    reg clk;

    localparam logic EnableReset = 0;

    regset #(
        .RegisterCount(`REGISTER_COUNT),
        .EnableReset  (EnableReset)
    ) dut (
        .*
    );

    word q0_exp;
    word q1_exp;
    word tmp;

    always #5 clk = ~clk;

    initial begin
        //Doesn't work with iverilog for some reason!
        //$srandom (42);

        q0_exp = 0;
        q1_exp = 0;
        tmp = 0;
        clk = 0;
        res = 0;

        // First Test: Testing of write and then read of two values!
        q0_reg = 1;
        q1_reg = 2;
        write_reg = 1;
        write = 42;
        write_enable = 1;

        @(negedge clk);
        write = 69;
        write_reg = 2;

        @(negedge clk);
        q0_exp = 42;
        q1_exp = 69;

        if (q0 !== q0_exp || q1 !== q1_exp) begin
            $display("Test #1 (write & read) failed! Value of (q0, q1) = (%0d, %0d) !== (%0d, %0d)",
                     q0, q1, q0_exp, q1_exp);
            $finish;
        end
        write_enable = 0;
        // --- End test ---
        // Second Test: Testing whether reset works and regset prioritizes reset over write as expected with write_enable = 1 and res = 1.
        clk = 0;
        res = 1;
        write_enable = 1;
        write = 37;

        q0_exp = 0;
        q1_exp = 0;
        for (integer i = 0; i < `REGISTER_COUNT; i += 1) begin
            q0_reg = i;
            q1_reg = i;
            @(negedge clk);
            if (EnableReset && (q0 !== q0_exp || q1 !== q1_exp)) begin
                $display(
                    "Test #2 (reset w/write_enable) failed (i=%0d). Got: (%0d, %0d) !== (%0d, %0d)",
                    i, q0, q1, q0_exp, q1_exp);
                $finish;
            end
        end
        write_enable = 0;
        // --- End test ---
        // Third test: Fill register set with random values
        clk = 0;
        res = 0;
        write_enable = 1;
        tmp = $urandom;

        for (integer i = 0; i < `REGISTER_COUNT; i += 1) begin
            write = tmp + i;
            write_reg = i;
            @(negedge clk);
        end
        write_enable = 0;

        // Exclude zero-register
        for (integer i = 1; i < `REGISTER_COUNT - 1; i += 2) begin
            q0_exp = tmp + i;
            q1_exp = tmp + i + 1;
            q0_reg = i;
            q1_reg = i + 1;

            #1;

            if (q0 !== q0_exp || q1 !== q1_exp) begin
                $display("Test #3 failed! (q0, q1)=(%0d, %0d) !== expected (%0d, %0d)", q0, q1,
                         q0_exp, q1_exp);
                $finish;
            end
        end
        // --- End test ---
        // Forfth Test: Testing of zero-register
        q0_exp = 0;
        q1_exp = 0;
        q0_reg = 0;
        q1_reg = 0;

        #1;

        if (q0 !== q0_exp || q1 !== q1_exp) begin
            $display("Test #4 (zero register) failed! (q0, q1) = (%0d, %0d) !== (%0d, %0d)", q0,
                     q1, q0_exp, q1_exp);
            $finish;
        end

        // --- End test ---
        // Fifth Test: Testing whether reset works.
        clk = 0;
        res = 1;
        write_enable = 0;
        write = 37;

        @(negedge clk);
        res = 0;

        q0_exp = 0;
        q1_exp = 0;
        for (integer i = 0; i < `REGISTER_COUNT; i = i + 1) begin
            q0_reg = i;
            q1_reg = i;
            @(negedge clk);
            if (EnableReset && (q0 !== q0_exp || q1 !== q1_exp)) begin
                $display("Test #5 (reset) failed at i=%0d! (q0, q1)=(%0d, %0d) !== (%0d, %0d)", i,
                         q0, q1, q0_exp, q1_exp);
                $finish;
            end
        end
        // --- End test ---

        $display("All regset-tests passed with flying colors!");
        $finish;
    end
endmodule
