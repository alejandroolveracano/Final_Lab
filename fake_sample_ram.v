/*
 * A simple fake RAM that you can use to aid in debugging your wave display.
 */
module fake_sample_ram (
    input clk,
    input [8:0] addr,//changed this to 9-bit input
    output reg [7:0] dout
);

    

    always @(posedge clk)
        dout = addr[7:0];// changed dout to just output the 8 LSB

endmodule

