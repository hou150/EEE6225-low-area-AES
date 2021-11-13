module control(din, dout, pdin, con_sel, clk);
    input [7:0] din;
    output [7:0] dout; 
    input [31:0] pdin; // highest byte go out first
    input con_sel; // 1 means parallel load, 0 means serial unload
    input clk;

    reg [7:0] reg3, reg2, reg1, reg0;

    wire [7:0] mux1_o, mux2_o, mux3_o;

    mux2_1 mux0 (
	    .mux_in1(pdin[31:24]),
		.mux_in2(reg0),
		.muxctrl(con_sel),
		.mux_out(dout)	
	);

	mux2_1 mux1 (
	    .mux_in1(pdin[23:16]),
		.mux_in2(reg1),
		.muxctrl(con_sel),
		.mux_out(mux1_o)	
	);
	
	mux2_1 mux2 (
	    .mux_in1(pdin[15: 8]),
		.mux_in2(reg2),
		.muxctrl(con_sel),
		.mux_out(mux2_o)	
	);
	
	mux2_1 mux3 (
	    .mux_in1(pdin[ 7: 0]),
		.mux_in2(reg3),
		.muxctrl(con_sel),
		.mux_out(mux3_o)	
	);


    always @ (posedge clk)
    begin
        reg3 <= din;
        reg2 <= mux3_o;
        reg1 <= mux2_o;
        reg0 <= mux1_o;
    end
endmodule
        
