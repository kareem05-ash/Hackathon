module pwm_core(
    input clk ,                    //clk from clk down either external clk or wb clk
    input rst ,                   //total pwm core rst i_rst or ctrl bit 7
    input duty_sel ,             //ctrl bit 6 to select external duty or the registerd one
    input pwm_core_EN ,         //ctrl bit 1 if high then pwm is enabled
    input main_counter_EN ,    //ctrl bit 2 
    input o_pwm_EN ,          //ctrl bit 4
    input [15:0] period_reg ,//reg have the required output clk period
    input [15:0] duty_reg , //reg have the required output clk duty
    input [15:0] i_DC ,    //external duty cycle input
    input i_DC_valid ,    //signal high when a valid duty is input 
    output reg o_pwm     //the output modulated clk
);
//pwm core internal signals
reg [15:0] pwm_duty ;
reg [15:0] counter ; //main 16 bit counter

    //duty selection
        always @(*)begin
            //if ctrl bit 6 is set choose external duty
            if (duty_sel && i_DC_valid) pwm_duty = i_DC ;
            else pwm_duty = duty_reg ;
        end


//modulated duty output clk logic
    always @(posedge clk or posedge rst) begin
        if (rst || !pwm_core_EN) begin  //stay in reset while this mode is not enabled 
            counter <= 16'd0;
            o_pwm <= 1'b0;
        end else if(main_counter_EN & o_pwm_EN) begin 
                    if (pwm_duty < period_reg ) begin
                        if (counter < period_reg - 1 )
                            counter <= counter + 1;
                        else
                            counter <= 16'd0;

                        o_pwm <= (counter < pwm_duty) ? 1'b1 : 1'b0;
                    end
                    else o_pwm <= clk ;
        end
        
    end




endmodule