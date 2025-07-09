task run_test();
    reg [31:0] task_rdata;
    reg [31:0] prev_rdata;
    begin
        $display("====================================");
        $display("====== Test Case: check Counter Counting with Pass/Fail Detection  ========");
        $display("====================================");
        
        // Pass case: Default mode counting
        $display("*** Pass: Default Mode Counting Test ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0001); // timer_en = 1
        #100;
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect count started
        prev_rdata = task_rdata;

        // Fail case: Counter active when timer_en = 0
        $display("*** Fail: Counter Active When Disabled ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0000); // timer_en = 0
        #100;
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, prev_rdata, 32'hFFFF_FFFF); // Expect no change
        prev_rdata = task_rdata;

        // Pass case: Control mode (div_val = 2, divide by 4)
        $display("*** Pass: Control Mode Counting Test (div_val = 2) ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0203); // timer_en = 1, div_en = 1, div_val = 2
        #400;
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect slower count

        // Fail case: Invalid div_val
        $display("*** Fail: Invalid div_val ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0903); // Try div_val = 9
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0203, 32'h0000_0F03); // Expect no change

        if (test_bench.err != 0)
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask