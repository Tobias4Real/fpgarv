module alu_tb ();
    localparam logic EnableRv32M = 1;

    reg [31:0] A, B;
    reg [5:0] S;
    wire [31:0] Q;
    wire CMP;
    reg [31:0] soll;

    alu #(
        .EnableRv32M(EnableRv32M)
    ) dut (
        .A  (A),
        .B  (B),
        .S  (S),
        .Q  (Q),
        .CMP(CMP)
    );

    initial begin
        A = 0;
        B = 0;
        S = 6'b100011;
        soll = 1;
        #10;
        if (CMP != soll) begin
            $display("Test 1 fehlgeschlagen: Equal falsch (Ist: %0d, Soll: %0d)", CMP, soll);
            $finish;
        end

        A = 1;
        B = 2;
        S = 6'b000011;
        soll = 0;
        #10;
        if (CMP != soll) begin
            $display("Test 2 fehlgeschlagen: Equal falsch (Ist: %0d, Soll: %0d)", CMP, soll);
            $finish;
        end

        A = 401;
        B = 242;
        S = 6'b100011;
        soll = 0;
        #10;
        if (CMP != soll) begin
            $display("Test 3 fehlgeschlagen: Equal falsch (Ist: %0d, Soll: %0d)", CMP, soll);
            $finish;
        end

        A = 42;
        B = -2048;
        S = 6'b100000;
        soll = -2006;
        #10;
        if (Q != soll) begin
            $display("Test 4 fehlgeschlagen: Addition falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = -42;
        B = 69;
        S = 6'b000001;
        soll = 27;
        #10;
        if (Q != soll) begin
            $display("Test 5 fehlgeschlagen: Addition falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = 2147483647;
        B = 1;
        S = 6'b000001;
        soll = -2147483648;
        #10;
        if (Q != soll) begin
            $display("Test 6 fehlgeschlagen: Addition falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = 6942;
        B = 4269;
        S = 6'b100001;
        soll = 2673;
        #10;
        if (Q != soll) begin
            $display("Test 7 fehlgeschlagen: Subtraktion falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = 1;
        B = 56;
        S = 6'b100001;
        soll = -55;
        #10;
        if (Q != soll) begin
            $display("Test 8 fehlgeschlagen: Subtraktion falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = -69;
        B = 42;
        S = 6'b011101;
        soll = 42;
        #10;
        if (Q != soll) begin
            $display("Test 9 fehlgeschlagen: AND falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = 3;
        B = 2;
        S = 6'b011100;
        soll = 2;
        #10;
        if (Q != soll) begin
            $display("Test 10 fehlgeschlagen: AND falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = 69;
        B = 42;
        S = 6'b011001;
        soll = 111;
        #10;
        if (Q != soll) begin
            $display("Test 11 fehlgeschlagen: OR falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = -69;
        B = -42;
        S = 6'b011001;
        soll = -1;
        #10;
        if (Q != soll) begin
            $display("Test 12 fehlgeschlagen: OR falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = 69;
        B = 42;
        S = 6'b010000;
        soll = 111;
        #10;
        if (Q != soll) begin
            $display("Test 13 fehlgeschlagen: XOR falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = -1001;
        B = 69;
        S = 6'b010001;
        soll = -942;
        #10;
        if (Q != soll) begin
            $display("Test 14 fehlgeschlagen: XOR falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = 69;
        B = 1;
        S = 6'b000100;
        soll = 138;
        #10;
        if (Q != soll) begin
            $display("Test 15 fehlgeschlagen: Logical shift left falsch (Ist: %0d, Soll: %0d)", Q,
                     soll);
            $finish;
        end

        A = 42;
        B = 33;
        S = 6'b000101;
        soll = 84;
        #10;
        if (Q != soll) begin
            $display("Test 16 fehlgeschlagen: Logical shift left falsch (Ist: %0d, Soll: %0d)", Q,
                     soll);
            $finish;
        end

        A = 69;
        B = 2;
        S = 6'b010101;
        soll = 17;
        #10;
        if (Q != soll) begin
            $display("Test 17 fehlgeschlagen: Logical shift right falsch (Ist: %0d, Soll: %0d)", Q,
                     soll);
            $finish;
        end

        A = -69;
        B = 1;
        S = 6'b010101;
        soll = 2147483613;
        #10;
        if (Q != soll) begin
            $display("Test 18 fehlgeschlagen: Logical shift right falsch (Ist: %0d, Soll: %0d)", Q,
                     soll);
            $finish;
        end

        A = -69;
        B = 1;
        S = 6'b110101;
        soll = -35;
        #10;
        if (Q != soll) begin
            $display("Test 19 fehlgeschlagen: Arithmetic shift right falsch (Ist: %0d, Soll: %0d)",
                     Q, soll);
            $finish;
        end

        A = 69;
        B = 33;
        S = 6'b110101;
        soll = 34;
        #10;
        if (Q != soll) begin
            $display("Test 20 fehlgeschlagen: Arithmetic shift right falsch (Ist: %0d, Soll: %0d)",
                     Q, soll);
            $finish;
        end

        A = 69;
        B = 42;
        S = 6'b001000;
        soll = 0;
        #10;
        if (Q != soll) begin
            $display("Test 21 fehlgeschlagen: Less than falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = -1;
        B = 2;
        S = 6'b001001;
        soll = 1;
        #10;
        if (Q != soll) begin
            $display("Test 22 fehlgeschlagen: Less than falsch (Ist: %0d, Soll: %0d)", Q, soll);
            $finish;
        end

        A = 42;
        B = 69;
        S = 6'b001101;
        soll = 1;
        #10;
        if (Q != soll) begin
            $display("Test 23 fehlgeschlagen: Less than (unsigned) falsch (Ist: %0d, Soll: %0d)",
                     Q, soll);
            $finish;
        end

        A = -1;
        B = 42;
        S = 6'b001101;
        soll = 0;
        #10;
        if (Q != soll) begin
            $display("Test 24 fehlgeschlagen: Less than (unsigned) falsch (Ist: %0d, Soll: %0d)",
                     Q, soll);
            $finish;
        end

        A = 69;
        B = 70;
        S = 6'b100111;
        soll = 1;
        #10;
        if (CMP != soll) begin
            $display("Test 25 fehlgeschlagen: Not equal falsch (Ist: %0d, Soll: %0d)", CMP, soll);
            $finish;
        end

        A = -42;
        B = -42;
        S = 6'b000111;
        soll = 0;
        #10;
        if (CMP != soll) begin
            $display("Test 26 fehlgeschlagen: Not equal falsch (Ist: %0d, Soll: %0d)", CMP, soll);
            $finish;
        end

        A = 42;
        B = 69;
        S = 6'b010011;
        soll = 1;
        #10;
        if (CMP != soll) begin
            $display("Test 27 fehlgeschlagen: Less than falsch (Ist: %0d, Soll: %0d)", CMP, soll);
            $finish;
        end

        A = 69;
        B = -1;
        S = 6'b110011;
        soll = 0;
        #10;
        if (CMP != soll) begin
            $display("Test 28 fehlgeschlagen: Less than falsch (Ist: %0d, Soll: %0d)", CMP, soll);
            $finish;
        end

        A = -42;
        B = -42;
        S = 6'b110111;
        soll = 1;
        #10;
        if (CMP != soll) begin
            $display("Test 29 fehlgeschlagen: Greater equal falsch (Ist: %0d, Soll: %0d)", CMP,
                     soll);
            $finish;
        end

        A = -1;
        B = -3;
        S = 6'b010111;
        soll = 1;
        #10;
        if (CMP != soll) begin
            $display("Test 30 fehlgeschlagen: Greater equal falsch (Ist: %0d, Soll: %0d)", CMP,
                     soll);
            $finish;
        end

        A = -1;
        B = -3;
        S = 6'b111011;
        soll = 0;
        #10;
        if (CMP != soll) begin
            $display("Test 31 fehlgeschlagen: Less than (unsigned) falsch (Ist: %0d, Soll: %0d)",
                     CMP, soll);
            $finish;
        end

        A = 8;
        B = 9;
        S = 6'b011011;
        soll = 1;
        #10;
        if (CMP != soll) begin
            $display("Test 32 fehlgeschlagen: Less than (unsigned) falsch (Ist: %0d, Soll: %0d)",
                     CMP, soll);
            $finish;
        end

        A = 69;
        B = 69;
        S = 6'b011111;
        soll = 1;
        #10;
        if (CMP != soll) begin
            $display(
                "Test 33 fehlgeschlagen: Greater equal (unsigned) falsch (Ist: %0d, Soll: %0d)",
                CMP, soll);
            $finish;
        end

        A = 42;
        B = 69;
        S = 6'b111111;
        soll = 0;
        #10;
        if (CMP != soll) begin
            $display(
                "Test 34 fehlgeschlagen: Greater equal (unsigned) falsch (Ist: %0d, Soll: %0d)",
                CMP, soll);
            $finish;
        end

        $display("All alu-tests successful!");
        $finish;
    end
endmodule
