riscv64-linux-gnu-as -o test.o test.asm && riscv64-linux-gnu-ld -o test test.o && qemu-riscv64-static -d in_asm,cpu -D qemu.log test
