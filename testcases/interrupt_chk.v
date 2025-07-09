task run_test();
    reg [31:0] task_rdata;
    begin
        $display("====================================");
        $display("====== Test Case: check Interrupt with Pass/Fail Detection  ========");
        $display("====================================");
        
        // Pass case: Trigger interrupt
        $display("*** Pass: Interrupt Trigger Test ***");
        test_bench.apb_wr(ADDR_TCMP0, 32'h0000_0010); // Set compare value
        test_bench.apb_wr(ADDR_TCMP1, 32'h0000_0000);
        test_bench.apb_wr(ADDR_TIER, 32'h0000_0001); // Enable interrupt
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0001); // Start timer
        #1000;
        test_bench.apb_rd(ADDR_TISR, task_rdata);
        test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h0000_0001, 32'h0000_0001); // Expect interrupt set

        // Pass case: Clear interrupt
        $display("*** Pass: Interrupt Clear Test ***");
        test_bench.apb_wr(ADDR_TISR, 32'h0000_0001); // Clear int_st
        test_bench.apb_rd(ADDR_TISR, task_rdata);
        test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h0000_0000, 32'h0000_0001); // Expect cleared

        // Fail case: Clear interrupt when not set
        $display("*** Fail: Clear Interrupt When Not Set ***");
        test_bench.apb_wr(ADDR_TISR, 32'h0000_0001); // Try to clear again
        test_bench.apb_rd(ADDR_TISR, task_rdata);
        test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h0000_0000, 32'h0000_0001); // Expect no change

        // Fail case: Write to reserved bits in TISR
        $display("*** Fail: Write to Reserved Bits ***");
        test_bench.apb_wr(ADDR_TISR, 32'hFFFF_FFFF); // Write to reserved bits
        test_bench.apb_rd(ADDR_TISR, task_rdata);
        test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h0000_0000, 32'h0000_0001); // Expect no change

        if (test_bench.err != 0)
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask