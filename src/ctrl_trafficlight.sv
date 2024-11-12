module ctrl_trafficlight (
    output reg [2:0] rgb,
    output reg cntr_reset,
    input btn,
    input tick,
    input res,
    input clk
);
    reg [1:0] state;
    reg button_registered;

    always_comb begin
        unique case (state)
            0: rgb = 3'b100;
            1: rgb = 3'b110;
            2: rgb = 3'b010;
            3: rgb = 3'b110;
        endcase
    end

    always @(posedge clk) begin
        if (res == 1) begin
            state <= 0;
            cntr_reset <= 1;
            button_registered <= 0;
        end else if (btn) begin
            button_registered <= 1;
            cntr_reset <= 1;
        end else if (tick && !cntr_reset) begin
            if (state != 0 || button_registered) begin
                state <= state + 1;
                button_registered <= 0;
            end
            cntr_reset <= 1;
        end else begin
            cntr_reset <= 0;
        end
    end
endmodule
