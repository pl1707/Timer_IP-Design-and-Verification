task run_test();
    reg [31:0] task_rdata;
    begin
        $display("====================================");
        $display("====== Test Case: check One-Hot with Pass/Fail Detection  ========");
        $display("====================================");
        
        // Pass case: Write and read TCR one-hot values
        $display("*** TCR Pass: One-Hot Test ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0001); // Set timer_en
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0001, 32'h0000_0F03); // Mask: timer_en, div_en, div_val

        test_bench.apb_wr(ADDR_TCR, 32'h0000_0002); // Set div_en
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0002, 32'h0000_0F03);

        test_bench.apb_wr(ADDR_TCR, 32'h0000_0100); // Set div_val = 1
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0100, 32'h0000_0F03);

        // Fail case: Write invalid div_val
        $display("*** TCR Fail: Invalid div_val ***");
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0900); // Try div_val = 9
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0100, 32'h0000_0F03); // Expect no change

        // Fail case: Write to reserved bits
        $display("*** TCR Fail: Write to Reserved Bits ***");
        test_bench.apb_wr(ADDR_TCR, 32'hFFFF_0000); // Write to reserved bits
        test_bench.apb_rd(ADDR_TCR, task_rdata);
        test_bench.cmp_data(ADDR_TCR, task_rdata, 32'h0000_0100, 32'h0000_0F03); // Expect no change

        // Pass case: Write and read TIER
        $display("*** TIER Pass: One-Hot Test ***");
        test_bench.apb_wr(ADDR_TIER, 32'h0000_0001); // Set int_en
        test_bench.apb_rd(ADDR_TIER, task_rdata);
        test_bench.cmp_data(ADDR_TIER, task_rdata, 32'h0000_0001, 32'h0000_0001);

        // Fail case: Write to reserved bits in TIER
        $display("*** TIER Fail: Write to Reserved Bits ***");
        test_bench.apb_wr(ADDR_TIER, 32'hFFFF_FFFE); // Write to reserved bits
        test_bench.apb_rd(ADDR_TIER, task_rdata);
        test_bench.cmp_data(ADDR_TIER, task_rdata, 32'h0000_0001, 32'h0000_0001); // Expect no change

        // Pass case: Read TISR (default 0)
        $display("*** TISR Pass: One-Hot Test ***");
        test_bench.apb_rd(ADDR_TISR, task_rdata);
        test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h0000_0000, 32'h0000_0001);

        // Fail case: Write to reserved bits in TISR
        $display("*** TISR Fail: Write to Reserved Bits ***");
        test_bench.apb_wr(ADDR_TISR, 32'hFFFF_FFFF); // Write to reserved bits
        test_bench.apb_rd(ADDR_TISR, task_rdata);
        test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h0000_0000, 32'h0000_0001); // Expect no change

        // Pass case: Write and read THCSR
        $display("*** THCSR Pass: One-Hot Test ***");
        test_bench.apb_wr(ADDR_THCSR, 32'h0000_0001); // Set halt_req
        test_bench.apb_rd(ADDR_THCSR, task_rdata);
        test_bench.cmp_data(ADDR_THCSR, task_rdata, 32'h0000_0001, 32'h0000_0003);

        // Fail case: Write to reserved bits in THCSR
        $display("*** THCSR Fail: Write to Reserved Bits ***");
        test_bench.apb_wr(ADDR_THCSR, 32'hFFFF_FFFC); // Write to reserved bits
        test_bench.apb_rd(ADDR_THCSR, task_rdata);
        test_bench.cmp_data(ADDR_THCSR, task_rdata, 32'h0000_0001, 32'h0000_0003); // Expect no change

        if (test_bench.err != 0)
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask