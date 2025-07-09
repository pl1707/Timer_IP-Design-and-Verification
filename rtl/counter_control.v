module counter_control (
	input wire sys_clk,
	input wire sys_rst_n,
	
	input wire div_en,
	input wire [3:0] div_val,
	input wire timer_en,
	input wire [31:0] wdata,
	output wire count_en
);	
	reg [7:0] count;
	reg [7:0] max;
	wire [7:0] count_next;
	wire count_rst;
	always @* begin
		if(wdata[11:8] <4'd9)begin
		  case(div_val)
			4'd0: max = 8'd0;
			4'd1: max = 8'd1;
			4'd2: max = 8'd3;
			4'd3: max = 8'd7;
			4'd4: max = 8'd15;
			4'd5: max = 8'd31;
			4'd6: max = 8'd63;
			4'd7: max = 8'd127;
			4'd8: max = 8'd255;
			default : max = 8'd0;
		  endcase
		end else begin
			max=8'd0;
			end
	end
	assign count_rst = (count == max) || (!timer_en) || (!div_en);
	assign count_next = count_rst ? 8'd0 : (div_val !=4'b0 && div_en ? count + 8'd1 : count);
	
	always @(posedge sys_clk or negedge sys_rst_n)begin
		if(!sys_rst_n)begin
			count <= 8'd0;
		end
		else begin
			count <= count_next;
		end				
	end
	wire default_mode = timer_en && !div_en;
	wire control_mode_0 = timer_en && div_en && (div_val == 4'd0);
	wire control_mode = timer_en && div_en && (div_val != 4'd0) && (wdata[11:8] < 4'd9);
	//wire control_mode = timer_en && div_en && (div_val != 4'd0) ;
	assign count_en = default_mode || control_mode_0 || (control_mode && (count == max));	
endmodule
