task run_test();
    reg [31:0]  task_rdata;
    begin
  	    
        $display("====================================");	
  	$display("====== Test Case: check RW  ========");
  	$display("====================================");	
        
	$display("*** TCR ***");
        test_bench.apb_wr(ADDR_TCR, 0);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TCR, task_rdata);
        if (task_rdata === 32'h0) begin
            $display("t=%10d PASS: TCR Expected=0x0, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TCR Expected=0x0, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h0, 32'hffff_ffff,1);
        


        test_bench.apb_wr(ADDR_TCR, 32'ha55a_a55a);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h0000_0502, 32'hffff_ffff,1);

	test_bench.apb_wr(ADDR_TCR, 32'h5555_5555);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h0000_0501, 32'hffff_ffff,1);

        
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0800);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TCR, task_rdata);
        if (task_rdata === 32'h0000_0800) begin
            $display("t=%10d PASS: TCR Expected=0x0000_0800, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TCR Expected=0x0000_0800, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h0000_0800, 32'hffff_ffff,1);

	test_bench.apb_wr(ADDR_TCR, 32'h0000_0900);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TCR, task_rdata);
        if (task_rdata === 32'h0000_0800) begin
            $display("t=%10d PASS: TCR Expected=0x0000_0800, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TCR Expected=0x0000_0800, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h0000_0800, 32'hffff_ffff,1);
	test_bench.apb_wr(ADDR_TCR, 0);
	//test_bench.apb_wr(ADDR_TISR, 32'hffff_ffff);




        $display("*** TDR0 ***");
        test_bench.apb_wr(ADDR_TDR0, 0);
        test_bench.apb_rd( ADDR_TDR0, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TDR0, task_rdata);
        if (task_rdata === 32'h0000_0000) begin
            $display("t=%10d PASS: TDR0 Expected=0x0000_0000, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR0 Expected=0x0000_0000, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h0, 32'hffff_ffff,1);
        
        test_bench.apb_wr(ADDR_TDR0, 32'hffff_ffff);
        test_bench.apb_rd( ADDR_TDR0, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TDR0, task_rdata);
        if (task_rdata === 32'hffff_ffff) begin
            $display("t=%10d PASS: TDR0 Expected=32'hffff_ffff, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR0 Expected=32'hffff_ffff, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'hffff_ffff, 32'hffff_ffff,1);

        test_bench.apb_wr(ADDR_TDR0, 32'ha55a_a55a);
        test_bench.apb_rd( ADDR_TDR0, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TDR0, task_rdata);
        if (task_rdata === 32'ha55a_a55a) begin
            $display("t=%10d PASS: TDR0 Expected=32'ha55a_a55a, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR0 Expected=32'ha55a_a55a, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'ha55a_a55a, 32'hffff_ffff,1);


	
        $display("*** TDR1 ***");
        test_bench.apb_wr(ADDR_TDR1, 0);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);
        test_bench.apb_rd(test_bench.ADDR_TDR1, task_rdata);
        if (task_rdata === 32'h0) begin
            $display("t=%10d PASS: TDR1 Expected=32'h0, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR1 Expected=32'h0, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h0, 32'hffff_ffff,1);

        test_bench.apb_wr(ADDR_TDR1, 32'hffff_ffff);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TDR1, task_rdata);
        if (task_rdata === 32'hffff_ffff) begin
            $display("t=%10d PASS: TDR1 Expected=32'hffff_ffff, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR1 Expected=32'hffff_ffff, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'hffff_ffff, 32'hffff_ffff,1);

        test_bench.apb_wr(ADDR_TDR1, 32'ha55a_a55a);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TDR1, task_rdata);
        if (task_rdata === 32'ha55a_a55a) begin
            $display("t=%10d PASS: TDR1 Expected=32'ha55a_a55a, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR1 Expected=32'ha55a_a55a, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'ha55a_a55a, 32'hffff_ffff,1);



        $display("*** TCMP0 ***");
        test_bench.apb_wr(ADDR_TCMP0, 0);
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TCMP0, task_rdata);
        if (task_rdata === 32'h0) begin
            $display("t=%10d PASS: ADDR_TCMP0 Expected=32'h0, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TCMP0 Expected=32'h0, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'h0, 32'hffff_ffff,1);
        
        test_bench.apb_wr(ADDR_TCMP0, 32'hffff_ffff);
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TCMP0, task_rdata);
        if (task_rdata === 32'hffff_ffff) begin
            $display("t=%10d PASS: ADDR_TCMP0 Expected=32'hffff_ffff, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TCMP0 Expected=32'hffff_ffff, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'hffff_ffff, 32'hffff_ffff,1);

        test_bench.apb_wr(ADDR_TCMP0, 32'ha55a_a55a);
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TCMP0, task_rdata);
        if (task_rdata === 32'ha55a_a55a) begin
            $display("t=%10d PASS: ADDR_TCMP0 Expected=32'ha55a_a55a, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TCMP0 Expected=32'ha55a_a55a, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'ha55a_a55a, 32'hffff_ffff,1);
	


        $display("*** TCMP1 ***");
        test_bench.apb_wr(ADDR_TCMP1, 0);
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TCMP1, task_rdata);
        if (task_rdata === 32'h0) begin
            $display("t=%10d PASS: ADDR_TCMP1 Expected=32'h0, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TCMP1 Expected=32'h0, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'h0, 32'hffff_ffff,1);
        
        test_bench.apb_wr(ADDR_TCMP1, 32'hffff_ffff);
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TCMP1, task_rdata);
        if (task_rdata === 32'hffff_ffff) begin
            $display("t=%10d PASS: ADDR_TCMP1 Expected=32'hffff_ffff, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TCMP1 Expected=32'hffff_ffff, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'hffff_ffff, 32'hffff_ffff,1);

        test_bench.apb_wr(ADDR_TCMP1, 32'ha55a_a55a);
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TCMP1, task_rdata);
        if (task_rdata === 32'ha55a_a55a) begin
            $display("t=%10d PASS: ADDR_TCMP1 Expected=32'ha55a_a55a, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TCMP1 Expected=32'ha55a_a55a, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'ha55a_a55a, 32'hffff_ffff,1);
	
	

	$display("*** TIER ***");
        test_bench.apb_wr(ADDR_TIER, 0);
        test_bench.apb_rd( ADDR_TIER, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TIER, task_rdata);
        if (task_rdata === 32'h0) begin
            $display("t=%10d PASS: ADDR_TIER Expected=32'h0, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TIER Expected=32'h0, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h0, 32'hffff_ffff,1);
        
        test_bench.apb_wr(ADDR_TIER, 32'hffff_ffff);
        test_bench.apb_rd( ADDR_TIER, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TIER, task_rdata);
        if (task_rdata === 32'h1) begin
            $display("t=%10d PASS: ADDR_TIER Expected=32'h1, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TIER Expected=32'h1, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h1, 32'hffff_ffff,1);

        test_bench.apb_wr(ADDR_TIER, 32'ha55a_a55a);
        test_bench.apb_rd( ADDR_TIER, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TIER, task_rdata);
        if (task_rdata === 32'h0) begin
            $display("t=%10d PASS: ADDR_TIER Expected=32'h0, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TIER Expected=32'h0, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h0, 32'hffff_ffff,1);

      
	test_bench.apb_wr(ADDR_TISR, 32'h0000_0001);
	test_bench.apb_rd( ADDR_TISR, task_rdata);
        $display("*** TISR ***");
        test_bench.apb_wr(ADDR_TISR, 32'hffff_ffff);
        test_bench.apb_rd( ADDR_TISR, task_rdata);
	test_bench.apb_rd(test_bench.ADDR_TISR, task_rdata);
        if (task_rdata === 32'h1) begin
            $display("t=%10d PASS: ADDR_TISR Expected=32'h1, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: ADDR_TISR Expected=32'h1, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        //test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h0, 32'hffff_ffff,1);
       
	
	
        #100;
        $display("assert reset");

        test_bench.rst_n = 1'b0;
        #100;
        @(posedge test_bench.clk);
        #1;
        $display("release reset");
        rst_n = 1'b1;

        $display("check reg init");
        test_bench.reg_init_chk;


        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
