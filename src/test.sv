module test (
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] O,
    input wire sub
);

    always_comb begin
        if (sub) begin
            O = A + B;
        end else begin
            O = A - B;
        end
    end

endmodule
