task run_test;
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
        $display("=== Test Case: APB Multiple Access ===");
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

        // PASS Case: Multiple writes and reads
        $display("--- PASS Case: Multiple Writes and Reads ---");
        test_bench.apb_wr(test_bench.ADDR_TCR, 32'h0000_0101);
        test_bench.apb_wr(test_bench.ADDR_TDR0, 32'h1111_1111);
        test_bench.apb_wr(test_bench.ADDR_TDR1, 32'h2222_2222);
        test_bench.apb_wr(test_bench.ADDR_TCMP0, 32'h3333_3333);
        test_bench.apb_wr(test_bench.ADDR_TCMP1, 32'h4444_4444);
        test_bench.apb_wr(test_bench.ADDR_TIER, 32'h0000_0001);
        test_bench.apb_rd(test_bench.ADDR_TCR, task_rdata);
        if (task_rdata === 32'h0000_0101) begin
            $display("t=%10d PASS: TCR Expected=0x00000101, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TCR Expected=0x00000101, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TCR, task_rdata, 32'h0000_0101, 32'h0000_0F03, 1);
       
        test_bench.apb_rd(test_bench.ADDR_TDR1, task_rdata);
        if (task_rdata === 32'h2222_2222) begin
            $display("t=%10d PASS: TDR1 Expected=0x22222222, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR1 Expected=0x22222222, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TDR1, task_rdata, 32'h2222_2222, 32'hFFFF_FFFF, 1);
        test_bench.apb_rd(test_bench.ADDR_TCMP0, task_rdata);
        if (task_rdata === 32'h3333_3333) begin
            $display("t=%10d PASS: TCMP0 Expected=0x33333333, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TCMP0 Expected=0x33333333, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TCMP0, task_rdata, 32'h3333_3333, 32'hFFFF_FFFF, 1);
        test_bench.apb_rd(test_bench.ADDR_TCMP1, task_rdata);
        if (task_rdata === 32'h4444_4444) begin
            $display("t=%10d PASS: TCMP1 Expected=0x44444444, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TCMP1 Expected=0x44444444, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TCMP1, task_rdata, 32'h4444_4444, 32'hFFFF_FFFF, 1);
        test_bench.apb_rd(test_bench.ADDR_TIER, task_rdata);
        if (task_rdata === 32'h0000_0001) begin
            $display("t=%10d PASS: TIER Expected=0x00000001, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TIER Expected=0x00000001, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TIER, task_rdata, 32'h0000_0001, 32'h0000_0001, 1);

        // PASS Case: Sequential write-read TISR
        $display("\n--- PASS Case: TISR Write/Read ---");
        test_bench.apb_wr(test_bench.ADDR_TISR, 32'h0000_0001);
        test_bench.apb_rd(test_bench.ADDR_TISR, task_rdata);
        if (task_rdata === 32'h0000_0000) begin
            $display("t=%10d PASS: TISR Expected=0x00000000, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TISR Expected=0x00000000, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TISR, task_rdata, 32'h0000_0000, 32'h0000_0001, 1);

     

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