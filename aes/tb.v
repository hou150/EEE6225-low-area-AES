`timescale 1ns/1ns

module aes_tb;
    reg rst;
    reg clk;
    reg [7:0] key;
    reg [7:0] datain;
    wire [7:0] dataout;
    wire valid;
   


    parameter kin = 128'h2b7e151628aed2a6abf7158809cf4f3c;  //eg in fips197
    parameter din = 128'h3243f6a8885a308d313198a2e0370734;



    parameter period = 20;
    
    
    ae_encry uut (rst, clk, key, datain, dataout, valid);

    always # (period/2)  
	begin
	    clk = ~ clk;
    end
    
    initial begin
        
        rst = 1'b1;
        clk = 1'b1;    
        #period
        rst = 1'b0;
        key = kin[127:120];
        datain = din[127:120];
        #period
        key = kin[119:112];
        datain = din[119:112];
        #period
        key = kin[111:104];
        datain = din[111:104];
        #period
        key = kin[103:96];
        datain = din[103:96];
        #period
        key = kin[95:88];
        datain = din[95:88];
        #period
        key = kin[87:80];
        datain = din[87:80];
        #period
        key = kin[79:72];
        datain = din[79:72];
        #period
        key = kin[71:64];
        datain = din[71:64];
        #period
        key = kin[63:56];
        datain = din[63:56];
        #period
        key = kin[55:48];
        datain = din[55:48];
        #period
        key = kin[47:40];
        datain = din[47:40];
        #period
        key = kin[39:32];
        datain = din[39:32];
        #period
        key = kin[31:24];
        datain = din[31:24];
        #period
        key = kin[23:16];
        datain = din[23:16];
        #period
        key = kin[15:8];
        datain = din[15:8];
        #period
        key = kin[7:0];
        datain = din[7:0];
    end
endmodule

