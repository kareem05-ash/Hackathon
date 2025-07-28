`timescale 1ns / 1ps

module pme_core_tb();

parameter clk_period = 20 ;
parameter half_clk_period = 10 ;

//tb signals
    reg clk_tb ;                    
    reg rst_tb ;                   
    reg duty_sel_tb ;             
    reg pwm_core_EN_tb ;         
    reg main_counter_EN_tb ;    
    reg o_pwm_EN_tb ;          
    reg [15:0] period_reg_tb ;
    reg [15:0] duty_reg_tb ; 
    reg [15:0] i_DC_tb ;    
    wire o_pwm_tb ;


// Instantiate the PWM core
    pwm_core dut (
        .clk(clk_tb) ,                    
        .rst(rst_tb) ,                   
        .duty_sel(duty_sel_tb) ,             
        .pwm_core_EN(pwm_core_EN_tb) ,        
        .main_counter_EN(main_counter_EN_tb) ,    
        .o_pwm_EN(o_pwm_EN_tb) ,          
        .period_reg(period_reg_tb) ,
        .duty_reg(duty_reg_tb) , 
        .i_DC(i_DC_tb) ,    
        .o_pwm(o_pwm_tb)     
    );

// Clock generation //50MHz clk
    always #half_clk_period clk_tb = ~ clk_tb ;

    // Test sequence
    initial begin
        // Initial conditions
        clk_tb = 0;
        rst_tb = 1;
        period_reg_tb = 16'd100;
        duty_reg_tb = 16'd25;
        duty_sel_tb = 0 ;       //get duty from reg
        pwm_core_EN_tb = 1 ;   //enable pwm 
        main_counter_EN_tb = 1 ; //enable main counter
        o_pwm_EN_tb = 1 ;       //enable output
        i_DC_tb = 16'd0;    

        #clk_period rst_tb = 0; // Release reset

        //TEST 1 duty from reg
        // Wait and observe PWM waveform
        #(500*clk_period);

        //TEST2 Change duty cycle
        duty_reg_tb = 16'd75;

        #(500*clk_period);

        //TEST3 Change period and duty cycle
        period_reg_tb = 16'd200;
        duty_reg_tb = 16'd100;

        #(500*clk_period);

        //TEST4 USE I_DC
        duty_sel_tb = 1;
        i_DC_tb = 16'd60;
        period_reg_tb = 16'd100;

        #(500*clk_period);

        duty_sel_tb = 0;
        period_reg_tb = 16'd20;
        duty_reg_tb = 16'd15;

        //TEST5 disable main counter
        main_counter_EN_tb = 0;
        #(200*clk_period);
        main_counter_EN_tb = 1;
        #(200*clk_period);

        //TEST6 disable output 
        o_pwm_EN_tb = 0;
        #(200*clk_period);
        o_pwm_EN_tb = 1;
        #(200*clk_period);  

        //TEST7       
        pwm_core_EN_tb = 0;
        #(200*clk_period);

        $finish;
    end

endmodule