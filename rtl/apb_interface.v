module apb_interface (
	// clock and reset
	input wire sys_clk,
	input wire sys_rst_n,
	input wire psel,
	input wire pwrite,
	input wire [3:0] pstrb,
	input wire penable,
	output wire pready,
	output wire wr_en,
	output wire rd_en
);

	assign wr_en = psel & penable & pwrite;
	assign rd_en = psel & penable & ~pwrite;
	assign pready = 1'b1;
endmodule
 
