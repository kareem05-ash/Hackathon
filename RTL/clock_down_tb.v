///////////////////////////////////////////////////////////
// Kareem Ashraf Mostafa
// kareem.ash05@gmail.com
// 01002321067
// github.com/kareem05-ash
///////////////////////////////////////////////////////////
`timescale 1ns/1ps
module clock_down_tb();

    reg i_clk;                          //active-high clk isgnal to be divided
    reg i_rst;                          //async. active-high rst signal
    reg [15:0] i_divisor;               //divisor from reg_file
    wire o_slow_clk;                    //divided clk signal. It can be down clocked at most (1/(2^16 - 1)) of original frequency   

    // DUT Instantiation
    clock_down DUT(
        .i_clk(i_clk), 
        .i_rst(i_rst), 
        .i_divisor(i_divisor), 
        .o_slow_clk(o_slow_clk)
    );

    // CLK Generation
    initial
        begin
            i_clk = 0;          //initial value to avoid unknown i_clk signal
            // i_clk signal with frequency 50 MHZ 
            forever # 10 i_clk = ~i_clk;
        end

    // TASKs
    // reset task
    task reset();
        begin
            i_rst = 1;          //activate i_rst
            i_divisor = 0;      //initial value
            repeat(30)          //waits for 30 i_clk cycles to track i_rst signal
                @(negedge i_clk);
            i_rst = 0;          //release i_rst
        end
    endtask     

    initial                     //Test Scenarios & Corner Cases
        begin
                                //1st scenario Functional Correctness (Reset Behavior)
            $display("\n=================== 1st scenario Functional Correctness (Reset Behavior) ====================");
            reset();            //now, o_slow_clk = 0
            if(!o_slow_clk && DUT.count == 0)
                $display("[PASS] 1st scenario Functional Correctness (Reset Behavior)");
            else
                $display("[FAIL] 1st scenario Functional Correctness (Reset Behavior) : o_slow_clk = %d, count = %d", o_slow_clk, DUT.count);


                                //2nd scenario Functional Correctness (even i_divisor = 4)
            $display("\n=================== 2nd scenario Functional Correctness (even i_divisor = 4) ====================");
            reset();            //now, o_slow_clk = 0
            i_divisor = 4;      //even divisor
            repeat(4/2)         //now, o_slow_clk should be 1 
                @(negedge i_clk);
            if(o_slow_clk)
                $display("[PASS] 2nd scenario Functional Correctness (even i_divisor = 4)");
            else    
                $display("[FAIL] 2nd scenario Functional Correctness (even i_divisor = 4) : o_slow_clk = %d, expected = 1", o_slow_clk);
            repeat(4/2)         //now, o_slow_clk should be 0
                @(negedge i_clk);
            if(!o_slow_clk)
                $display("[PASS] 2nd scenario Functional Correctness (even i_divisor = 4)");
            else    
                $display("[FAIL] 2nd scenario Functional Correctness (even i_divisor = 4) : o_slow_clk = %d, expected = 0", o_slow_clk);


                                //3rd scenario Fuctional Correctness (odd i_divisor = 5)
            $display("\n=================== 3rd scenario Fuctional Correctness (odd i_divisor = 5) ====================");
            reset();            //now, o_slow_clk = 0
            i_divisor = 5;      //odd divisor
            repeat(((5-1)/2) + 1)   //waits for i_divisor_shifted + 1 i_clk cycles to maintain posedeg of o_slow_clk
                @(negedge i_clk);
            if(o_slow_clk)
                $display("[PASS] 3rd scenario Fuctional Correctness (odd i_divisor = 5)");
            else    
                $display("[FAIL] 3rd scenario Fuctional Correctness (odd i_divisor = 5) : o_slow_clk = %d, expected = 1", o_slow_clk);
            repeat((5-1)/2)     //waits for i_divisor_shifted i_clk cycles to maintain negedge of o_slow_clk
                @(negedge i_clk);
            if(!o_slow_clk)
                $display("[PASS] 3rd scenario Fuctional Correctness (odd i_divisor = 5)");
            else    
                $display("[FAIL] 3rd scenario Fuctional Correctness (odd i_divisor = 5) : o_slow_clk = %d, expected = 0", o_slow_clk);


                                //4th scenario Corner Case (Error Handling : i_divisor = 0)
            $display("\n=================== 4th scenario Corner Case (Error Handling : i_divisor = 0) ====================");
            reset();            //now, o_slow_clk = 0
            i_divisor = 0;      //invalid i_divisor should stay at reset state
            if(!o_slow_clk && DUT.count == 0)
                $display("[PASS] 4th scenario Corner Case (Error Handling : i_divisor = 0)");
            else
                $display("[FAIL] 4th scenario Corner Case (Error Handling : i_divisor = 0) : o_slow_clk = %d, count = %d", o_slow_clk, DUT.count);


                                //5th scenario Corner Case (Error Handling : i_divisor = 1)
            $display("\n=================== 5th scenario Corner Case (Error Handling : i_divisor = 1) ====================");
            reset();            //now, o_slow_clk = 0
            i_divisor = 1;      //invalid i_divisor should stay at reset state
            if(!o_slow_clk && DUT.count == 0)
                $display("[PASS] 5th scenario Corner Case (Error Handling : i_divisor = 1)");
            else
                $display("[FAIL] 5th scenario Corner Case (Error Handling : i_divisor = 1) : o_slow_clk = %d, count = %d", o_slow_clk, DUT.count);  


                                //6th scenario Corner Case (even i_divisor = 100)
            $display("\n=================== 6th scenario Corner Case (even i_divisor = 100) ====================");
            reset();            //now, o_slow_clk = 0
            i_divisor = 100;    //even divisor
            repeat(100/2)       //now, o_slow_clk should be 1 
                @(negedge i_clk);
            if(o_slow_clk)
                $display("[PASS] 6th scenario Corner Case (even i_divisor = 100)");
            else    
                $display("[FAIL] 6th scenario Corner Case (even i_divisor = 100) : o_slow_clk = %d, expected = 1", o_slow_clk);
            repeat(100/2)       //now, o_slow_clk should be 0
                @(negedge i_clk);
            if(!o_slow_clk)
                $display("[PASS] 6th scenario Corner Case (even i_divisor = 100)");
            else    
                $display("[FAIL] 6th scenario Corner Case (even i_divisor = 100) : o_slow_clk = %d, expected = 0", o_slow_clk);  


                                //7th scenario Corner Case (odd i_divisor = 101)
            $display("\n=================== 7th scenario Corner Case (odd i_divisor = 101) ====================");
            reset();            //now, o_slow_clk = 0
            i_divisor = 101;    //odd divisor
            repeat(((101-1)/2) + 1) //waits for i_divisor_shifted + 1 i_clk cycles to maintain posedeg of o_slow_clk
                @(negedge i_clk);
            if(o_slow_clk)
                $display("[PASS] 7th scenario Corner Case (odd i_divisor = 101)");
            else    
                $display("[FAIL] 7th scenario Corner Case (odd i_divisor = 101) : o_slow_clk = %d, expected = 1", o_slow_clk);
            repeat((101-1)/2)   //waits for i_divisor_shifted i_clk cycles to maintain negedge of o_slow_clk
                @(negedge i_clk);
            if(!o_slow_clk)
                $display("[PASS] 7th scenario Corner Case (odd i_divisor = 101)");
            else    
                $display("[FAIL] 7th scenario Corner Case (odd i_divisor = 101) : o_slow_clk = %d, expected = 0", o_slow_clk);

                                //STOP Simulation
            #100;
            $stop;
        end       

    // monitor
    initial
        $monitor("@ time(%t) : i_divisor = %d, o_slow_clk = %d, i_rst = %d", $time, i_divisor, o_slow_clk, i_rst);         

endmodule