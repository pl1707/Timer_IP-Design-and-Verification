task run_test;
    reg [63:0] cnt;
    reg [31:0] task_rdata;
    integer pass_err;
    integer err;
    begin
        $display("\n====================================");
        $display("==== Starting Test Suite ====");
        $display("====================================");
        
        pass_err = 0;
        err = 0;
        $display("\n====================================");
        $display("===== Test Case: Check Interrupt ====");
        $display("====================================");
        
        // Đảm bảo trạng thái ban đầu sạch
        test_bench.apb_wr(test_bench.ADDR_TCR, 32'h0);
        test_bench.apb_wr(test_bench.ADDR_TIER, 32'h0);
        test_bench.apb_wr(test_bench.ADDR_TISR, 32'h1);
        test_bench.apb_wr(test_bench.ADDR_TDR0, 32'h0);
        test_bench.apb_wr(test_bench.ADDR_TDR1, 32'h0);
        test_bench.apb_wr(test_bench.ADDR_TCMP0, 32'h0);
        test_bench.apb_wr(test_bench.ADDR_TCMP1, 32'h0);

        // PASS Cases
        $display("\n===================[ ALL PASS CASES ]===================\n");

        // PASS Case: Basic Interrupt Test
        $display("--- PASS Case: Basic Interrupt Test ---");
	test_bench.apb_wr(test_bench.ADDR_TDR0, 32'h0000_00FF);
        test_bench.apb_wr(test_bench.ADDR_TDR1, 32'h0);
        test_bench.apb_wr(test_bench.ADDR_TCMP0, 32'h0000_00FF);
        test_bench.apb_wr(test_bench.ADDR_TCMP1, 32'h0);
        test_bench.apb_wr(test_bench.ADDR_TIER, 32'h1);
        test_bench.apb_wr(test_bench.ADDR_TCR, 32'h1);
        repeat (245) @(posedge test_bench.clk);
        if (test_bench.tim_int === 1) begin
            $display("t=%10d PASS: Interrupt Asserted", $time);
        end else begin
            $display("t=%10d FAIL: Interrupt Not Asserted", $time);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.apb_rd(test_bench.ADDR_TISR, task_rdata);
        if (task_rdata === 32'h1) begin
            $display("t=%10d PASS: TISR Expected=0x1, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TISR Expected=0x1, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TISR, task_rdata, 32'h1, 32'h0000_0001, 1);



    

        // Kết quả test
        $display("\n======================================");
        if (pass_err != 0)
            $display("Test_result FAILED with %d PASS case errors", pass_err);
        else
            $display("Test_result PASSED");
        $display("Total errors (including FAIL cases for coverage): %d", err);
        $display("======================================");
    end
endtask
