module note_player(
    input clk,
    input reset,
    input play_enable,  // When high we play, when low we don't.
    input [5:0] note_to_load,  // The note to play
    input [5:0] duration_to_load,  // The duration of the note to play
    input load_new_note,  // Tells us when we have a new note to load
    output done_with_note,  // When we are done with the note this stays high.
    input beat,  // This is our 1/48th second beat
    input generate_next_sample,  // Tells us when the codec wants a new sample
    output [15:0] sample_out,  // Our sample output
    output new_sample_ready  // Tells the codec when we've got a sample
    output [5:0] prev_note  // The previous note played (for note display module)****************
    output [5:0] note  // The current note being played (for note display module)
);

    // Implementation goes here!
    
    //beat_generator bg (.clk(), .reset(), .en(), .beat()); INSTANTIATE THIS IN HIGHER MODULE
    
    // duration registers
    wire [5:0] duration;
    wire [5:0] next_duration;
    wire duration_en = (beat | load_new_note) & play_enable;    // logic for duration enable                                                            
    dffre #(6) duration_reg (.clk(clk), .r(reset), .en(duration_en), .d(next_duration), .q(duration));
    
    // note registers
    wire [5:0] note;
    wire [5:0] next_note;
    dffr #(6) note_reg (.clk(clk), .r(reset), .d(next_note), .q(note));

    wire [5:0] prev_note;
    dffr #(6) display_note_reg (.clk(clk), .r(reset), .d(note), .q(prev_note));     // added for note display module
    
    assign done_with_note = (duration == 6'd0) & beat;
    
    // note mux
    wire note_sel = load_new_note;
    assign next_note = (note_sel) ? note_to_load : note;
    
    // duration mux
    wire duration_sel = (load_new_note | reset | done_with_note);
    assign next_duration = (duration_sel) ? duration_to_load : (duration - 6'd1);
    
    
    // Frequency ROM
    wire [19:0] step_size;
    frequency_rom f_rom (.clk(clk), .addr(note), .dout(step_size));
    
    wire [15:0] sine_reader_out;
    
    // Sine Reader
    sine_reader sr (
        .clk(clk), 
        .reset(reset), 
        .step_size(step_size), 
        .generate_next(generate_next_sample), 
        .sample_ready(new_sample_ready), 
        .sample(sine_reader_out));
    assign sample_out = play_enable ? sine_reader_out : 16'd0;
endmodule