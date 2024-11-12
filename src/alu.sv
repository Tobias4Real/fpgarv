// Arithmetic operations
`define ALU_S_ADDI 6'b?00000

// SUB is a special case of ADD without a immediate mode version. That's why there is extra handling required between ADD / ADDI.
`define ALU_S_ADD 6'b000001
`define ALU_S_SUB 6'b100001

// Comparison operations (Result stored in R_rd)
`define ALU_S_SLT 6'b00100
`define ALU_S_SLTU 6'b00110

// Logical operations
`define ALU_S_AND 6'b1110
`define ALU_S_OR 6'b1100
`define ALU_S_XOR 6'b1000

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
`define _RV32M_

module alu #(
    parameter logic EnableRv32M = 0
) (
    input [5:0] S,
    input [31:0] A,
    input [31:0] B,
    output reg CMP,
    output reg [31:0] Q
);
    wire ltu = $unsigned(A) < $unsigned(B);
    wire lt = $signed(A) < $signed(B);
    wire eq = A == B;
    always_comb begin
        Q   = 32'd0;
        CMP = 1'd0;

        // Logical operations
        unique0 case (S[4:1])
            `ALU_S_AND: Q = A & B;
            `ALU_S_OR:  Q = A | B;
            `ALU_S_XOR: Q = A ^ B;
            default;
        endcase

        unique0 case (S[5:1])
            // Shift operations

            `ALU_S_SLL: Q = A << B[4:0];
            `ALU_S_SRL: Q = A >> B[4:0];
            `ALU_S_SRA: Q = $signed(A) >>> B[4:0];

            // Comparison operations (Result stored in R_rd)
            `ALU_S_SLT:  Q = lt;
            `ALU_S_SLTU: Q = ltu;
            default;
        endcase

        unique0 case (S[4:0])
            // Compare operations (Result stored in CMP)
            `ALU_S_EQ:  CMP = eq;
            `ALU_S_NE:  CMP = !eq;
            `ALU_S_LT:  CMP = lt;
            `ALU_S_GE:  CMP = !lt;
            `ALU_S_LTU: CMP = ltu;
            `ALU_S_GEU: CMP = !ltu;
            default;
        endcase

        unique0 casez (S)
            // Arithmetic operations
            `ALU_S_ADD, `ALU_S_ADDI: Q = A + B;
            `ALU_S_SUB: Q = A - B;
            default;
        endcase
    end
endmodule
