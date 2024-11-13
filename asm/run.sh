mkdir -p out
riscv64-linux-gnu-as -o out/test.o test.asm && riscv64-linux-gnu-ld -o out/test out/test.o && qemu-riscv64-static -d in_asm,cpu -D out/qemu.log out/test
riscv64-linux-gnu-objdump -D out/test > out/test_disassembly.txt
