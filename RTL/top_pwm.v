module top_pwm (
    input i_clk, 
    input i_rst,
    input i_wb_cyc,
    input i_wb_stb,
    input i_wb_we,
    input [15:0] i_wb_adr,
    input [15:0] i_wb_data,
    input i_ext_clk,
    input [15:0] i_DC,
    input i_DC_valid,
    output o_wb_ack,
    output o_pwm  
);

//internal signals 
    //wb signals
    wire o_reg_we ;
    wire o_reg_adr ;
    wire o_wb_data ;
    //clk down signals
    wire o_clk ; //input clk for timer and pwm
    wire chosen_clk ;
    //pwm signals
    wire pwm_out ;
    //timer signals
    wire o_irq ;
    //register file signals
    wire wrEN ;
    wire [15:0] adr ;
    wire [15:0] i_data ;
    //regfile registers
    wire [15:0] ctrl_reg = regfile.REG[0] ;
    wire [15:0] divisor_reg = regfile.REG[2];
    wire [15:0] period_reg = regfile.REG[4] ;
    wire [15:0] duty_reg = regfile.REG[6] ;

//internal logic 
assign chosen_clk = (ctrl_reg[0])? i_ext_clk : i_clk ;
assign o_pwm = (ctrl_reg[1])? pwm_out : o_irq ;
assign pwm_rst = i_rst || ctrl_reg[7] ;
assign timer_core_EN = ctrl_reg[2] & (~ctrl_reg[1]) & (ctrl_reg[4]); //bit2 counter EN ,bit1 timer mode bit4 o_pwm EN

//modules instantiation
//wb module
wb_interface  wb (
    .i_wb_clk(i_clk),                
    .i_wb_rst(i_rst),                
    .i_wb_cyc(i_wb_cyc),                
    .i_wb_stb(i_wb_stb),                
    .i_wb_we(i_wb_we),                
    .i_wb_adr(i_wb_adr),        
    .i_wb_data(i_wb_data),         
    .o_wb_ack(o_wb_ack),           
    .o_reg_adr(adr),       
    .o_wb_data(i_data),       
    .o_reg_we(wrEN)              
);

//clock down module 
clock_down down_clk (
    .i_clk(chosen_clk),                               
    .i_rst(i_rst),                              
    .i_divisor(divisor_reg),                    
    .o_slow_clk(o_clk)                           
);

//pwm core module 
pwm_core pwm (
    .clk(o_clk) ,                    
    .rst(pwm_rst) ,                   
    .duty_sel(ctrl_reg[6]) ,             
    .pwm_core_EN(ctrl_reg[1]) ,        
    .main_counter_EN(ctrl_reg[2]) ,    
    .o_pwm_EN(ctrl_reg[4]) ,         
    .period_reg(period_reg) ,
    .duty_reg(duty_reg) , 
    .i_DC(i_DC) ,    
    .i_DC_valid(i_DC_valid) ,     
    .o_pwm(pwm_out)    
);

//timer module 
timer_core timer(
    .i_clk(o_clk),                       
    .i_rst(pwm_rst),                       
    .i_timer_core_en(timer_core_EN),             
    .i_cont(ctrl_reg[3]),                      
    .i_irq_clear(ctrl_reg[5]),                 
    .i_period(period_reg),            
    .o_irq(o_irq)       
);

//reg file module 
RegFile8x16 regfile (
    .clk(i_clk),
    .rst(i_rst),                         
    .wrEN(wrEN),                       
    .address(adr), 
    .wrData(i_data) 
);

endmodule