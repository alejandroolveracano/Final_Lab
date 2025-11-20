module sine_reader(
    input clk,
    input reset,
    input [19:0] step_size,
    input generate_next,
    output sample_ready,
    output wire [15:0] sample
);
    //declaration of internal varibles
    reg [21:0]next_addr;
    wire [21:0]addr;
    wire [19:0]step;
    wire new_step;
    reg [21:0]out_mux1;
    reg [9:0]out_mux3;
    wire [15:0] sine_output;
    reg [15:0]out_mux4;
    wire delay1;
    wire delay2;;
    wire q4selector;
    //used to track if the input step_size changes
    dffr #((20)) STATE_CHANGE_IN_STEP(.clk(clk), .r(reset), .d(step_size), .q(step));
    //after mux2 FF that will change the addr
    dffr #((22)) STATE_CHANGE_IN_ADDR(.clk(clk), .r(reset), .d(next_addr), .q(addr));
    //used as a selector for mux1
    assign new_step = (step_size != step)? 1 : 0;
   //mux1
    always@(*)begin
        case(new_step)
        1'b0: out_mux1 = addr;
        1'b1: out_mux1 = 22'd0;
        default: out_mux1 = 22'd0;
        endcase
    end
    //mux2
    always@(*)begin
        case(generate_next && ~new_step)
            1'b0: next_addr = out_mux1;
            1'b1: next_addr = (addr + {2'b00,step_size});
            default:next_addr = out_mux1;//signal to see if something goes wrong
        endcase
    end
    //mux3
    always@(*)begin
        case(addr[20])
        1'b0: out_mux3 = addr[19:10];
        1'b1: out_mux3 = (10'd1023 - addr[19:10]) ;//double check this
        default: out_mux3 = addr[19:10];
        endcase
    end
    //drive mux3 varibles into sine_rom
    sine_rom SINE_ROM(.clk(clk), .addr(out_mux3), .dout(sine_output));
     dffr #((1))STATE_POST_SINE_ROM(.clk(clk), .r(reset), .d(addr[21]), .q(q4selector));
    //mux4
    always@(*)begin
        case(q4selector)
        1'b0: out_mux4 = sine_output;
        1'b1: out_mux4 =(16'd0 - sine_output);
        default: out_mux4 = sine_output;
        endcase
    end
    //logic to deal with sample_ready //*delay1 and delay2 have to be wires not reg*//
    dffr #((1)) STATE_DELAY1(.clk(clk), .r(reset), .d(generate_next), .q(delay1));
    dffr #((1)) STATE_DELAY2(.clk(clk), .r(reset), .d(delay1), .q(delay2));
    assign sample_ready = delay2;
    assign sample = out_mux4;
endmodule