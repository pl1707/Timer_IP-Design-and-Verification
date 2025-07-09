module register (
	// clock and reset
	input wire sys_clk, 
	input wire sys_rst_n,
	
	// read and write 
	input wire wr_en,
	input wire rd_en,
	input wire [11:0] addr,
	input wire [31:0] wdata,
	output wire [31:0] rdata,
	input wire [63:0] cnt,
	output wire tdr0_wr_sel,
	output wire tdr1_wr_sel,

	output wire pslverr,
		
	output reg div_en,
	output reg [3:0] div_val,
	output reg timer_en,
	output wire tim_int
); 
	parameter ADDR_TCR   = 12'h000;
	parameter ADDR_TDR0  = 12'h004;
	parameter ADDR_TDR1  = 12'h008;
	parameter ADDR_TCMP0 = 12'h00c;
	parameter ADDR_TCMP1 = 12'h010;
	parameter ADDR_TIER  = 12'h014;
	parameter ADDR_TISR  = 12'h018;
	parameter ADDR_THCSR  = 12'h01c;
	
	reg [31:0] rd;
	reg [31:0] tcmp0;
	reg [31:0] tcmp1;
	
	reg int_en;	
	reg int;
	reg halt_req;
	
	wire tcr_wr_sel;
	wire tcmp0_wr_sel;
	wire tcmp1_wr_sel;
	wire tier_wr_sel;
	wire tisr_wr_sel;
	wire thcsr_wr_sel;
	
	wire div_val_wr_en;
	wire div_val_wr_sel;
	wire [3:0] div_val_pre;
	wire div_en_pre;
	wire timer_en_pre;


	wire [31:0] tcmp0_pre;
	wire [31:0] tcmp1_pre;
	wire int_en_pre;
	wire int_pre;
	wire int_sig;
	wire halt_req_pre;
	//tcr
	assign tcr_wr_sel     = wr_en & (addr == ADDR_TCR);
	assign div_val_wr_en  = (wdata[11:8] <= 4'h8);
	assign div_val_wr_sel = div_val_wr_en & tcr_wr_sel;
	
	//assign div_val_pre  = div_val_wr_sel ? (wdata[11:8] < 4'd9 ? wdata[11:8] : 4'd8) :div_val;
	assign div_val_pre  = div_val_wr_sel ? wdata[11:8] :div_val;
	assign div_en_pre   = tcr_wr_sel ? wdata[1] : div_en;
	assign timer_en_pre = tcr_wr_sel ? wdata[0] : timer_en;

	// tdr 
	assign tdr0_wr_sel = wr_en & (addr == ADDR_TDR0);
	assign tdr1_wr_sel = wr_en & (addr == ADDR_TDR1);
	
	// tcmp
	assign tcmp0_wr_sel = wr_en & (addr == ADDR_TCMP0);
	assign tcmp0_pre    = tcmp0_wr_sel ? wdata : tcmp0;

	assign tcmp1_wr_sel = wr_en & (addr == ADDR_TCMP1);
	assign tcmp1_pre    = tcmp1_wr_sel ? wdata : tcmp1;

	//tier
	assign tier_wr_sel = wr_en & (addr == ADDR_TIER);
	assign int_en_pre  = tier_wr_sel ? wdata[0] : int_en;

	//tisr 
	assign int_sig     = (cnt == { tcmp1, tcmp0});
	assign tisr_wr_sel = wr_en & (addr == ADDR_TISR);
	wire int_clr       = tisr_wr_sel & (wdata[0]== 1'b1) & (int==1'b1);
	wire int_set       = int_sig;
	assign int_pre     = int_clr ? 1'b0:(int_set ? 1'b1:int);

	//thcsr 
	assign thcsr_wr_sel = wr_en & (addr == ADDR_THCSR);
	assign halt_req_pre = thcsr_wr_sel ? wdata[0] :halt_req;
	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n)begin
			div_val  <= 4'b0001;
			div_en   <= 1'b0;
			timer_en <= 1'b0;
			tcmp0    <= 32'hffff_ffff;
			tcmp1    <= 32'hffff_ffff;
			int_en   <= 1'b0;
			int      <= 1'b0;
			halt_req <= 1'b0;
		end
		else begin
			div_val  <= div_val_pre;
			div_en   <= div_en_pre;
			timer_en <= timer_en_pre;
			tcmp0    <= tcmp0_pre;
			tcmp1    <= tcmp1_pre;
			int_en   <= int_en_pre;
			int      <= int_pre;
			halt_req <= halt_req_pre;
		end
	end
	// read
	always @* begin
           if(rd_en)begin
		case(addr)
			ADDR_TCR:   rd = {20'h0,div_val,6'h0,div_en,timer_en};
			ADDR_TDR0:  rd = cnt[31:0];
			ADDR_TDR1:  rd = cnt[63:32];
			ADDR_TCMP0: rd = tcmp0;
			ADDR_TCMP1: rd = tcmp1;
			ADDR_TIER:  rd = {31'h0, int_en};
			ADDR_TISR:  rd = {31'h0, int};
			ADDR_THCSR: rd = {31'h0, halt_req};
			default:    rd = 32'h0;			
		endcase
	   end else begin
		rd = 32'h0;
		end
	 end

	assign rdata = rd;
	assign tim_int = int & int_en;
endmodule


	
	
