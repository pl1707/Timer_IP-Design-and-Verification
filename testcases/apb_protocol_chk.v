task run_test();
    reg [31:0] task_rdata;
    begin
        $display("====================================");
        $display("====== Test Case: check APB Protocol with Pass/Fail Detection  ========");
        $display("====================================");
        
        // Pass case: Valid APB write and read
        $display("*** Pass: Valid APB Protocol Test ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0101);
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0101, 32'h0000_0F03);

        // Fail case: Write without psel
        $display("*** Fail: Write Without PSEL ***");
        test_bench.apb_err_psel = 1; // Disable psel
        test_bench.apb_wr(ADDR_TDR0, 32'h1234_5678);
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect no change
        test_bench.apb_err_psel = 0; // Reset error condition

        // Fail case: Read without penable
        $display("*** Fail: Read Without PENABLE ***");
        test_bench.apb_err_penable = 1; // Disable penable
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect no change
        test_bench.apb_err_penable = 0; // Reset error condition

        // Pass case: Valid access after error
        $display("*** Pass: Valid Access After Error ***");
        test_bench.apb_wr(ADDR_TDR0, 32'h1234_5678);
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h1234_5678, 32'hFFFF_FFFF);

        if (test_bench.err != 0)
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask