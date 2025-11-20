`timescale 1ns / 1ps
module char_pixel_tb();
reg clk, reset, valid;
reg [23:0] color;
reg [10:0] vga_x;
reg [9:0] vga_y;
reg [10:0] char_x;
reg [9:0] char_y;
wire [7:0] r;
wire [7:0] g;
wire [7:0] b;
wire valid_px;

char_pixel dut(
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .color(color),
    .vga_x(vga_x),
    .vga_y(vga_y),
    .char_x(char_x),
    .char_y(char_y),
    .r(r),
    .g(g),
    .b(b),
    .valid_px(valid_px)
);

initial forever begin
    #5
    clk = 1'b1; //Set clock cycle to alternate every 5ns
    #5
    clk = 1'b0;
    
end

initial begin

end

endmodule
