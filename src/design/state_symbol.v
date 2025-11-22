/*----------------------------------------------------------------------------------
    Module Name: state_symbol

    Description: This module outputs an 8-bit symbol corresponding to the current
    state of the music player. This symbol can be used for display purposes.

    Dependencies: None
----------------------------------------------------------------------------------*/
`define PAUSE_STATE  2'b00      // state definitions from mcu.v
`define PLAY_STATE   2'b01
`define CHANGE_STATE 2'b10

`define PAUSE_ADDR   9'h008     // addresses found in tcgrom for symbols
`define PLAY_ADDR    9'h000
`define CHANGE_ADDR  9'h010

`define CHAR_X_COORD 11'd400    // x coordinate for symbol display
`define CHAR_Y_COORD 10'd200    // y coordinate for symbol display

module state_symbol(
    input clk,
    input reset,
    input valid,
    input [1:0] state,
    input [10:0] vga_x,
    input [9:0] vga_y,
    output [7:0] r,
    output [7:0] g,
    output [7:0] b,
    output valid_px
);

reg [8:0] state_addr;

always @(*) begin
    case(state)
        `PAUSE_STATE: begin
            state_addr = `PAUSE_ADDR;
        end
        `PLAY_STATE: begin
            state_addr = `PLAY_ADDR;
        end
        `CHANGE_STATE: begin
            state_addr = `CHANGE_ADDR;
        end
        default: begin
            state_addr = `PAUSE_ADDR;
        end
    endcase
end

char_pixel state_char_pixel(
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .init_addr(state_addr),
    .color(24'h00FFFF), // cyan color for symbol
    .vga_x(vga_x),
    .vga_y(vga_y),
    .is_state(1'b1),
    .char_x(`CHAR_X_COORD),
    .char_y(`CHAR_Y_COORD),
    .r(r),
    .g(g),
    .b(b),
    .valid_px(valid_px)
);

endmodule
