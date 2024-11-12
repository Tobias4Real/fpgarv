module trafficlight (
    output [2:0] rgb,
    input btn,
    input resn,
    input clk
);

    wire tk_tick;
    wire tk_res;
    reg  ctl_res;

    timekeeper #(
        .Wait(8)
    ) tk (
        .clk (clk),
        .tick(tk_tick),
        .res (tk_res)
    );

    ctrl_trafficlight ctl (
        .rgb(rgb),
        .cntr_reset(tk_res),
        .btn(btn),
        .tick(tk_tick),
        .res(!resn),
        .clk(clk)
    );

endmodule
