module round(datain, dataout, con_sel, shift_con, clk, mc_en, rk_delayedataout, rk_last_out);
    input [7:0] datain;
    output [7:0] dataout;
    input con_sel;
    input [1:0] shift_con;
    input clk;
    input [7:0] mc_en;
    input [7:0] rk_delayedataout, rk_last_out;
    
    wire [7:0] sr_in, sr_out, s_out, mc_out0, mc_out1, mc_out2, mc_out3, sbox_o;
    wire [31:0] pdin;

    assign pdin = {mc_out0, mc_out1, mc_out2, mc_out3};
    assign sr_in = rk_delayedataout ^ s_out;
    assign dataout = sbox_o ^ rk_last_out;

    shiftrow shift_row (sr_in, sr_out, shift_con, clk);
    control control (datain, s_out, pdin, con_sel, clk);
    mixcolumn_8bit mix_column (sbox_o, mc_en, mc_out0, mc_out1, mc_out2, mc_out3, clk);
    sbox sbox (sr_out, sbox_o);
endmodule

