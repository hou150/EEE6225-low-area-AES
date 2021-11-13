`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bingjian Li 
// 
// Create Date: 2021/02/13 17:23:58
// Design Name: 
// Module Name: keyexpansion
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module keyexpansion
(
    input                       clk,
	input                       input_muxctrl,
	input                       sbox_muxctrl,
	input                       bit_out_muxctrl,
	input                       last_out_muxctrl,		
	input           [3:0]       round_count,
	input           [7:0]       key_in,
	input           [7:0]       rcon_en,
	output          [7:0]       key_out,
	output          [7:0]       key_last_out

);
    reg             [7:0]       r15, r14, r13, r12, r11, r10, r9, r8, r7, r6, r5, r4, r3, r2, r1, r0, r_rotword, rcon;
    wire            [7:0]       rcon_sbox_out, sbox_out, rcon_out, sbox_in, mux_in_out, mux_bit_out;

    
	always @(*)
	begin
	    case(round_count)
		    4'b0000:rcon    <=    8'h01;
            4'b0001:rcon    <=    8'h02;
            4'b0010:rcon    <=    8'h04;
            4'b0011:rcon    <=    8'h08;
            4'b0100:rcon    <=    8'h10;
            4'b0101:rcon    <=    8'h20;
            4'b0110:rcon    <=    8'h40;
            4'b0111:rcon    <=    8'h80;
            4'b1000:rcon    <=    8'h1b;
            4'b1001:rcon    <=    8'h36;
            default:rcon    <=    8'h01;
		endcase
	end


    assign    rcon_sbox_out  =    sbox_out ^ rcon_out;
    assign    rcon_out       =    rcon_en & rcon;	
    assign    key_out        =    r12;
    

    always @(posedge clk)
    begin
        r15                 <=    mux_in_out;
        r14                 <=    r15;
        r13                 <=    r14;
        r12                 <=    r13;
        r11                 <=    r12;
        r10                 <=    r11;
        r9                  <=    r10;
        r8                  <=    r9;
        r7                  <=    r8;
        r6                  <=    r7;
        r5                  <=    r6;
        r4                  <=    r5;
        r3                  <=    mux_bit_out;
        r2                  <=    r3;
        r1                  <=    r2;
        r0                  <=    r1;
    end
    
    always @(posedge clk)
    begin
        if(rcon_en   ==   8'hff)
        begin
            r_rotword       <=    r12;
        end
    end 
	
	
    mux2_1 mux_in(
	    .mux_in1(key_last_out),
	    .mux_in2(key_in),
	    .muxctrl(input_muxctrl),
	    .mux_out(mux_in_out)
	);
	
    mux2_1 mux_sbox(
	    .mux_in1(r13),
	    .mux_in2(r_rotword),
	    .muxctrl(sbox_muxctrl),
	    .mux_out(sbox_in)
	); 
	
    mux2_1 mux_bit(
		.mux_in1((r4 ^ key_last_out)),
	    .mux_in2(r4),
	    .muxctrl(bit_out_muxctrl),
	    .mux_out(mux_bit_out)
	); 
	
    mux2_1 mux_last_out(
		.mux_in1(r0),
	    .mux_in2((r0 ^ rcon_sbox_out)),
	    .muxctrl(last_out_muxctrl),
	    .mux_out(key_last_out)	
	);
	
    sbox sbox(
	    .sin(sbox_in),
	    .sout(sbox_out)
	);

endmodule
