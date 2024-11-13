.section .text
.globl _start

success_msg:
    .ascii "Success: All tests passed!\n"

error_msg:
    .ascii "Error: Tests failed\n"

success:
    # Print a success message

    # stdout file descriptor
    addi x10, x0, 1
    la x11, success_msg

    # Error message length
    addi x12, x0, 27

    # Syscall number for write
    addi x17, x0, 64
    ecall
    j end

fail:
    addi x16, x0, 69
    # Print an error message

    # stdout file descriptor
    addi x10, x0, 1
    la x11, error_msg

    # Error message length
    addi x12, x0, 20

    # Syscall for write
    addi x17, x0, 64
    ecall
    j end

_start:
    j main

main:
    addi x1, x0, 10

    #expect: x1 = 10
    addi x16, x1, -10
    bne x16, x0, fail

    addi x2, x0, 20

    #expect: x2 = 20
    addi x16, x2, -20
    bne x16, x0, fail

    add x3, x1, x2

    #expect: x3 = 30
    addi x16, x3, -30
    bne x16, x0, fail

    slti x4, x3, 31

    #expect: x4 = 1
    addi x16, x4, -1
    bne x16, x0, fail

    sltiu x4, x4, -1

    #expect: x4 = 1
    addi x16, x4, -1
    bne x16, x0, fail

    xori x3, x3, 30

    #expect: x3 = 0
    bne x3, x0, fail

    ori x4, x0, 42

    #expect: x4 = 42
    addi x16, x4, -42
    bne x16, x0, fail

    andi x5, x4, 2

    #expect: x5 = 2
    addi x16, x5, -2
    bne x16, x0, fail

    slli x5, x5, 2

    #expect: x5 = 8
    addi x16, x5, -8
    bne x16, x0, fail

    srli x6, x4, 1

    #expect: x6 = 21
    addi x16, x6, -21
    bne x16, x0, fail

    addi x7, x0, -69

    #expect: x7 = -69
    addi x16, x7, 69
    bne x16, x0, fail

    srai x7, x7, 1

    #expect: x7 = -35
    addi x16, x7, 35
    bne x16, x0, fail

    sub x8, x0, x7
    #expect: x8 = 35
    addi x16, x8, -35
    bne x16, x0, fail

    sub x7, x7, x8

    #expect: x7 = -70
    addi x16, x7, 70
    bne x16, x0, fail

    addi x3, x0, 33

    #expect: x3 = 33
    addi x16, x3, -33
    bne x16, x0, fail

    addi x3, x0, 1
    sll x7, x7, x3

    #expect: x7 = -140
    addi x16, x7, 140
    bne x16, x0, fail

    slt x1, x7, x7

    #expect: x1 = 0
    bne x1, x0, fail

    sltu x1, x7, x3

    #expect: x1 = 0
    bne x1, x0, fail

    xor x6, x7, x1

    #expect: x6 = -140
    addi x16, x6, 140
    bne x16, x0, fail

    srl x1, x1, x3

    #expect: x1 = 0
    bne x1, x0, fail

    sra x7, x7, x3

    #expect: x7 = -70
    addi x16, x7, 70
    bne x16, x0, fail

    or x7, x0, x0

    #expect: x7 = 0
    bne x7, x0, fail

    and x6, x6, x0

    #expect: x6 = 0
    bne x6, x0, fail

    lui x1, 42
    srli x1, x1, 9

    #expect: x1 = 336
    addi x16, x1, -336
    bne x16, x0, fail

    auipc x1, 42
    auipc x2, 0
    addi x2, x2, -4
    sub x1, x1, x2
    srli x1, x1, 12

    #expect: x1 = 42
    addi x16, x1, -42
    bne x16, x0, fail

    j success
end:
    # Exit the program

    # Exit code 0
    addi x10, x0, 0

    # Syscall number for exit
    addi x17, x0, 93
    ecall
