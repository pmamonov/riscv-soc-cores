module core_ep2c5_picorv32_wb_soc(
	input CLOCK_50,
	input RST_N,
	input UART_RXD,
	output UART_TXD
	);

	wire wb_clk;
	wire wb_rst;

	altpll_clkgen #(
		.DEVICE_FAMILY ("Cyclone II"),
		.INPUT_FREQUENCY (50),
		.DIVIDE_BY (25),
		.MULTIPLY_BY (12)
	)
	clkgen(
		.sys_clk_pad_i(CLOCK_50),
		.rst_n_pad_i(RST_N),
		.wb_clk_o(wb_clk),
		.wb_rst_o(wb_rst)
	);

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),
		.SRAM0_MEMDEPTH (8192)
	)
	soc(
		.clock(wb_clk),
		.reset(wb_rst),
		.wb_iadr_o(),
		.uart_rx(UART_RXD),
		.uart_tx(UART_TXD)
	);

endmodule
