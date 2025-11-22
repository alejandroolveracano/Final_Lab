/*------------------------------------------------------------------------
--+ Module Name: note_display
--+ Description: This module displays the current note being played
--+              on the VGA display. It uses the char_pixel module to
--+              render the note character.
--+ Dependencies: char_pixel.v, tcgrom.v
--+------------------------------------------------------------------------*/    

module note_display(
    input clk,
    input reset,
    input [5:0] note,        // note to be displayed
    input [10:0] num_x,      // x coordinate for note display
    input [9:0] num_y,       // y coordinate for note display
    input [10:0] letter_x,   // x coordinate for letter display
    input [9:0] letter_y,    // y coordinate for letter display
    input [10:0] symbol_x,   // x coordinate for symbol display
    input [9:0] symbol_y,    // y coordinate for symbol display
    input [10:0] vga_x,
    input [9:0] vga_y,
    input valid,
    input [23:0] color,     // color for the note character
    output [7:0] r,
    output [7:0] g,
    output [7:0] b,
    output valid_px

);

wire [8:0] num_addr;
wire [8:0] letter_addr;
wire [8:0] symbol_addr;

note_rom note_rom_inst(
    .note(note),
    .num_addr(num_addr),
    .letter_addr(letter_addr),
    .symbol_addr(symbol_addr)
);

wire num_pixel_valid;
wire [7:0] r_num, g_num, b_num;
char_pixel num_char_pixel(
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .init_addr(num_addr),
    .color(color),
    .vga_x(vga_x),
    .vga_y(vga_y),
    .is_state(1'b0),
    .char_x(num_x),
    .char_y(num_y),
    .r(r_num),
    .g(g_num),
    .b(b_num),
    .valid_px(num_pixel_valid)
);

wire letter_pixel_valid;
wire [7:0] r_letter, g_letter, b_letter;
char_pixel letter_char_pixel(
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .init_addr(letter_addr),
    .color(color),
    .vga_x(vga_x),
    .vga_y(vga_y),
    .is_state(1'b0),
    .char_x(letter_x),
    .char_y(letter_y),
    .r(r_letter),
    .g(g_letter),
    .b(b_letter),
    .valid_px(letter_pixel_valid)
);

wire symbol_pixel_valid;
wire [7:0] r_symbol, g_symbol, b_symbol;
char_pixel symbol_char_pixel(
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .init_addr(symbol_addr),
    .color(color),
    .vga_x(vga_x),
    .vga_y(vga_y),
    .is_state(1'b0),
    .char_x(symbol_x),
    .char_y(symbol_y),
    .r(r_symbol),
    .g(g_symbol),
    .b(b_symbol),
    .valid_px(symbol_pixel_valid)
);

assign valid_px = num_pixel_valid | letter_pixel_valid | symbol_pixel_valid;

assign {r, g, b} = valid_px ? {r_num, g_num, b_num} |
                              {r_letter, g_letter, b_letter} |
                              {r_symbol, g_symbol, b_symbol} :
                              24'b0;

endmodule
