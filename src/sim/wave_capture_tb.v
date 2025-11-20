module wave_capture_tb();
reg clk, reset, new_sample_ready, wave_display_idle;
reg [15:0] new_sample_in;

wire write_enable, read_index;
wire [8:0] write_address;
wire [7:0] write_sample;


wave_capture dut(.clk(clk), 
                 .new_sample_ready(new_sample_ready), 
                 .reset(reset),
                 .wave_display_idle(wave_display_idle),
                 .new_sample_in(new_sample_in),
                 .write_enable(write_enable),
                 .read_index(read_index),
                 .write_address(write_address),
                 .write_sample(write_sample));
                 
initial forever begin
    #5
    clk = 1'b1; //Set clock cycle to alternate every 5ns
    #5
    clk = 1'b0;
    
end

initial begin
    //Initial setup
    reset = 1'b1;
    new_sample_ready = 1'b0;
    wave_display_idle = 1'b0;
    new_sample_in = 16'b1111111111111011; //-5 in binary
    #20
    
    reset = 1'b0;
    
    //Check what happens if sample is various negative values
    repeat (4) begin
        #10
        new_sample_in = new_sample_in + 1'b1;
        new_sample_ready = 1'b1;
        #10
        new_sample_ready = 1'b0;
    end
    
    //Try sending samples immediately after the new samples ready
    new_sample_in = 16'b0;
    new_sample_ready = 1'b1;
    #10
    new_sample_ready = 1'b0;
     
    //Test basic outputs
    repeat(255) begin
        #10
        new_sample_in = {new_sample_in[15:8] + 1'b1, 8'b0};
        #10
        new_sample_ready = 1'b1;
        #10 //One pulse new_sample_in
        new_sample_ready = 1'b0;
    end
    
    #20 //Wait for a bit, see if it chills in wait state
    
    wave_display_idle = 1'b1;
    #10
    wave_display_idle = 1'b0;
    
    #100 //Check on armed state
    
    
    //Check if we can write to oppostite read_index now
    new_sample_in = 16'b1111111111111011; //-5 in binary
    #20
    
    //See if we get similar results writing to the opposite read_index
    repeat (4) begin
        #10
        new_sample_in = new_sample_in + 1'b1;
        new_sample_ready = 1'b1;
        #10
        new_sample_ready = 1'b0;
    end
    
    new_sample_in = 16'b0;
    new_sample_ready = 1'b1;
    #10
    new_sample_ready = 1'b0;
    
     //Test basic outputs
    repeat(255) begin
        #10
        new_sample_in = {new_sample_in[15:8] + 1'b1, 8'b0};
        #10
        new_sample_ready = 1'b1;
        #10 //One pulse new_sample_in
        new_sample_ready = 1'b0;
    end
    
end
endmodule