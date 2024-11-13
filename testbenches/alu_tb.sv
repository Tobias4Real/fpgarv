module alu_tb ();
    localparam logic EnableRv32M = 1;

    reg [31:0] a, b;
    reg [5:0] ctrl;
    wire [31:0] result;
    wire cmp;
    reg [31:0] soll;

    alu #(
        .EnableRv32M(EnableRv32M)
    ) dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .result(result),
        .cmp(cmp)
    );

    initial begin
        a = 0;
        b = 0;
        ctrl = 6'b100011;
        soll = 1;
        #10;
        if (cmp != soll) begin
            $display("Test 1 fehlgeschlagen: Equal falsch (Ist: %0d, ctrloll: %0d)", cmp, soll);
            $finish;
        end

        a = 1;
        b = 2;
        ctrl = 6'b000011;
        soll = 0;
        #10;
        if (cmp != soll) begin
            $display("Test 2 fehlgeschlagen: Equal falsch (Ist: %0d, ctrloll: %0d)", cmp, soll);
            $finish;
        end

        a = 401;
        b = 242;
        ctrl = 6'b100011;
        soll = 0;
        #10;
        if (cmp != soll) begin
            $display("Test 3 fehlgeschlagen: Equal falsch (Ist: %0d, ctrloll: %0d)", cmp, soll);
            $finish;
        end

        a = 42;
        b = -2048;
        ctrl = 6'b100000;
        soll = -2006;
        #10;
        if (result != soll) begin
            $display("Test 4 fehlgeschlagen: addition falsch (Ist: %0d, ctrloll: %0d)", result,
                     soll);
            $finish;
        end

        a = -42;
        b = 69;
        ctrl = 6'b000001;
        soll = 27;
        #10;
        if (result != soll) begin
            $display("Test 5 fehlgeschlagen: addition falsch (Ist: %0d, ctrloll: %0d)", result,
                     soll);
            $finish;
        end

        a = 2147483647;
        b = 1;
        ctrl = 6'b000001;
        soll = -2147483648;
        #10;
        if (result != soll) begin
            $display("Test 6 fehlgeschlagen: addition falsch (Ist: %0d, ctrloll: %0d)", result,
                     soll);
            $finish;
        end

        a = 6942;
        b = 4269;
        ctrl = 6'b100001;
        soll = 2673;
        #10;
        if (result != soll) begin
            $display("Test 7 fehlgeschlagen: ctrlubtraktion falsch (Ist: %0d, ctrloll: %0d)",
                     result, soll);
            $finish;
        end

        a = 1;
        b = 56;
        ctrl = 6'b100001;
        soll = -55;
        #10;
        if (result != soll) begin
            $display("Test 8 fehlgeschlagen: subtraktion falsch (Ist: %0d, ctrloll: %0d)", result,
                     soll);
            $finish;
        end

        a = -69;
        b = 42;
        ctrl = 6'b011101;
        soll = 42;
        #10;
        if (result != soll) begin
            $display("Test 9 fehlgeschlagen: AND falsch (Ist: %0d, ctrloll: %0d)", result, soll);
            $finish;
        end

        a = 3;
        b = 2;
        ctrl = 6'b011100;
        soll = 2;
        #10;
        if (result != soll) begin
            $display("Test 10 fehlgeschlagen: aND falsch (Ist: %0d, ctrloll: %0d)", result, soll);
            $finish;
        end

        a = 69;
        b = 42;
        ctrl = 6'b011001;
        soll = 111;
        #10;
        if (result != soll) begin
            $display("Test 11 fehlgeschlagen: OR falsch (Ist: %0d, ctrloll: %0d)", result, soll);
            $finish;
        end

        a = -69;
        b = -42;
        ctrl = 6'b011001;
        soll = -1;
        #10;
        if (result != soll) begin
            $display("Test 12 fehlgeschlagen: OR falsch (Ist: %0d, ctrloll: %0d)", result, soll);
            $finish;
        end

        a = 69;
        b = 42;
        ctrl = 6'b010000;
        soll = 111;
        #10;
        if (result != soll) begin
            $display("Test 13 fehlgeschlagen: XOR falsch (Ist: %0d, ctrloll: %0d)", result, soll);
            $finish;
        end

        a = -1001;
        b = 69;
        ctrl = 6'b010001;
        soll = -942;
        #10;
        if (result != soll) begin
            $display("Test 14 fehlgeschlagen: XOR falsch (Ist: %0d, ctrloll: %0d)", result, soll);
            $finish;
        end

        a = 69;
        b = 1;
        ctrl = 6'b000100;
        soll = 138;
        #10;
        if (result != soll) begin
            $display("Test 15 fehlgeschlagen: Logical shift left falsch (Ist: %0d, ctrloll: %0d)",
                     result, soll);
            $finish;
        end

        a = 42;
        b = 33;
        ctrl = 6'b000101;
        soll = 84;
        #10;
        if (result != soll) begin
            $display("Test 16 fehlgeschlagen: Logical shift left falsch (Ist: %0d, ctrloll: %0d)",
                     result, soll);
            $finish;
        end

        a = 69;
        b = 2;
        ctrl = 6'b010101;
        soll = 17;
        #10;
        if (result != soll) begin
            $display("Test 17 fehlgeschlagen: Logical shift right falsch (Ist: %0d, ctrloll: %0d)",
                     result, soll);
            $finish;
        end

        a = -69;
        b = 1;
        ctrl = 6'b010101;
        soll = 2147483613;
        #10;
        if (result != soll) begin
            $display("Test 18 fehlgeschlagen: Logical shift right falsch (Ist: %0d, ctrloll: %0d)",
                     result, soll);
            $finish;
        end

        a = -69;
        b = 1;
        ctrl = 6'b110101;
        soll = -35;
        #10;
        if (result != soll) begin
            $display(
                "Test 19 fehlgeschlagen: arithmetic shift right falsch (Ist: %0d, ctrloll: %0d)",
                result, soll);
            $finish;
        end

        a = 69;
        b = 33;
        ctrl = 6'b110101;
        soll = 34;
        #10;
        if (result != soll) begin
            $display(
                "Test 20 fehlgeschlagen: arithmetic shift right falsch (Ist: %0d, ctrloll: %0d)",
                result, soll);
            $finish;
        end

        a = 69;
        b = 42;
        ctrl = 6'b001000;
        soll = 0;
        #10;
        if (result != soll) begin
            $display("Test 21 fehlgeschlagen: Less than falsch (Ist: %0d, ctrloll: %0d)", result,
                     soll);
            $finish;
        end

        a = -1;
        b = 2;
        ctrl = 6'b001001;
        soll = 1;
        #10;
        if (result != soll) begin
            $display("Test 22 fehlgeschlagen: Less than falsch (Ist: %0d, ctrloll: %0d)", result,
                     soll);
            $finish;
        end

        a = 42;
        b = 69;
        ctrl = 6'b101100;
        soll = 1;
        #10;
        if (result != soll) begin
            $display("Test 23 fehlgeschlagen: Less than (unsigned) falsch (Ist: %0d, ctrloll: %0d)",
                     result, soll);
            $finish;
        end

        a = -1;
        b = 42;
        ctrl = 6'b001101;
        soll = 0;
        #10;
        if (result != soll) begin
            $display("Test 24 fehlgeschlagen: Less than (unsigned) falsch (Ist: %0d, ctrloll: %0d)",
                     result, soll);
            $finish;
        end

        a = 69;
        b = 70;
        ctrl = 6'b100111;
        soll = 1;
        #10;
        if (cmp != soll) begin
            $display("Test 25 fehlgeschlagen: Not equal falsch (Ist: %0d, ctrloll: %0d)", cmp,
                     soll);
            $finish;
        end

        a = -42;
        b = -42;
        ctrl = 6'b000111;
        soll = 0;
        #10;
        if (cmp != soll) begin
            $display("Test 26 fehlgeschlagen: Not equal falsch (Ist: %0d, ctrloll: %0d)", cmp,
                     soll);
            $finish;
        end

        a = 42;
        b = 69;
        ctrl = 6'b010011;
        soll = 1;
        #10;
        if (cmp != soll) begin
            $display("Test 27 fehlgeschlagen: Less than falsch (Ist: %0d, ctrloll: %0d)", cmp,
                     soll);
            $finish;
        end

        a = 69;
        b = -1;
        ctrl = 6'b110011;
        soll = 0;
        #10;
        if (cmp != soll) begin
            $display("Test 28 fehlgeschlagen: Less than falsch (Ist: %0d, ctrloll: %0d)", cmp,
                     soll);
            $finish;
        end

        a = -42;
        b = -42;
        ctrl = 6'b110111;
        soll = 1;
        #10;
        if (cmp != soll) begin
            $display("Test 29 fehlgeschlagen: Greater equal falsch (Ist: %0d, ctrloll: %0d)", cmp,
                     soll);
            $finish;
        end

        a = -1;
        b = -3;
        ctrl = 6'b010111;
        soll = 1;
        #10;
        if (cmp != soll) begin
            $display("Test 30 fehlgeschlagen: Greater equal falsch (Ist: %0d, ctrloll: %0d)", cmp,
                     soll);
            $finish;
        end

        a = -1;
        b = -3;
        ctrl = 6'b111011;
        soll = 0;
        #10;
        if (cmp != soll) begin
            $display("Test 31 fehlgeschlagen: Less than (unsigned) falsch (Ist: %0d, ctrloll: %0d)",
                     cmp, soll);
            $finish;
        end

        a = 8;
        b = 9;
        ctrl = 6'b011011;
        soll = 1;
        #10;
        if (cmp != soll) begin
            $display("Test 32 fehlgeschlagen: Less than (unsigned) falsch (Ist: %0d, ctrloll: %0d)",
                     cmp, soll);
            $finish;
        end

        a = 69;
        b = 69;
        ctrl = 6'b011111;
        soll = 1;
        #10;
        if (cmp != soll) begin
            $display(
                "Test 33 fehlgeschlagen: Greater equal (unsigned) falsch (Ist: %0d, ctrloll: %0d)",
                cmp, soll);
            $finish;
        end

        a = 42;
        b = 69;
        ctrl = 6'b111111;
        soll = 0;
        #10;
        if (cmp != soll) begin
            $display(
                "Test 34 fehlgeschlagen: Greater equal (unsigned) falsch (Ist: %0d, ctrloll: %0d)",
                cmp, soll);
            $finish;
        end

        $display("all alu-tests successful!");
        $finish;
    end
endmodule
