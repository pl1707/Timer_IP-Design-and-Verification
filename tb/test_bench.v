module test_bench;

    parameter   ADDR_TCR    =   12'h0;
    parameter   ADDR_TDR0   =   12'h4;
    parameter   ADDR_TDR1   =   12'h8;
    parameter   ADDR_TCMP0  =   12'hC;
    parameter   ADDR_TCMP1  =   12'h10;
    parameter   ADDR_TIER   =   12'h14;
    parameter   ADDR_TISR   =   12'h18;
    parameter   ADDR_THCSR  =   12'h1C;

    parameter   APB_CYCLE   =   1     ;
    
    reg  clk, rst_n;
    reg  psel, pwrite, penable,dbg_mode;
    reg  [11:0] paddr;
    reg  [31:0] pwdata;
    reg  [3:0 ] pstrb;
    wire [31:0] prdata;
    wire          pready;
    wire          tim_int;
    wire        pslverr;
    integer     err;
    integer     pass_err;

    reg cnt_chk_en;
    reg [31:0] cnt_chk_cycle;
    reg [3:0]  div_val;
    reg [63:0] exp_cnt;      
	

    reg val;
    reg apb_err_psel;
    reg apb_err_penable;
    reg pslverr_chk_fail, pready_chk_fail;

    
    //instance DUT
    timer_top u_timer 
    (
        .sys_clk    (   clk     ),
        .sys_rst_n  (   rst_n   ),
        .tim_psel   (   psel    ),
        .tim_pwrite (   pwrite  ),
        .tim_penable(   penable ),
        .tim_paddr   (  paddr    ),
        .tim_pwdata  (  pwdata   ),
        .tim_prdata  (  prdata   ),
        .tim_pready  (  pready   ),
        .tim_pstrb   (   pstrb    ),
        .tim_pslverr (  pslverr  ),
        .dbg_mode  ( dbg_mode ) ,
        .tim_int ( tim_int )

    );

// Golden Model
    reg [63:0] golden_cnt;
    reg        golden_int;
    reg [3:0]  div_val_reg;
    reg        div_en_reg;
    reg        timer_en_reg;
    reg [7:0]  div_counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            golden_cnt <= 0;
            golden_int <= 0;
            div_val_reg <= 4'h1; // Default div_val = 1
            div_en_reg <= 0;
            timer_en_reg <= 0;
            div_counter <= 0;
        end else begin
            if (psel && penable && pwrite && paddr == ADDR_TCR) begin
                timer_en_reg <= pwdata[0];
                div_en_reg <= pwdata[1];
                div_val_reg <= (pwdata[11:8] > 8) ? 8 : pwdata[11:8];
            end
            if (timer_en_reg && !dbg_mode) begin
                if (!div_en_reg || div_val_reg == 0) begin
                    golden_cnt <= golden_cnt + 1;
                    div_counter <= 0;
                end else if (div_counter == (1 << div_val_reg) - 1) begin
                    golden_cnt <= golden_cnt + 1;
                    div_counter <= 0;
                end else begin
                    div_counter <= div_counter + 1;
                end
            end
            if (golden_cnt == {u_timer.regset.tcmp1, u_timer.regset.tcmp0} && u_timer.regset.int_en)
                golden_int <= 1;
            else if (psel && penable && pwrite && paddr == ADDR_TISR && pwdata[0])
                golden_int <= 0;
        end
    end
	task tsk_cfg_golden_cnt;
	input [63:0] val;
	begin
		@(posedge clk);
		#1;
		golden_cnt=val;
	end
	endtask

  	
    initial begin 
  	  clk = 0;
  	  forever #25 clk = ~clk;
  	end

  	initial begin
  	  rst_n = 1'b0;
  	  #25 rst_n = 1'b1;
  	end

    initial begin
        #100;
        run_test();
        #100;
        $finish;
    end


    initial begin
        paddr = 0;
        pwdata = 0;
        psel = 0;
        penable = 0;
        pwrite = 0;
        dbg_mode = 0;
        pstrb = 0;
        err = 0;
	pass_err =0;
        cnt_chk_cycle = 0;
        div_val = 0;
        
        apb_err_psel = 0;
        apb_err_penable = 0;
        pslverr_chk_fail = 0;
        pready_chk_fail = 0;
        
        #100;
    end


    task apb_wr;
        input   [31:0]  in_addr;
        input   [31:0]  in_data;

        begin
	    $display("t=%10d [TB_WRITE]: addr=%x data=%x",$time,in_addr, in_data);
            @(posedge clk);
            #1;
            psel = 1 & !apb_err_psel;   //setup phase
            pwrite = 1;
            paddr = in_addr;
            pwdata = in_data; //cnt_en
            @(posedge clk);
            #1;
            penable = 1 & !apb_err_penable; //access phase
            wait( pready == 1); //wait accept
            @(posedge clk);
            #1;
            pwrite = 0; //idle
            psel = 0;
            penable = 0;
            paddr = 0;
            pwdata = 0;
        end

    endtask
    
    task apb_rd;
        input   [31:0]  in_addr;
        output  [31:0]  out_rdata;
        
        begin
            @(posedge clk);
            #1;
            psel = 1 & !apb_err_psel;   //setup phase
            pwrite = 0;
            paddr = in_addr;
            @(posedge clk);
            #1;
            penable = 1 & !apb_err_penable; //access phase
            wait( pready == 1); //wait accept
            #1;
            out_rdata = prdata; 

            @(posedge clk);
            
            pwrite = 0; //idle
            psel = 0;
            penable = 0;
            paddr = 0;
            pwdata = 0;
			
            $display("t=%10d [TB_READ]: addr=%x rdata=%x",$time,in_addr, out_rdata);
        end
    endtask


    task cmp_data;
        input [31:0]  in_addr ;
        input [31:0]  in_data ;
        input [31:0]  exp_data;
        input [31:0]  mask;
 	input pf;
	begin
		if( (in_data & mask) !== (exp_data & mask) ) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: rdata at addr %x is not correct",$time, in_addr);
			$display("Exp: %x Actual:%x",exp_data & mask, in_data & mask);
			$display("------------------------------------------------");
        	        #100;
            		err=err+1;
			if (pf) pass_err = pass_err +1;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: rdata = %x at addr %x is correct",$time,in_data, in_addr);
			$display("------------------------------------------------");
		end
	end
        
    endtask

    task reg_init_chk;
        reg [31:0]  task_rdata;
        begin
      	    
            apb_rd( ADDR_TCR, task_rdata);
            cmp_data( ADDR_TCR, task_rdata, 32'h0000_0100, 32'hffff_ffff,1);
            
            apb_rd( ADDR_TDR0, task_rdata);
            cmp_data( ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hffff_ffff,1);
            
            apb_rd( ADDR_TDR1, task_rdata);
            cmp_data( ADDR_TDR1, task_rdata, 32'h0000_0000, 32'hffff_ffff,1);
            
            apb_rd( ADDR_TCMP0, task_rdata);
            cmp_data( ADDR_TCMP0, task_rdata, 32'hffff_ffff, 32'hffff_ffff,1);
            
            apb_rd( ADDR_TCMP1, task_rdata);
            cmp_data( ADDR_TCMP1, task_rdata, 32'hffff_ffff, 32'hffff_ffff,1);
            
            apb_rd( ADDR_TIER, task_rdata);
            cmp_data( ADDR_TIER, task_rdata, 32'h0000_0000, 32'hffff_ffff,1);
            
            apb_rd( ADDR_TISR, task_rdata);
            cmp_data( ADDR_TISR, task_rdata, 32'h0000_0000, 32'hffff_ffff,1);
    
            apb_rd( ADDR_THCSR, task_rdata);
            cmp_data( ADDR_THCSR, task_rdata, 32'h0000_0000, 32'hffff_ffff,1);
    
        end
    endtask
	   `include "run_test.v"
    
endmodule
