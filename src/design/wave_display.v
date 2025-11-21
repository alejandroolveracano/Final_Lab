`define NORMAL 3'b000
`define HALF 3'b001
`define QUARTER 3'b010
`define HEIGHTMAX 3'b011
`define WIDTHMAX 3'b100

module wave_display (
    input clk,
    input reset,
    input [10:0] x,  // [0..1279]
    input [9:0]  y,  // [0..1023]
    input valid,
    input [7:0] read_value,
    input read_index,
    input next_display,
    output wire [8:0] read_address,
    output wire valid_pixel,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);
    //adjusted read_value to fit in newer screen
    reg [7:0]read_value_adjusted;

    assign read_address = {read_index, x[9], x[7:1]};
    
    // address flip flops
    wire [8:0] next_addr = read_address;
    wire [8:0] prev_addr;
    wire addr_en = (next_addr != prev_addr);
    dffr #(9) address_ff (.clk(clk), .r(reset), .d(next_addr), .q(prev_addr));
    
    // value flip flops
    wire [7:0] prev_val;
    dffre #(8) value_ff (.clk(clk), .r(reset), .en(next_addr != prev_addr), .d(read_value_adjusted), .q(prev_val)); 

    //validate that the x and y position can have a valid pixel
    wire x_valid = ((x[9:8] == 2'b01) | (x[9:8] == 2'b10) | (state == `WIDTHMAX)); 
    wire y_valid = ~y[9];
    
    //bound_valid is what is making sure that the y value is withing the range
    //to display a pixel
    wire bound_valid = ((y[8:1] >= prev_val) & (y[8:1] <= read_value_adjusted)) | 
                       ((y[8:1] <= prev_val) & (y[8:1] >= read_value_adjusted)); 
    
    //this logic is to cutoff the vertical bars
    wire left_valid = (state==`WIDTHMAX)? 1'b1: (x >= 11'b00100000010);
    wire right_valid = (state==`WIDTHMAX)? 1'b1: (x <= 11'b01011111100);

    //is the combination of all the checks to ensure a the display will display the sin wave              
    assign valid_pixel = x_valid & y_valid & bound_valid & valid &
                         (left_valid ) & (right_valid );
                         
    assign {r, g, b} = valid_pixel ? {3{8'hFF}} : {3{8'b0}};
    
    //FSM to go through the diffrent possible states of the display
    dffr #(3) global_state(.d(next_state), .q(state), .r(reset), .clk(clk));
    reg [2:0]next_state;
    wire [2:0] state; 
    always @(*)begin
        case(state)
            `NORMAL: next_state = next_display ? `HALF : `NORMAL;
            `HALF: next_state = next_display ? `QUARTER : `HALF;
            `QUARTER: next_state = next_display ? `HEIGHTMAX : `QUARTER;
            `HEIGHTMAX: next_state = next_display ? `WIDTHMAX : `HEIGHTMAX;
            `WIDTHMAX: next_state = next_display ? `NORMAL : `WIDTHMAX;
            default:next_state = next_display ? `HALF : `NORMAL;
       endcase 
    end
    
    //datapath for the above 
    always@(*)begin
        case(state)
            `NORMAL: read_value_adjusted = (read_value >> 1)+ 8'd32;
            `HALF: read_value_adjusted = (read_value >> 2)+ 8'd32;
            `QUARTER:read_value_adjusted = (read_value >> 3)+ 8'd32;
            `HEIGHTMAX: read_value_adjusted = read_value;
            `WIDTHMAX: read_value_adjusted = (read_value >> 1)+ 8'd32 ; // this is paired with x_valid being true when state == WIDTHMAX
            
            default: read_value_adjusted = (read_value >> 1)+ 8'd32;
        endcase
     end                 
endmodule
