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
        $display("====== Test Case: Check One Hot ====");
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

        // PASS Case: Write and read TCR (timer_en, div_en, div_val)
        $display("--- PASS Case: TCR One-Hot Behavior ---");
        test_bench.apb_wr(test_bench.ADDR_TCR, 32'h0000_0103); // timer_en=1, div_en=1, div_val=1
        test_bench.apb_rd(test_bench.ADDR_TCR, task_rdata);
        if (task_rdata === 32'h0000_0103) begin
            $display("t=%10d PASS: TCR Expected=0x00000103, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TCR Expected=0x00000103, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TCR, task_rdata, 32'h0000_0103, 32'h0000_0F03,1);

        // PASS Case: Write and read TIER
        $display("\n--- PASS Case: TIER One-Hot Behavior ---");
        test_bench.apb_wr(test_bench.ADDR_TIER, 32'h0000_0001); // int_en=1
        test_bench.apb_rd(test_bench.ADDR_TIER, task_rdata);
        if (task_rdata === 32'h0000_0001) begin
            $display("t=%10d PASS: TIER Expected=0x00000001, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TIER Expected=0x00000001, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TIER, task_rdata, 32'h0000_0001, 32'h0000_0001,1);

        // PASS Case: Write and read TISR (RW1C)
        $display("\n--- PASS Case: TISR One-Hot Behavior ---");
        test_bench.apb_wr(test_bench.ADDR_TISR, 32'h0000_0001); // Clear int_st
        test_bench.apb_rd(test_bench.ADDR_TISR, task_rdata);
        if (task_rdata === 32'h0000_0000) begin
            $display("t=%10d PASS: TISR Expected=0x00000000, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TISR Expected=0x00000000, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TISR, task_rdata, 32'h0000_0000, 32'h0000_0001,1);

        /* PASS Case: Write and read TDR0
        $display("\n--- PASS Case: TDR0 Write/Read ---");
        test_bench.apb_wr(test_bench.ADDR_TDR0, 32'h1234_5678);
        test_bench.apb_rd(test_bench.ADDR_TDR0, task_rdata);
        if (task_rdata === 32'h1234_5678) begin
            $display("t=%10d PASS: TDR0 Expected=0x12345679, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR0 Expected=0x12345679, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TDR0, task_rdata, 32'h1234_5679, 32'hFFFF_FFFF,1);*/

        // PASS Case: Write and read TDR1
        $display("\n--- PASS Case: TDR1 Write/Read ---");
        test_bench.apb_wr(test_bench.ADDR_TDR1, 32'h8765_4321);
        test_bench.apb_rd(test_bench.ADDR_TDR1, task_rdata);
        if (task_rdata === 32'h8765_4321) begin
            $display("t=%10d PASS: TDR1 Expected=0x87654321, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TDR1 Expected=0x87654321, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TDR1, task_rdata, 32'h8765_4321, 32'hFFFF_FFFF,1);

        // PASS Case: Write and read TCMP0
        $display("\n--- PASS Case: TCMP0 Write/Read ---");
        test_bench.apb_wr(test_bench.ADDR_TCMP0, 32'hAAAA_AAAA);
        test_bench.apb_rd(test_bench.ADDR_TCMP0, task_rdata);
        if (task_rdata === 32'hAAAA_AAAA) begin
            $display("t=%10d PASS: TCMP0 Expected=0xAAAAAAAA, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TCMP0 Expected=0xAAAAAAAA, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TCMP0, task_rdata, 32'hAAAA_AAAA, 32'hFFFF_FFFF,1);

        // PASS Case: Write and read TCMP1
        $display("\n--- PASS Case: TCMP1 Write/Read ---");
        test_bench.apb_wr(test_bench.ADDR_TCMP1, 32'h5555_5555);
        test_bench.apb_rd(test_bench.ADDR_TCMP1, task_rdata);
        if (task_rdata === 32'h5555_5555) begin
            $display("t=%10d PASS: TCMP1 Expected=0x55555555, Actual=0x%h", $time, task_rdata);
        end else begin
            $display("t=%10d FAIL: TCMP1 Expected=0x55555555, Actual=0x%h", $time, task_rdata);
            pass_err = pass_err + 1;
            err = err + 1;
        end
        test_bench.cmp_data(test_bench.ADDR_TCMP1, task_rdata, 32'h5555_5555, 32'hFFFF_FFFF,1);

        
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