///////////////////////////////////////////////////////////
// Kareem Ashraf Mostafa
// kareem.ash05@gmail.com
// 01002321067
// github.com/kareem05-ash
///////////////////////////////////////////////////////////
`timescale 1ns/1ps
module wb_interface_tb();
    // Parameters
    parameter base_adr = 16'h0000;      //base address
    parameter ctrl_spacing = 0;         //ctrl reg address : base_adr + ctrl_spacing
    parameter divisor_spacing = 2;      //divisor reg address : base_adr + divisor_spacing
    parameter period_spacing = 4;       //period reg address : base_adr + period_spacing
    parameter DC_spacing = 6;           //DC reg address : base_adr + DC_spacing

    // DUT Inputs 
    reg i_wb_clk;                       //system active-high clk
    reg i_wb_rst;                       //system async. active-high reset
    reg i_wb_cyc;                       //should set to start any process
    reg i_wb_stb;                       //should set to start a single process
    reg i_wb_we;                        //1:write process, 0:read process
    reg [15:0] i_wb_adr;                //address used for read/write process
    reg [15:0] i_wb_data;               //input data to be written 
    // reg [15:0] i_reg_data;              //data from reg_file

    // DUT Outputs
    wire o_wb_ack;                      //indication of process completion (set for one i_wb_clk cycle)
    wire [15:0] o_wb_data;              //read data from reg_file during read process
    wire [15:0] o_reg_adr;              //address to choose between registers (ctrl, divisor, period, & dc)
    // wire [15:0] o_reg_data;             //data to be written in reg_file
    wire o_reg_we;                      //write enable to write on reg_file
    // wire o_reg_re;                      //read enable to read data from reg_file

    // DUT Instantiation
    wb_interface#(
        .base_adr(base_adr), 
        .ctrl_spacing(ctrl_spacing), 
        .divisor_spacing(divisor_spacing), 
        .period_spacing(period_spacing), 
        .DC_spacing(DC_spacing)
    )
    DUT(
        // inputs
        .i_wb_clk(i_wb_clk), 
        .i_wb_rst(i_wb_rst), 
        .i_wb_cyc(i_wb_cyc),
        .i_wb_stb(i_wb_stb), 
        .i_wb_we(i_wb_we), 
        .i_wb_adr(i_wb_adr), 
        .i_wb_data(i_wb_data), 
        // .i_reg_data(i_reg_data), 
        // outputs
        .o_wb_ack(o_wb_ack), 
        .o_wb_data(o_wb_data), 
        .o_reg_adr(o_reg_adr), 
        // .o_reg_data(o_reg_data), 
        .o_reg_we(o_reg_we) 
        // .o_reg_re(o_reg_re)
    );

    // CLK Generation
    initial
        begin
            // initial value to avoid unknown i_clk signal 
            i_wb_clk = 0;      
            // 50 MHZ i_wb_clk signal
            forever #10 i_wb_clk = ~i_wb_clk;     
        end

    // TASKs
    // reset task
    task reset();
        begin
            i_wb_rst = 1;       // Activate i_wb_rst
            i_wb_cyc = 0;       // default value
            i_wb_stb = 0;       // default value
            i_wb_we = 0;        // default value
            i_wb_data = 16'd0;  // default value
            i_wb_adr = 16'd0;   // default value
            // i_reg_data = 16'd0; // default value
            repeat(30)          // waits for 30 i_wb_clk cycles to track i_wb_rst signal
                @(negedge i_wb_clk);
            i_wb_rst = 0;       // Release i_wb_rst
        end
    endtask


    initial     // Real World Scenarios & Corner Cases Tests
        begin
                                // 1st scenario Functional Correctness (Reset Behavior)
            $display("\n==================== 1st scenario Functional Correctness (Reset Behavior) ====================");
            reset();
            if(o_wb_ack || (o_wb_data != 16'd0) || (o_reg_adr != 16'd0) || o_reg_we)
                $display("[FAIL] 1st scenario Functional Correctness (Reset Behavior) : o_wb_ack = %d, o_wb_data = %h, o_reg_adr = %h, o_reg_we = %d", 
                        o_wb_ack, o_wb_data, o_reg_adr, o_reg_we);
            else 
                $display("[PASS] 1st scenario Functional Correctness (Reset Behavior)");


                                // 2nd scenario Functional Correctness (write random values to all regs)
            $display("\n==================== 2nd scenario Functional Correctness (write random values to all regs) ====================");
            reset();
            i_wb_cyc = 1;       //allow operations 
            i_wb_stb = 1;       //allow operations
            i_wb_we = 1;        //enables write operation
            // write to ctrl reg
            i_wb_adr = 16'h0000;
            // generate a random sample
            i_wb_data = $random;
            // waits for one i_wb_clk cycle to track changes
            @(negedge i_wb_clk);
            if((o_wb_ack && o_reg_we) && (i_wb_data == o_wb_data))
                $display("[PASS] 2nd scenario Functional Correctness (write random values to all regs) [ctrl] reg | ctrl = %h, expected = %h", o_wb_data, i_wb_data);
            else
                $display("[FAIL] 2nd scenario Functional Correctness (write random values to all regs) [ctrl] reg | ctrl = %h, expected = %h", o_wb_data, i_wb_data);
            // write to divisor reg
            i_wb_adr = 16'h0002;
            // generate a random sample
            i_wb_data = $random;
            // waits for one i_wb_clk cycle to track changes
            @(negedge i_wb_clk);
            if((o_wb_ack && o_reg_we) && (i_wb_data == o_wb_data))
                $display("[PASS] 2nd scenario Functional Correctness (write random values to all regs) [divisor] reg | divisor = %h, expected = %h", o_wb_data, i_wb_data);
            else
                $display("[FAIL] 2nd scenario Functional Correctness (write random values to all regs) [divisor] reg | divisor = %h, expected = %h", o_wb_data, i_wb_data);
            // write to period reg
            i_wb_adr = 16'h0004;
            // generate a random sample
            i_wb_data = $random;
            // waits for one i_wb_clk cycle to track changes
            @(negedge i_wb_clk);
            if((o_wb_ack && o_reg_we) && (i_wb_data == o_wb_data))
                $display("[PASS] 2nd scenario Functional Correctness (write random values to all regs) [period] reg | period = %h, expected = %h", o_wb_data, i_wb_data);
            else
                $display("[FAIL] 2nd scenario Functional Correctness (write random values to all regs) [period] reg | period = %h, expected = %h", o_wb_data, i_wb_data);
            // write to DC reg
            i_wb_adr = 16'h0000;
            // generate a random sample
            i_wb_data = $random;
            // waits for one i_wb_clk cycle to track changes
            @(negedge i_wb_clk);
            if((o_wb_ack && o_reg_we) && (i_wb_data == o_wb_data))
                $display("[PASS] 2nd scenario Functional Correctness (write random values to all regs) [DC] reg | DC = %h, expected = %h", o_wb_data, i_wb_data);
            else
                $display("[FAIL] 2nd scenario Functional Correctness (write random values to all regs) [DC] reg | DC = %h, expected = %h", o_wb_data, i_wb_data);


                                // 3rd scenario Functional Correctness (Read-Back from reg_file)
            $display("\n==================== 3rd scenario Functional Correctness (Read-Back from reg_file) ====================");
            reset();
            // i_wb_cyc = 1;       //allow operations
            // i_wb_stb = 1;       //allow operations
            // // generate a random sample from reg_file to send it back to wb_interface
            // i_reg_data = $random;
            // // waits for one i_wb_clk cycle to track changes
            // @(negedge i_wb_clk);
            // if(o_wb_data == i_reg_data)
            //     $display("[PASS] 3rd scenario Functional Correctness (Read-Back from reg_file) | o_wb_data = %h, expected = %h", o_wb_data, i_reg_data);
            // else
            //     $display("[FAIL] 3rd scenario Functional Correctness (Read-Back from reg_file) | o_wb_data = %h, expected = %h", o_wb_data, i_reg_data);


                                // 4th scenario Functional Correctness (Address Decoding for reg_file)
            $display("\n==================== 4th scenario Functional Correctness (Address Decoding for reg_file) ====================");
            reset();
            i_wb_cyc = 1;       //allow operations
            i_wb_stb = 1;       //allow operations
            i_wb_adr = 16'h0004;
            // waits for one i_wb_cycle to track changes
            @(negedge i_wb_clk);
            if(o_reg_adr == i_wb_adr)
                $display("[PASS] 4th scenario Functional Correctness (Address Decoding for reg_file) | o_reg_adr = %h, expected = %h", o_reg_adr, i_wb_adr);
            else
                $display("[FAIL] 4th scenario Functional Correctness (Address Decoding for reg_file) | o_reg_adr = %h, expected = %h", o_reg_adr, i_wb_adr);


                                // 5th scenario Corner Case (Write on a reg with In-Valid address)
            $display("\n==================== 5th scenario Corner Case (Write on a reg with In-Valid address) ====================");
            reset();
            i_wb_cyc = 1;       //allow operations 
            i_wb_stb = 1;       //allow operations
            i_wb_we = 1;        //enables write operation
            // write to in_valid address
            i_wb_adr = 16'h0010;//not from (0, 2, 4, or 6)
            // generate a random sample
            i_wb_data = $random;
            // waits for one i_wb_clk cycle to track changes
            @(negedge i_wb_clk);
            if(o_wb_ack || (o_wb_data != 16'd0) || (o_reg_adr != 16'd0) || o_reg_we)
                $display("[FAIL] 5th scenario Corner Case (Write on a reg with In-Valid address) : o_wb_ack = %d, o_wb_data = %h, o_reg_adr = %h, o_reg_we = %d", 
                        o_wb_ack, o_wb_data, o_reg_adr, o_reg_we);
            else 
                $display("[PASS] 5th scenario Corner Case (Write on a reg with In-Valid address)");


                                // 6th scenario Corner Case (Address Decoding with In-Valid address)
            $display("\n==================== 6th scenario Corner Case (Address Decoding with In-Valid address) ====================");
            reset();
            i_wb_cyc = 1;       //allow operations
            i_wb_stb = 1;       //allow operations
            // in-valid address : not from (0, 2, 4, or 6)
            i_wb_adr = 16'h0023;
            // waits for one i_wb_cycle to track changes
            @(negedge i_wb_clk);
            if(o_wb_ack || (o_wb_data != 16'd0) || (o_reg_adr != 16'd0) || o_reg_we)
                $display("[FAIL] 6th scenario Corner Case (Address Decoding with In-Valid address) : o_wb_ack = %d, o_wb_data = %h, o_reg_adr = %h, o_reg_we = %d", 
                        o_wb_ack, o_wb_data, o_reg_adr, o_reg_we);
            else 
                $display("[PASS] 6th scenario Corner Case (Address Decoding with In-Valid address)");


                                // 7th scenario Corner Case (Write 10 samples to a reg Back-to-Back without losses)
            $display("\n==================== 7th scenario Corner Case (Write 10 samples to a reg Back-to-Back without losses) ====================");
            reset();
            i_wb_cyc = 1;       //allow operations 
            i_wb_stb = 1;       //allow operations
            i_wb_we = 1;        //enables write operation
            repeat(10)
                begin
                    // write to ctrl reg
                    i_wb_adr = 16'h0000;
                    // generate a random sample
                    i_wb_data = $random;
                    // waits for one i_wb_clk cycle to track changes
                    @(negedge i_wb_clk);
                    if((o_wb_ack && o_reg_we) && (i_wb_data == o_wb_data))
                        $display("[PASS] 7th scenario Corner Case (Write 10 samples to a reg Back-to-Back without losses) [ctrl] reg | ctrl = %h, expected = %h", o_wb_data, i_wb_data);
                    else
                        $display("[FAIL] 7th scenario Corner Case (Write 10 samples to a reg Back-to-Back without losses) [ctrl] reg | ctrl = %h, expected = %h", o_wb_data, i_wb_data);
                end


                                // STOP Simulation
            #100; 
            $stop;
        end 
endmodule
