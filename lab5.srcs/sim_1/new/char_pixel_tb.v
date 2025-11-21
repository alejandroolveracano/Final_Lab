`timescale 1ns / 1ps
module char_pixel_tb();
reg clk, reset, valid;
reg [8:0] init_addr;
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

/*
This testbench will check the character pixel module by simulating a VGA signal
scanning across a defined character area. The character is positioned at (800, 400) on the VGA display.
The testbench will iterate through a range of VGA coordinates that cover the character
and verify if the pixel output is valid and correctly colored based on the character ROM data.
*/
initial begin
    vga_x = 11'd0;
    vga_y = 10'd0;
    char_x = 11'd800;   // should bound 800 <= x <= 808
    char_y = 10'd400;   // should bound 400 <= y <= 408
    color = 24'hFFFFFF; // white
    init_addr = 9'h000;   // This is the letter 'e' in the tcgrom
    valid = 1'b1;
    reset = 1'b1;
    #15
    reset = 1'b0;
    vga_x = 11'd790; // start just before the character
    vga_y = 10'd399; // start just before the character

    integer i;
    for (i = 0; i < 200000; i = i + 1) begin
        #10;
        vga_x = vga_x + 1;

        if (vga_x == 11'820) begin    // stopping this early for sake of simulation time
            vga_x = 11'd790;
            vga_y = vga_y + 1;
            if (vga_y == 10'420) begin
                vga_y = 10'd399;
            end
end

endmodule
