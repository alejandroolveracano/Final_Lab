`define NUMBER_1 9'h188         // number definitions
`define NUMBER_2 9'h190
`define NUMBER_3 9'h198
`define NUMBER_4 9'h1A0
`define NUMBER_5 9'h1A8
`define NUMBER_6 9'h1B0

`define LETTER_A 9'h008         // letter definitions
`define LETTER_B 9'h010
`define LETTER_C 9'h018
`define LETTER_D 9'h020
`define LETTER_E 9'h028
`define LETTER_F 9'h030
`define LETTER_G 9'h038

`define SYMBOL_SPACE 9'h100     // symbol definitions
`define SYMBOL_HASH 9'h118

`define INVALID 9'h0c0          // invalid X address

module note_rom (
    input [5:0] note,
    output reg [8:0] num_addr,
    output reg [8:0] letter_addr,
    output reg [8:0] symbol_addr
);

always @(*) begin
    // empty always block
    case (note)
        6'd1: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_A, `SYMBOL_SPACE};
        6'd2: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_A, `SYMBOL_HASH};
        6'd3: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_B, `SYMBOL_SPACE};
        6'd4: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_C, `SYMBOL_SPACE};
        6'd5: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_C, `SYMBOL_HASH};
        6'd6: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_D, `SYMBOL_SPACE};
        6'd7: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_D, `SYMBOL_HASH};
        6'd8: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_E, `SYMBOL_SPACE};
        6'd9: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_F, `SYMBOL_SPACE};
        6'd10: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_F, `SYMBOL_HASH};
        6'd11: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_G, `SYMBOL_SPACE};
        6'd12: {num_addr, letter_addr, symbol_addr} = {`NUMBER_1, `LETTER_G, `SYMBOL_HASH};
        6'd13: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_A, `SYMBOL_SPACE};
        6'd14: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_A, `SYMBOL_HASH};
        6'd15: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_B, `SYMBOL_SPACE};
        6'd16: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_C, `SYMBOL_SPACE};
        6'd17: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_C, `SYMBOL_HASH};
        6'd18: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_D, `SYMBOL_SPACE};
        6'd19: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_D, `SYMBOL_HASH};
        6'd20: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_E, `SYMBOL_SPACE};
        6'd21: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_F, `SYMBOL_SPACE};
        6'd22: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_F, `SYMBOL_HASH};
        6'd23: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_G, `SYMBOL_SPACE};
        6'd24: {num_addr, letter_addr, symbol_addr} = {`NUMBER_2, `LETTER_G, `SYMBOL_HASH};
        6'd25: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_A, `SYMBOL_SPACE};
        6'd26: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_A, `SYMBOL_HASH};
        6'd27: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_B, `SYMBOL_SPACE};
        6'd28: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_C, `SYMBOL_SPACE};
        6'd29: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_C, `SYMBOL_HASH};
        6'd30: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_D, `SYMBOL_SPACE};
        6'd31: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_D, `SYMBOL_HASH};
        6'd32: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_E, `SYMBOL_SPACE};
        6'd33: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_F, `SYMBOL_SPACE};
        6'd34: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_F, `SYMBOL_HASH};
        6'd35: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_G, `SYMBOL_SPACE};
        6'd36: {num_addr, letter_addr, symbol_addr} = {`NUMBER_3, `LETTER_G, `SYMBOL_HASH};
        6'd37: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_A, `SYMBOL_SPACE};
        6'd38: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_A, `SYMBOL_HASH};
        6'd39: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_B, `SYMBOL_SPACE};
        6'd40: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_C, `SYMBOL_SPACE};
        6'd41: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_C, `SYMBOL_HASH};
        6'd42: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_D, `SYMBOL_SPACE};
        6'd43: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_D, `SYMBOL_HASH};
        6'd44: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_E, `SYMBOL_SPACE};
        6'd45: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_F, `SYMBOL_SPACE};
        6'd46: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_F, `SYMBOL_HASH};
        6'd47: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_G, `SYMBOL_SPACE};
        6'd48: {num_addr, letter_addr, symbol_addr} = {`NUMBER_4, `LETTER_G, `SYMBOL_HASH};
        6'd49: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_A, `SYMBOL_SPACE};
        6'd50: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_A, `SYMBOL_HASH};
        6'd51: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_B, `SYMBOL_SPACE};
        6'd52: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_C, `SYMBOL_SPACE};
        6'd53: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_C, `SYMBOL_HASH};
        6'd54: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_D, `SYMBOL_SPACE};
        6'd55: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_D, `SYMBOL_HASH};
        6'd56: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_E, `SYMBOL_SPACE};
        6'd57: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_F, `SYMBOL_SPACE};
        6'd58: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_F, `SYMBOL_HASH};
        6'd59: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_G, `SYMBOL_SPACE};
        6'd60: {num_addr, letter_addr, symbol_addr} = {`NUMBER_5, `LETTER_G, `SYMBOL_HASH};
        6'd61: {num_addr, letter_addr, symbol_addr} = {`NUMBER_6, `LETTER_A, `SYMBOL_SPACE};
        6'd62: {num_addr, letter_addr, symbol_addr} = {`NUMBER_6, `LETTER_A, `SYMBOL_HASH};
        6'd63: {num_addr, letter_addr, symbol_addr} = {`NUMBER_6, `LETTER_B, `SYMBOL_SPACE};
        default: {num_addr, letter_addr, symbol_addr} = {`INVALID, `INVALID, `INVALID};
    endcase
end

endmodule