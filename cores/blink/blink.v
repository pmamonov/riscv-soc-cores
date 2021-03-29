module blink #(
	parameter CLK_HZ	= 100000000
) (
	output reg		led_o,
	// Wishbone slave interface
	input			wb_rst_i,
	input [15:0] 		wb_adr_i,
	input [31:0] 		wb_dat_i,
	input [3:0] 		wb_sel_i,
	input 			wb_we_i,
	input 			wb_cyc_i,
	input 			wb_stb_i,
	input [2:0] 		wb_cti_i,
	input [1:0] 		wb_bte_i,
	output reg [31:0] 	wb_dat_o,
	output reg		wb_ack_o,
	output 			wb_err_o,
	output 			wb_rty_o,
	input			wb_clk_i
);

	reg [31:0]	cnt;
	reg [31:0]	div;

	assign wb_err_o = 0;
	assign wb_rty_o = 0;
	assign wb_wacc = wb_we_i & wb_ack_o;

	initial begin
		div = CLK_HZ - 1;
		cnt = 0;
		led_o = 1'b1;
	end

	always @(posedge wb_clk_i) begin
		wb_ack_o <= wb_cyc_i & wb_stb_i & !wb_ack_o;

		case (wb_adr_i)
			0:		wb_dat_o <= div;
			4:		wb_dat_o <= cnt;
			default:	wb_dat_o <= {16'h0, wb_adr_i};
		endcase

		if (wb_wacc) begin
			case (wb_adr_i)
				0: begin
					cnt <= 0;
					div <= wb_dat_i;
				end
			endcase
		end else begin
			/* divide by (div + 1) */
			if (cnt == div) begin
				cnt <= 0;
				led_o <= ~led_o;
			end else begin
				cnt <= cnt + 1;
			end
		end
	end
endmodule
