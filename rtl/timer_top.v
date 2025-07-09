module timer_top (
	input wire sys_clk,
	input wire sys_rst_n,

	input wire tim_psel,
	input wire tim_penable,
	input wire [3:0] tim_pstrb,
	input wire tim_pwrite,
	output wire tim_pready,
	input wire [11:0] tim_paddr,
	input wire [31:0] tim_pwdata,
	output wire [31:0] tim_prdata,
	output wire tim_int,
	output wire tim_pslverr,
	input wire dbg_mode
);
	wire wr_en;
	wire rd_en;
	wire timer_en; 
	wire div_en;
	wire [3:0] div_val;
	wire count_en;
	wire [63:0] cnt;

	// apb module
	apb_interface apb(
		.sys_clk(sys_clk), .sys_rst_n(sys_rst_n), .pstrb(tim_pstrb),
	        .psel(tim_psel), .penable(tim_penable), 
		.pwrite(tim_pwrite), .pready(tim_pready),	
		.wr_en(wr_en), .rd_en(rd_en));

	// register module
	register regset(
		.sys_clk(sys_clk), .sys_rst_n(sys_rst_n), .pslverr(tim_pslverr), 
		.wr_en(wr_en), .rd_en(rd_en), 
		.addr(tim_paddr), .wdata(tim_pwdata), .rdata(tim_prdata),
		.cnt(cnt), .div_en(div_en), .div_val(div_val), 
		.tdr0_wr_sel(tdr0_wr_sel), .tdr1_wr_sel(tdr1_wr_sel),
		.timer_en(timer_en), .tim_int(tim_int)
		
	);

	// counter module
	counter cnt_logic(
		.sys_clk(sys_clk), .sys_rst_n(sys_rst_n),
		.tdr0_wr_sel(tdr0_wr_sel), .tdr1_wr_sel(tdr1_wr_sel),
		.count(cnt), .count_en(count_en), .wdata(tim_pwdata)
	);
	


	// counter control module
	counter_control cnt_ctr (
		.sys_clk(sys_clk), .sys_rst_n(sys_rst_n),
		.count_en(count_en), .timer_en(timer_en), .wdata(tim_pwdata),
		.div_en(div_en), .div_val(div_val)
);

	endmodule
