task run_test();
	reg [31:0] task_rdata;
	begin
		$display("====================================");
	  	$display("====== Test Case: check Reserved  ========");
  		$display("====================================");
		test_bench.apb_wr(32'hffff_ffff,32'hffff_1234);
        	test_bench.apb_rd(32'hffff_ffff, task_rdata);
    		test_bench.cmp_data(32'hffff_ffff, task_rdata, 32'h0, 32'hffff_ffff);
		if( test_bench.err != 0 )
        		 $display("Test_result FAILED");
	        else 
           		 $display("Test_result PASSED");

    end

    endtask
