`define PAUSE_STATE  2'b00
`define PLAY_STATE   2'b01
`define CHANGE_STATE 2'b10

module mcu(
    input clk,
    input reset,
    input play_button,
    input next_button,
    output play,
    output reset_player,
    output [1:0] song,
    input song_done
);
    
    // state registers
    wire [1:0] state;
    reg [1:0] next_state;
    dffr #(2) state_reg(.clk(clk), .r(reset), .d(next_state), .q(state));

    // song registers
    wire [1:0] curr_song;   // just use song?
    reg [1:0] next_song;
    dffr #(2) song_reg(.clk(clk), .r(reset), .d(next_song), .q(curr_song));
    
    
    // NOTE: talk to unesco about resetting
    always @(*) begin
        case(state)
            `PAUSE_STATE: begin
                next_state = (play_button) ? `PLAY_STATE :
                             (next_button) ? `CHANGE_STATE :
                             state;
                next_song = curr_song;
            end
            `PLAY_STATE: begin
                next_state = (play_button) ? `PAUSE_STATE :
                             (next_button | song_done) ? `CHANGE_STATE :
                             state;
                next_song = curr_song;
            end
            `CHANGE_STATE: begin
                next_song = (curr_song + 2'd1);     // 3 songs + our song (Do we need to wrap with 4 songs???)
                next_state = `PAUSE_STATE;
            end
            default: begin
                next_state = `PAUSE_STATE;
                next_song = curr_song;
            end
        endcase
    end
    
    // reset_player = 1 only when in change state
    assign reset_player = (state ==  `CHANGE_STATE) ? 1'b1 : 1'b0;
    
    // play = 1 only when in play state
    assign play = (state == `PLAY_STATE) ? 1'b1 : 1'b0;
   
    assign song = curr_song;
    
endmodule