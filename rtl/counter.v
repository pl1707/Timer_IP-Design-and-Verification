module counter (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire tdr0_wr_sel,
	input wire tdr1_wr_sel,
	input wire [31:0] wdata,
	input wire count_en,
	output wire [63:0] count
);
	reg [31:0] tdr0;
	reg [31:0] tdr1;
	wire [31:0] tdr0_pre;
	wire [31:0] tdr1_pre;
	wire [63:0] count_p1;
	
	assign count_p1 = count + 64'd1;
	assign tdr0_pre = tdr0_wr_sel ? wdata : (count_en ? count_p1[31:0] : tdr0);
	assign tdr1_pre = tdr1_wr_sel ? wdata : (count_en ? count_p1[63:32] : tdr1);

	
	always @(posedge sys_clk or negedge sys_rst_n)begin
		if(!sys_rst_n)begin
			tdr0      <= 0;
			tdr1      <= 0;
		end
		else begin
			tdr0 <= tdr0_pre;
			tdr1 <= tdr1_pre;	
		end
	end
	assign count = {tdr1, tdr0};
	endmodule	

		       	
	

