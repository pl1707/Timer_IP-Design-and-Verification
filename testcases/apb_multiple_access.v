task run_test();
    reg [31:0] task_rdata;
    begin
        $display("====================================");
        $display("====== Test Case: check APB Multiple Access with Pass/Fail Detection  ========");
        $display("====================================");
        
        // Pass case: Sequential writes to multiple registers
        $display("*** Pass: Sequential Write Test ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0101);
        test_bench.apb_wr(ADDR_TDR0, 32'h1234_5678);
        test_bench.apb_wr(ADDR_TDR1, 32'h8765_4321);
        test_bench.apb_wr(ADDR_TCMP0, 32'hAAAA_AAAA);
        test_bench.apb_wr(ADDR_TCMP1, 32'h5555_5555);

        // Pass case: Sequential reads to verify
        $display("*** Pass: Sequential Read Test ***");
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0101, 32'h0000_0F03);
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h1234_5678, 32'hFFFF_FFFF);
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        test_bench.cmp_data(ADDR_TDR1, task_rdata, 32'h8765_4321, 32'hFFFF_FFFF);
        test_bench.apb_rd(ADDR_TCMP0, task_rdata);
        test_bench.cmp_data(ADDR_TCMP0, task_rdata, 32'hAAAA_AAAA, 32'hFFFF_FFFF);
        test_bench.apb_rd(ADDR_TCMP1, task_rdata);
        test_bench.cmp_data(ADDR_TCMP1, task_rdata, 32'h5555_5555, 32'hFFFF_FFFF);

        // Fail case: Write to invalid address
        $display("*** Fail: Invalid Address Access ***");
        test_bench.apb_wr(32'h0000_0020, 32'hFFFF_FFFF); // Invalid address
        test_bench.apb_rd(32'h0000_0020, task_rdata);
        test_bench.cmp_data(32'h0000_0020, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect RAZ

        // Pass case: Verify valid data unaffected
        $display("*** Pass: Verify Valid Data After Fail ***");
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0101, 32'h0000_0F03);

        if (test_bench.err != 0)
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask