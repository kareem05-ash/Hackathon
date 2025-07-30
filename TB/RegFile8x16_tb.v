`timescale 1ns/1ps
module RegFile8x16_tb;
    // DUT Parameters
        parameter WIDTH = 8;
        parameter DEPTH = 16;
        parameter addressbits = 16; 
    // Needed Parameters
        parameter clk_period = 10;          // to maintain 50 MHZ clk frequency
    // DUT Inputs
        reg clk;
        reg rst;                            //active low rst to reset all regs to 0
        reg wrEN;                           //signal to write to a specified reg
        reg [addressbits-1:0] address;      //address of the desired reg
        reg [DEPTH-1:0] wrData;             //data to be writen to a reg
    // Needed Signals
        integer i;                          // needed for loops
        integer succeeded_cases = 0;        // to count succeeded test cases
        integer all_cases = DEPTH + 5;      // all test cases
    // DUT Instantiation
        RegFile8x16#(
            .WIDTH(WIDTH), 
            .DEPTH(DEPTH), 
            .addressbits(addressbits)
        )
        DUT(
            .clk(clk), 
            .rst(rst), 
            .wrEN(wrEN), 
            .address(address), 
            .wrData(wrData)
        );
    // CLK Generation
        initial begin
            clk = 0;        //initial value
            forever #clk_period clk = ~clk;
        end 
    // TASKs
        // reset task
            task reset(); begin
                rst = 1;        // activate reset signal
                wrEN = 0;       // default value
                address = 0;    // default value
                wrData = 0;     // default value
                repeat(2)       // waits for 2 clk cycles to track rst signal
                    @(negedge clk);
                rst = 0;        // release reset signal
            end
            endtask
    // Testing
        initial begin
            // 1st scenario : Functional Correctness (Reset Behavior)
                $display("\n==================== 1st scenario : Functional Correctness (Reset Behavior) ====================");
                reset();
                for(i=0; i<DEPTH; i=i+1) begin
                    if(DUT.REG[i] == 0) begin
                        succeeded_cases = succeeded_cases + 1;  // another test case passes
                        $display("[PASS] 1st scenario : Functional Correctness (Reset Behavior) | REG [%d] = %0h, expected = 0", i, DUT.REG[i]);
                    end else begin
                        $display("[FAIL] 1st scenario : Functional Correctness (Reset Behavior) | REG [%d] = %0h, expected = 0", i, DUT.REG[i]);
                    end
                end

            // 2nd scenario : Functional Correctness (Write on a register in a specified address)
                $display("\n==================== 2nd scenario : Functional Correctness (Write on a register in a specified address) ====================");
                reset();
                wrEN = 1;           // enables write operation
                address = 5;        // choose REG[5] to write in it 
                wrData = 20;        // write 20 to REG[5]
                @(negedge clk);     // waits for a clc cycle to track singals
                if(DUT.REG[5] == 20) begin
                    succeeded_cases = succeeded_cases + 1;      // another test case passes
                    $display("[PASS] 2nd scenario : Functional Correctness (Write on a register in a specified address) | REG [5] = %d, expected = %d", 
                            DUT.REG[5], wrData);
                end else begin
                    $display("[FAIL] 2nd scenario : Functional Correctness (Write on a register in a specified address) | REG [5] = %d, expected = %d", 
                            DUT.REG[5], wrData);
                end 

            // 3rd scenario : Functional Correctness (Reset just after Write operation)
                $display("\n==================== 3rd scenario : Functional Correctness (Reset just after Write operation) ====================");
                reset();    
                wrEN = 1;           // enables write operation
                address = 10;       // choose REG[5] to write in it 
                wrData = 16'h23;    // write hex(23) to REG[10]
                @(negedge clk);     // waits for a clc cycle to track singals
                reset();            // reset just after write operation to test bahavior
                if(DUT.REG [10] == 0) begin
                    succeeded_cases = succeeded_cases + 1;      // acother test case passes
                    $display("[PASS] 3rd scenario : Functional Correctness (Reset just after Write operation) | REG [10] = %d, expected = %d", 
                            DUT.REG [10], wrData);
                end
                else begin
                    $display("[FAIL] 3rd scenario : Functional Correctness (Reset just after Write operation) | REG [10] = %d, expected = %d", 
                            DUT.REG [10], wrData);
                end

            // 4th scenario : Corner Case (Write to the same REG 2 times [check overwrite])
                $display("\n==================== 4th scenario : Corner Case (Write to the same REG 2 times [check overwrite]) ====================");
                reset(); 
                // first write
                wrEN = 1;           // enables write operation
                address = 0;        // choose REG[0] to write in it 
                wrData = 16'h23;    // write hex(23) to REG[10]
                @(negedge clk);     // waits for a clc cycle to track singals
                // second write
                wrEN = 1;           // enables write operation
                address = 0;        // choose REG[0] to write in it 
                wrData = 16'h11;    // write hex(11) to REG[0]
                @(negedge clk);     // waits for a clc cycle to track singals
                // check if it stores the new value
                if(DUT.REG [0] == 16'h11) begin
                    succeeded_cases = succeeded_cases + 1;      // acother test case passes
                    $display("[PASS] 4th scenario : Corner Case (Write to the same REG 2 times [check overwrite]) | REG [0] = %d, expected = %d", 
                            DUT.REG [0], wrData);
                end
                else begin
                    $display("[FAIL] 34th scenario : Corner Case (Write to the same REG 2 times [check overwrite]) | REG [0] = %d, expected = %d", 
                            DUT.REG [0], wrData);
                end

            // 5th scenario : Corner Case (Write FF to the last REG)
                $display("\n==================== 5th scenario : Corner Case (Write FF to the last REG) ====================");
                reset(); 
                wrEN = 1;           // enables write operation
                address = DEPTH-1;  // choose REG[DEPTH-1] to write in it 
                wrData = 16'hFF;    // write hex(FF) to REG[DEPTH-1]
                @(negedge clk);     // waits for a clc cycle to track singals
                if(DUT.REG [DEPTH-1] == 16'hFF) begin
                    succeeded_cases = succeeded_cases + 1;      // acother test case passes
                    $display("[PASS] 5th scenario : Corner Case (Write FF to the last REG) | REG [%d-1] = %d, expected = %d", 
                            DEPTH, DUT.REG [DEPTH-1], wrData);
                end
                else begin
                    $display("[FAIL] 5th scenario : Corner Case (Write FF to the last REG) | REG [%d-1] = %d, expected = %d", 
                            DEPTH, DUT.REG [DEPTH-1], wrData);
                end

            // 6th scenario : Corner Case (Write 00 to the last REG)
                $display("\n==================== 6th scenario : Corner Case (Write 00 to the last REG) ====================");
                reset(); 
                wrEN = 1;           // enables write operation
                address = DEPTH;    // choose REG[DEPTH] to write in it 
                wrData = 16'h00;    // write hex(00) to REG[DEPTH]
                @(negedge clk);     // waits for a clc cycle to track singals
                if(DUT.REG [0] == 16'h00) begin
                    succeeded_cases = succeeded_cases + 1;      // acother test case passes
                    $display("[PASS] 6th scenario : Corner Case (Write 00 to the last REG) | REG [0] = %d, expected = %d", 
                            DUT.REG [0], wrData);
                end
                else begin
                    $display("[FAIL] 6th scenario : Corner Case (Write 00 to the last REG) | REG [0] = %d, expected = %d", 
                            DUT.REG [0], wrData);
                end
            // STOP Simulation
                $display("\n==================== Finish Simulation ====================");
                $display("Succeeded Test Cases = %d\n All Tests = %d", succeeded_cases, all_cases);
                #100;   // wait some time units
                $stop;
        end
endmodule