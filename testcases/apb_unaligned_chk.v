task run_test();
    reg [31:0] task_rdata;
    begin
        $display("====================================");
        $display("====== Test Case: check APB Unaligned Access with Pass/Fail Detection  ========");
        $display("====================================");
        
        // Pass case: Write and read valid address
        $display("*** Pass: Valid Address Access ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0101);
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0101, 32'h0000_0F03);

        // Fail case: Unaligned address
        $display("*** Fail: Unaligned Address Test 1 ***");
        test_bench.apb_wr(32'h0000_0001, 32'hFFFF_FFFF); // Misaligned address
        test_bench.apb_rd(32'h0000_0001, task_rdata);
        test_bench.cmp_data(32'h0000_0001, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect RAZ

        // Fail case: Another unaligned address
        $display("*** Fail: Unaligned Address Test 2 ***");
        test_bench.apb_wr(32'h0000_0002, 32'hAAAA_AAAA);
        test_bench.apb_rd(32'h0000_0002, task_rdata);
        test_bench.cmp_data(32'h0000_0002, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect RAZ

        // Fail case: Out-of-range address
        $display("*** Fail: Out-of-Range Address Test ***");
        test_bench.apb_wr(32'h0000_1000, 32'h5555_5555); // Outside 4KB
        test_bench.apb_rd(32'h0000_1000, task_rdata);
        test_bench.cmp_data(32'h0000_1000, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect RAZ

        if (test_bench.err != 0)
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask