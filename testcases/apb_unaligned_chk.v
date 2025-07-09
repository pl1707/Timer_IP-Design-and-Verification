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
        $display("=== Test Case: APB Un-aligned Test ===");
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

        // PASS Case: Unaligned access (expect RAZ)
        $display("\n--- PASS Case: Unaligned Access ---");
        test_bench.apb_wr(test_bench.ADDR_TDR0 + 1, 32'h5555_5555);
        test_bench.apb_rd(test_bench.ADDR_TDR0 + 1, task_rdata);
        if (task_rdata === 32'h0000_0000) begin
            $display("t=%10d PASS: TDR0+1 Expected=0x00000000, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR0+1 Expected=0x00000000, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TDR0 + 1, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF, 1);

        // PASS Case: Unaligned access (expect RAZ)
        $display("\n--- PASS Case: Unaligned Access ---");
        test_bench.apb_wr(test_bench.ADDR_TDR0 + 2, 32'h6666_6666);
        test_bench.apb_rd(test_bench.ADDR_TDR0 + 2, task_rdata);
        if (task_rdata === 32'h0000_0000) begin
            $display("t=%10d PASS: TDR0+2 Expected=0x00000000, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR0+2 Expected=0x00000000, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TDR0 + 2, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF, 1);
        

        // PASS Case: Unaligned access (expect RAZ)
        $display("\n--- PASS Case: Unaligned Access ---");
        test_bench.apb_wr(test_bench.ADDR_TDR0 + 3, 32'h7777_7777);
        test_bench.apb_rd(test_bench.ADDR_TDR0 + 3, task_rdata);
        if (task_rdata === 32'h0000_0000) begin
            $display("t=%10d PASS: TDR0+3 Expected=0x00000000, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR0+3 Expected=0x00000000, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TDR0 + 3, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF, 1);

       

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