`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------   
    Module Name: char_pixel

    Description: This module validates character pixels to be displayed. This acts 
    as a helper module for state_symbol.v and note_display.v

    Dependencies: tcgrom (ROM with characters)

----------------------------------------------------------------------------------
*/

module char_pixel(
    input clk,
    input reset,
    input [8:0] init_addr,
    input [10:0] vga_x,
    input [9:0] vga_y,
    input [10:0] char_x,
    input [9:0] char_y,
    input [23:0] color,
    input valid,
    output [7:0] r,
    output [7:0] g,
    output [7:0] b,
    output valid_px
    );
    



wire x_valid = (vga_x[9:8] == 2'b01) | (vga_x[9:8] == 2'b10); // verifies in correct quadrant
wire y_valid = ~vga_y[10];                                    // within range of y-direction

// boundary check for characters in x and y direction
wire x_bound = (vga_x >= char_x) & (vga_x <= (char_x + 11'd8));
wire y_bound = (vga_y >= char_y) & (vga_y <= (char_y + 11'd8));

// address registers (first addr of char groups in tcgrom)
wire [8:0] addr;
wire [8:0] next_addr;
wire addr_en = y_bound & (vga_x[2:0] == 3'd7); // vga_x or char_x???
dffre #(9) addr_reg(.clk(clk), .r(reset), .en(addr_en), .d(next_addr), .q(addr));

// checks within range of character address in tcgrom
wire addr_range = (init_addr <= addr) & (addr <= (init_addr + 9'd8));

// increments through char addr in tcgrom
assign next_addr = addr_range ? addr + 1 : init_addr;

// extract data from tcgrom based on addr
wire [7:0] data;
tcgrom char_rom (.addr(addr), .data(data));

// bit selects parts of the row of data, depending on vga_x
wire bit_select = 8'b1000_0000 >> vga_x[2:0];
wire add_pixel = |(data & bit_select);

// checks if pixel is valid
assign valid_px = (x_bound &
                   y_bound &
                   x_valid &
                   y_valid &
                   valid &
                   add_pixel);

// chooses color based on if pixel is valid, black as default
assign {r,g,b} = valid_px ? color : 24'h000000;

    
endmodule
