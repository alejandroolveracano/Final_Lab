module wave_display_tb (

);

wave_display DUT(
    .clk(clk),
    .reset(reset),
    .x(x),  // [0..1279]
    .y(y),  // [0..1023]
    .valid(valid),
    .read_value(read_value),
    .read_index(read_index), //
    .read_address(read_address),
    .valid_pixel(valid_pixel),
    .r(r),
    .g(g),
    .b(b)
    
);
    
    
fake_sample_ram FSR_DUT(
    .clk(clk),
    .addr(addr),
    .dout(read_value)
);

    reg clk;
    reg reset;
    reg [10:0] x;  // [0..1279]
    reg [9:0]  y;  // [0..1023]
    reg valid;
    wire [7:0] read_value;
    reg read_index;
    wire [8:0] read_address;
    wire valid_pixel;
    wire [7:0] r;
    wire [7:0] g;
    wire [7:0] b;
    wire [7:0] dout;
    reg [8:0]addr;

// Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        addr = 9'd1000; //send some value to fake ram
        read_index = 0;
        valid = 0;
        x = 11'd0;
        y = 10'd0;
        #55
        

        
        //start in top left corner
        x = 11'd0;
        y = 10'd0;
        valid = 1'b1;
        
        //sweep x and y
        repeat(5)begin
        repeat (1023) begin
            repeat(1279) begin
                #10
                x = x + 11'd1;
                addr = addr + 9'd1;
            end
            #10
           x = 11'd0;
           y = y + 10'b1;
        end
      end
      end
endmodule