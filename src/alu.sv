`include "definitions.svh"

// Arithmetic operations
`define ALU_S_ADDI 6'b?00000

// SUB is a special case of ADD without a immediate mode version. That's why there is extra handling required between ADD / ADDI.
`define ALU_S_ADD 6'b000001
`define ALU_S_SUB 6'b100001

// Comparison operations (Result stored in R_rd)
`define ALU_S_SLT 4'b0100
`define ALU_S_SLTU 4'b0110

// Logical operations
`define ALU_S_AND 4'b1110
`define ALU_S_OR 4'b1100
`define ALU_S_XOR 4'b1000

// Shift operations
`define ALU_S_SLL 6'b00010
`define ALU_S_SRL 6'b01010
`define ALU_S_SRA 6'b11010

// Compare operations (Result stored in CMP)
`define ALU_S_EQ 6'b00011
`define ALU_S_NE 6'b00111
`define ALU_S_LT 6'b10011
`define ALU_S_GE 6'b10111
`define ALU_S_LTU 6'b11011
`define ALU_S_GEU 6'b11111

`define _RV32M_ALU_S_ 000001

module alu #(
    parameter logic EnableRv32M = 0
) (
    input [5:0] ctrl,
    input word a,
    input word b,
    output reg cmp,
    output word result
);
    wire ltu = $unsigned(a) < $unsigned(b);
    wire lt = $signed(a) < $signed(b);
    wire eq = a == b;
    always_comb begin
        result = 32'd0;
        cmp = 1'd0;

        // Logical operations / SLT(U)
        unique0 case (ctrl[4:1])
            `ALU_S_AND: result = a & b;
            `ALU_S_OR:  result = a | b;
            `ALU_S_XOR: result = a ^ b;

            `ALU_S_SLT:  result = lt;
            `ALU_S_SLTU: result = ltu;

            default;
        endcase

        unique0 case (ctrl[5:1])
            // Shift operations

            `ALU_S_SLL: result = a << b[4:0];
            `ALU_S_SRL: result = a >> b[4:0];
            `ALU_S_SRA: result = $signed(a) >>> b[4:0];
            default;
        endcase

        unique0 case (ctrl[4:0])
            // Compare operations (Result stored in CMP)
            `ALU_S_EQ:  cmp = eq;
            `ALU_S_NE:  cmp = !eq;
            `ALU_S_LT:  cmp = lt;
            `ALU_S_GE:  cmp = !lt;
            `ALU_S_LTU: cmp = ltu;
            `ALU_S_GEU: cmp = !ltu;
            default;
        endcase

        unique0 casez (ctrl)
            // Arithmetic operations
            `ALU_S_ADD, `ALU_S_ADDI: result = a + b;
            `ALU_S_SUB: result = a - b;
            default;
        endcase

    end
endmodule
