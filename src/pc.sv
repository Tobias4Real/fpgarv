`include "definitions.svh"

module pc #(
  parameter INIT_ADDR = `PC_INIT_ADDR
)  (
  input word jmp_addr,
  output word pc,
  input enable,
  input res,
  input clk,
  input mode
);

always @(posedge clk, posedge res)
begin
  if (res)
  begin
    pc <= INIT_ADDR;
  end else if(enable) begin
    if (mode == `PC_MODE_INCREMENT) begin
      pc <= pc + `INSTRUCTION_SIZE_IN_BYTES;
    end else if (mode == `PC_MODE_JUMP) begin
      pc <= jmp_addr;
    end
  end
end

endmodule
