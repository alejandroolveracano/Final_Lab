`define PAUSE 2'b00
`define PLAY  2'b01
`define WAIT_FOR_SONG_ROM 2'b10
`define OUTPUT 2'b11

module song_reader(
    input clk,
    input reset,
    input play,
    input [1:0] song,
    input note_done,
    output song_done,
    output [5:0] note,
    output [5:0] duration,
    output new_note
);


wire [5:0] curr_note;
reg [5:0] next_note;
wire [1:0] state;
reg  [1:0] next_state;

 //It's one bit longer than needed for song_rom, we'll trim later (makes song_done logic simpler)
dffr #(6) note_tracker(.d(next_note), .q(curr_note), .r(reset), .clk(clk));
dffr #(2) state_tracker(.d(next_state), .q(state), .r(reset), .clk(clk));

wire [6:0] addr = {song, curr_note[4:0]}; //We trim off the MSB since that was just to help song_done case
wire [11:0] rom_out;
    
song_rom rom(.clk(clk), .addr(addr), .dout(rom_out));

assign song_done = curr_note == 6'd32; //Should this be high even when song is paused

wire unpulsed_new_note = (state == `OUTPUT); //Only reason new_note should be high is that we are in output state
one_pulse new_note_pulse(.clk(clk), .reset(reset), .in(unpulsed_new_note), .out(new_note));


assign note = rom_out[11:6];
assign duration = rom_out[5:0];

always @(*) begin
    case(state)
        `PAUSE: begin
                    next_state = play ? `PLAY : `PAUSE;
                    next_note = curr_note;
                end
        `PLAY: begin
                next_state = (play && (curr_note != 6'd32)) ? `WAIT_FOR_SONG_ROM : `PAUSE;
                next_note = curr_note;
            end
        `WAIT_FOR_SONG_ROM: begin
                            next_state = (play) ? `OUTPUT : `PAUSE;
                            next_note = curr_note;
                        end
        `OUTPUT: begin
                    next_state = (play && note_done) ? `PLAY : `OUTPUT;
                    next_note = note_done ? curr_note + 1 : curr_note;
                 end
         default: begin
            next_state = `PAUSE;
         end
    endcase
end


endmodule