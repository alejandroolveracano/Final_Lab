module wave_display_top(
    input clk,
    input reset,
    input new_sample,
    input [15:0] sample,
    input [10:0] x,  // [0..1279]
    input [9:0]  y,  // [0..1023]     
    input valid,
    input vsync,
    input [1:0] state,  // from music_player
    input [5:0] prev_note,  // The previous note played (for note display module)
    input [5:0] note,       // The current note being played (for note
    input next_display, //added next_display that is suppose to be the button input to change display types
    output [7:0] r,
    output [7:0] g,
    output [7:0] b
);

    wire [7:0] read_sample, write_sample;
    wire [8:0] read_address, write_address;
    wire read_index;
    wire write_en;
    wire wave_display_idle = ~vsync;

    wave_capture wc(
        .clk(clk),
        .reset(reset),
        .new_sample_ready(new_sample),
        .new_sample_in(sample),
        .write_address(write_address),
        .write_enable(write_en),
        .write_sample(write_sample),
        .wave_display_idle(wave_display_idle),
        .read_index(read_index)
    );
    
    ram_1w2r #(.WIDTH(8), .DEPTH(9)) sample_ram(
        .clka(clk),
        .clkb(clk),
        .wea(write_en),
        .addra(write_address),
        .dina(write_sample),
        .douta(),
        .addrb(read_address),
        .doutb(read_sample)
    );
 
    wire valid_pixel;
    wire wave_valid;
    wire [7:0] wd_r, wd_g, wd_b;
    wave_display wd(
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .valid(valid),
        .read_address(read_address),
        .read_value(read_sample),
        .read_index(read_index),
        .next_display(next_display),
        .valid_pixel(wave_valid),
        .r(wd_r), .g(wd_g), .b(wd_b)
    );

    wire state_valid;
    wire [7:0] r_state, g_state, b_state;
    state_symbol state_sym(
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .state(state),
        .vga_x(x),
        .vga_y(y),
        .r(r_state),
        .g(g_state),
        .b(b_state),
        .valid_px(state_valid)
    );

    // note player 1 current note display
    wire np1_cn_valid;
    wire [7:0] r_np1_cn, g_np1_cn, b_np1_cn;
    note_display np1_curr_note(
        .clk(clk),
        .reset(reset),
        .note(prev_note),
        .num_x(11'd100),  // shift right by 100 pixels
        .num_y(10'd480),
        .letter_x(11'd108),
        .letter_y(10'd480),
        .symbol_x(11'd116),
        .symbol_y(10'd480),
        .vga_x(x),  // shift left by 100 pixels
        .vga_y(y),
        .valid(valid),
        .color(24'hFFFFFF),  // white color
        .r(r_np1_cn),
        .g(g_np1_cn),
        .b(b_np1_cn),
        .valid_px(np1_cn_valid)
    );

    // note player 1 previous note display
    wire np1_pn_valid;
    wire [7:0] r_np1_pn, g_np1_pn, b_np1_pn;
    note_display np1_prev_note(
        .clk(clk),
        .reset(reset),
        .note(prev_note),
        .num_x(11'd124),  // shift right by 100 pixels
        .num_y(10'd480),
        .letter_x(11'd132),
        .letter_y(10'd480),
        .symbol_x(11'd140),
        .symbol_y(10'd480),
        .vga_x(x),  // shift left by 100 pixels
        .vga_y(y),
        .valid(valid),
        .color(24'hFFFFFF),  // white color
        .r(r_np1_pn),
        .g(g_np1_pn),
        .b(b_np1_pn),
        .valid_px(np1_pn_valid)
    );

    // combine wave and state display
    assign valid_pixel = wave_valid | state_valid | np1_cn_valid | np1_pn_valid;

    // prioritzes white waveform
    assign {r, g, b} = valid_pixel ? {wd_r, wd_g, wd_b} | 
                                     {r_state, g_state, b_state} | 
                                     {r_np1_cn, g_np1_cn, b_np1_cn} | 
                                     {r_np1_pn, g_np1_pn, b_np1_pn} : 
                                     {3{8'b0}};
endmodule
