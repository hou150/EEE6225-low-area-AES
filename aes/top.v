module ae_encry (rst, clk, keyin, datain, dataout, valid);
    input rst, clk;
    input [7:0] keyin;
    input [7:0] datain;
    output [7:0] dataout;
    output reg valid;

    //key scheduler controller
    wire [3:0] round_cnt_w;
    reg input_sel, sbox_sel, last_out_sel, bit_out_sel;
    reg [7:0] rcon_en;
    reg [3:0] count;
    reg [7:0] round_count;
    reg [2:0] state;
    wire [7:0] rk_delayed_out, rk_last_out;
    reg [1:0] c3;
    wire sel;
    reg [7:0] mix_en_reg;
    reg sel_reg;
    wire [7:0] mix_en;
    reg [7:0] dataout;
    wire [7:0] d_out_w;

    always @ (posedge clk)
    begin
        dataout <= d_out_w;
    end

    assign sel = sel_reg;
    assign mix_en = mix_en_reg;
    assign round_cnt_w = round_count[7:4];

    keyexpansion key(
	    .clk(clk),
	    .input_muxctrl(input_sel),
	    .sbox_muxctrl(sbox_sel),
	    .bit_out_muxctrl(bit_out_sel),
	    .last_out_muxctrl(last_out_sel),		
	    .round_count(round_cnt_w),
	    .key_in(keyin),
	    .rcon_en(rcon_en),
	    .key_out(rk_delayed_out),
	    .key_last_out(rk_last_out)
	);
	
	
	
	round aes_round (datain, d_out_w, sel, c3, clk, mix_en, rk_delayed_out, rk_last_out);

    parameter load = 3'h0; //load 16 byte
    parameter b1st = 3'h1; //first byte need rcon
    parameter b2nd = 3'h2; //2byte go through sbox
    parameter b3rd = 3'h3; //last byte go through sbox from redundant register
    parameter norm = 3'h4; //normal round calculate two columns
    parameter shif = 3'h5; //shift 4 byte 

    //state machine for key schedule
    always @ (posedge clk)
    begin
        if (rst == 1'b1)
        begin
            state <= load;
            count <= 4'h0;
        end
        else
        begin
            case (state)
                load: 
                begin
                    count <= count + 4'h1;
                    if (count == 4'hf)
                    begin
                        state <= b1st;
                        count <= 4'h0;
                    end
                end

                b1st:
                begin
                    state <= b2nd;
                    count <= 4'h0;
                end

                b2nd:
                begin
                    count <= count + 4'h1;
                    if (count == 4'h1)
                    begin
                        state <= b3rd;
                        count <= 4'h0;
                    end
                end
                
                b3rd:
                begin
                    state <= norm;
                    count <= 4'h0;
                end

                norm: 
                begin
                    count <= count + 4'h1;
                    if(count == 4'h7)
                    begin
                        state <= shif;
                        count <= 4'h0;
                    end
                end

                shif:
                begin
                    count <= count + 4'h1;
                    if(count == 4'h3)
                    begin
                        state <= b1st;
                        count <= 4'h0;
                    end
                end
            endcase
        end
    end

    //mux select and rcon enable for key schedule
    always @ (*)
    begin
        case(state)
            load: 
            begin
                input_sel <= 1'b0;
                sbox_sel <= 1'b1;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b0;
                rcon_en <= 8'h00;
            end

            b1st:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b1;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b1;
                rcon_en <= 8'hFF;
            end
                 
            b2nd:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b1;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b1;
                rcon_en <= 8'h00;
            end

            b3rd:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b0;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b1;
                rcon_en <= 8'h00;
            end

            norm:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b0;
                last_out_sel <= 1'b1;
                bit_out_sel <= 1'b1;
                rcon_en <= 8'h00;
            end

            shif:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b0;
                last_out_sel <= 1'b1;
                bit_out_sel <= 1'b0;
                rcon_en <= 8'h00;
            end

            default: 
            begin
                input_sel <= 1'b0;
                sbox_sel <= 1'b1;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b0;
                rcon_en <= 8'h00;
            end
        endcase
    end

    //round counter
    always @ (posedge clk)
    begin
        if (rst == 1'b1 || count == 4'hf || round_cnt_w == 4'ha)
        begin
            round_count <= 6'h00;
        end
        else
        begin
            round_count <= round_count + 6'h01;
        end
    end


   
    //state machine shift row
    always @ (posedge clk)
    begin
        if (state == load) 
        begin
            c3 <= 2'h3;
        end
        else
        begin
            case (round_count[3:0])
                4'h0: c3 <= 2'h2;
                4'h1: c3 <= 2'h1;
                4'h2: c3 <= 2'h0;
                4'h3: c3 <= 2'h3;
                4'h4: c3 <= 2'h2;
                4'h5: c3 <= 2'h1;
                4'h6: c3 <= 2'h1;
                4'h7: c3 <= 2'h3;
                4'h8: c3 <= 2'h2;
                4'h9: c3 <= 2'h3;
                4'hA: c3 <= 2'h2;
                4'hB: c3 <= 2'h3;
                4'hC: c3 <= 2'h3;
                4'hD: c3 <= 2'h3;
                4'hE: c3 <= 2'h3;
                4'hF: c3 <= 2'h3;
            endcase
        end
    end

    //mixcoloumn enable
    always @ (posedge clk)
    begin
        if (round_count[1:0] == 2'b11)
        begin
            mix_en_reg <= 8'h00;
        end
        else
        begin
            mix_en_reg <= 8'hFF;
        end
    end

    //parelle load
    always @ (posedge clk)
    begin
        if (state == load)
        begin
            sel_reg <= 1'b0;
        end
        else
        begin
            if (round_count[1:0] == 2'b11)
            begin
                sel_reg <= 1'b1;
            end
            else
            begin
                sel_reg <= 1'b0;
            end
        end
    end

    always @(posedge clk)
    begin
        if (rst == 1'b1)
        begin
            valid <= 1'b0;
        end
        else
        begin
            if (round_count == 8'h90)
            begin
                valid <= 1'b1;
            end
        end
    end
endmodule

