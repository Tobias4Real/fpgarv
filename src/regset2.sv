module regset(
    input wire [31:0]   write_data,
    input wire [4:0]	write_addr,
    input wire [4:0]	read1_addr,
    input wire [4:0]	read2_addr,
    input wire reset,
    input wire clk,
    input write_enable,
    
    output reg [31:0] read1_data,
    output reg [31:0] read2_data
 
);
reg [31:0] registers [31:1];

always @(posedge clk) begin
        //Reset logic
   if (write_enable==1'b1) begin
        if (write_addr != 5'b00000) begin
            registers[write_addr]<=write_data;
        end
    end
    

      
end
always @* begin
    //Read logic a
    
    read1_data=(read1_addr == 0) ? 0  : registers[read1_addr];
    read2_data=(read2_addr == 0) ? 0 : registers[read2_addr];
    
end
endmodule