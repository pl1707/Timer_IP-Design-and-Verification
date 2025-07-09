task run_test();
	reg[31:0] task_rdata;
	begin
		$display("====================================");
  		$display("====== Test Case: check Reset Value  ========");
  		$display("====================================");
		test_bench.reg_init_chk();
		$display("====================================");
		$display("====== Test Case: check Reset after write  ========");
		test_bench.apb_wr(ADDR_TCR, 32'hffff_ffff);
		test_bench.apb_wr(ADDR_TDR0, 32'hffff_ffff);
        	test_bench.apb_wr(ADDR_TDR1, 32'hffff_ffff);
		test_bench.apb_wr(ADDR_TCMP0, 32'hffff_ffff);
		test_bench.apb_wr(ADDR_TCMP1, 32'hffff_ffff);
		test_bench.apb_wr(ADDR_TIER, 32'hffff_ffff);
		test_bench.apb_wr(ADDR_TISR, 32'hffff_ffff);
		test_bench.apb_rd( ADDR_TCR, task_rdata);
		test_bench.apb_rd( ADDR_TDR0, task_rdata);
		test_bench.apb_rd( ADDR_TDR1, task_rdata);
		test_bench.apb_rd( ADDR_TCMP0, task_rdata);
		test_bench.apb_rd( ADDR_TCMP1, task_rdata);
		test_bench.apb_rd( ADDR_TIER, task_rdata);
		test_bench.apb_rd( ADDR_TISR, task_rdata);
		test_bench.rst_n = 0;
		#10 test_bench.rst_n = 1;
		test_bench.reg_init_chk();
		if( test_bench.err != 0 )
     		       $display("Test_result FAILED");
        	else
    	        	$display("Test_result PASSED");

	end
endtask

