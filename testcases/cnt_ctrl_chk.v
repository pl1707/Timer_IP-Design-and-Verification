task run_test();
    reg [31:0] task_rdata;
    reg [31:0] prev_rdata;
    begin
        $display("====================================");
        $display("====== Test Case: check Counter Control with Pass/Fail Detection  ========");
        $display("====================================");
        
        // Pass case: Default mode (timer_en = 1, div_en = 0)
        $display("*** Pass: Default Mode Test ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0001); // timer_en = 1
        #100;
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect count started
        prev_rdata = task_rdata;

        // Pass case: Control mode (div_val = 1, divide by 2)
        $display("*** Pass: Control Mode Test (div_val = 1) ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0103); // timer_en = 1, div_en = 1, div_val = 1
        #200;
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect slower count

        // Fail case: Invalid div_val
        $display("*** Fail: Invalid div_val ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0903); // Try div_val = 9
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0103, 32'h0000_0F03); // Expect no change

        // Pass case: Control mode (div_val = 8, divide by 256)
        $display("*** Pass: Control Mode Test (div_val = 8) ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0803); // timer_en = 1, div_en = 1, div_val = 8
        #1000;
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hFFFF_FFFF); // Expect very slow count
        prev_rdata = task_rdata;

        // Fail case: Counter active when timer_en = 0
        $display("*** Fail: Counter Active When Disabled ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0000); // timer_en = 0
        #100;
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        test_bench.cmp_data(ADDR_TDR0, task_rdata, prev_rdata, 32'hFFFF_FFFF); // Expect no change

        if (test_bench.err != 0)
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask