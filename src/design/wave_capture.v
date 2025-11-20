`define ARMED 2'b00
`define ACTIVE  2'b01
`define WAIT 2'b10

module wave_capture (
    input clk,
    input reset,
    input new_sample_ready,
    input [15:0] new_sample_in,
    input wave_display_idle,

    output wire [8:0] write_address,
    output wire write_enable,
    output wire [7:0] write_sample,
    output wire read_index
);

//Global State Tracking
wire [1:0] state;
reg [1:0] next_state;

//Controls movement through the FSM
wire move_to_active, move_to_wait;

dffr #(2) global_state(.d(next_state), .q(state), .r(reset), .clk(clk));

//READ_INDEX LOGIC
wire next_read_index = !read_index;

//Only flip read_index if wave_display_idle and our current state is WAIT
dffre #(1) index_tracker(.d(next_read_index), .q(read_index), .en(wave_display_idle && state == `WAIT), .r(reset), .clk(clk));


//ARMED STATE

//Isolate the MSB for positive crossing check
wire curr_sample;
wire next_sample = new_sample_in[15];

dffr #(1) positive_crossing(.d(next_sample), .q(curr_sample), .clk(clk), .r(reset));

//Only move to armed if the MSB goes from 1 to 0 (negative to positive)
assign move_to_active = curr_sample == 1'b1 && next_sample == 1'b0;


//ACTIVE STATE
wire [7:0] curr_count;
reg [7:0] next_count;

//Implementing counter
dffre #(8) counter(.d(next_count), .q(curr_count), .r(reset), .clk(clk), .en(new_sample_ready));

assign move_to_wait = curr_count == 8'd255;

always @(*) begin
    case(state)
        `ARMED: begin //By default, counter's value should be zero unless in ACTIVE state
            next_count = 8'b0;
            next_state = move_to_active ? `ACTIVE : `ARMED;
         end
        `ACTIVE: begin
            next_count = curr_count + 1'b1; //Only increment counter in ACTIVE state as we are writing to RAM
            next_state = move_to_wait ? `WAIT : `ACTIVE;
         end
        `WAIT: begin
            next_count = 8'b0;
            next_state = wave_display_idle ? `ARMED : `WAIT;
        end
        default: begin
             next_count = 8'b0;
             next_state = `ARMED;
        end
    endcase
end

//OUTPUT LOGIC
assign write_address = {!read_index, curr_count};
assign write_enable = new_sample_ready && (state == `ACTIVE);

//Doubts, check this!
assign write_sample = new_sample_in[15:8] + 8'd128; //Offset all negative numbers, brings range to 0 - 255

endmodule