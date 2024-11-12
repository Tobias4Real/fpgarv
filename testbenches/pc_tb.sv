`include "definitions.svh"

module pc_tb();
  word jmp_addr;
  word pc;
  reg enable;
  reg res;
  reg clk;
  reg mode;

  pc #(
    .INIT_ADDR(`PC_INIT_ADDR)
  ) dut(.*);

  word pc_exp;
  word tmp;

  always #5 clk =~ clk;

  initial begin
    //Doesn't work with iverilog for some reason!
    //$srandom (42);

    enable = 0; clk = 0; jmp_addr = 0; mode = `PC_MODE_INCREMENT;
    // First test: Test whether reset works (with enable = 0)
    res = 1;
    @(negedge clk);
    res = 0;
    pc_exp = `PC_INIT_ADDR;
    if (pc !== pc_exp)
    begin
      $display("Test #1 (pc reset) failed! Value of pc = %0d != expected %0d", pc, pc_exp);
      $finish;
    end
    // --- End test ---
    // Second test: Test whether increment works
    clk = 0; enable = 1;
    pc_exp = `PC_INIT_ADDR;

    for (integer i = 0; i < 37; i++) begin
      pc_exp += `INSTRUCTION_SIZE_IN_BYTES;
      @(negedge clk);
    end
    
    if (pc !== pc_exp) begin
      $display("Test #2 (pc increment) failed! Value of pc = %0d != expected %0d", pc, pc_exp);
      $finish;
    end
    // --- End test ---
    // Third Test: Test whether there really is no increment when enable = 0.
    clk = 0; enable = 0;

    for (integer i = 0; i < 37; i++) begin
      @(negedge clk);
    end
    
    if (pc !== pc_exp) begin
      $display("Test #3 (pc disabled) failed! Value of pc = %0d != expected %0d", pc, pc_exp);
      $finish;
    end

    // --- End test ---
    // Forth Test: Test whether jump works.
    clk = 0; enable = 1; mode = `PC_MODE_JUMP;
    jmp_addr = $urandom;
    pc_exp = jmp_addr;
    
    @(negedge clk);
    mode = `PC_MODE_INCREMENT;
        
    if (pc !== pc_exp) begin
      $display("Test #4 (jump) failed! Value of pc = %0d != expected %0d", pc, pc_exp);
      $finish;
    end
    // --- End test ---
    // Fifth Test: Increment after jump.
    pc_exp += `INSTRUCTION_SIZE_IN_BYTES;
    @(negedge clk);
    
    if (pc !== pc_exp) begin
      $display("Test #5 (increment after jump) failed! Value of pc = %0d != expected %0d", pc, pc_exp);
      $finish;
    end
    
    // Sixth Test: Test whether jumps are executed despite enable = 0.
    clk = 0; enable = 0; mode = `PC_MODE_JUMP;
    jmp_addr = $urandom;
      
    @(negedge clk);

    if (pc !== pc_exp) begin
      $display("Test #6 (jump while disabled) failed! Value of pc = %0d != expected %0d", pc, pc_exp);
      $finish;
    end


    $display("All pc-tests passed with flying colors!");
    $finish;
  end

endmodule;
