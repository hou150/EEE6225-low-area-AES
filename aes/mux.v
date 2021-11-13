`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bingjian Li 
// 
// Create Date: 2021/04/22 21:37:29
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

  
module mux2_1(
	input           [7:0]       mux_in1,
	input           [7:0]       mux_in2,
	output          [7:0]       mux_out,
	input                       muxctrl
);

    assign    mux_out    =    muxctrl ? mux_in1 : mux_in2;
	
endmodule

module mux4_1(
	input           [7:0]       mux_in1,
	input           [7:0]       mux_in2,
    input           [7:0]       mux_in3,
	input           [7:0]       mux_in4,
	output          [7:0]       mux_out,
	input           [1:0]       muxctrl
);

    reg             [7:0]       mux_out_reg;
	
    assign    mux_out    =    mux_out_reg;

    always @(*)
    begin
        case(muxctrl)
            2'b00:    mux_out_reg    =    mux_in1;
            2'b01:    mux_out_reg    =    mux_in2;
            2'b10:    mux_out_reg    =    mux_in3;
            default:  mux_out_reg    =    mux_in4;
        endcase
    end
	
endmodule