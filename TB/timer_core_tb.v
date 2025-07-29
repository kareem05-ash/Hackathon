`timescale 1ns / 1ps
module timer_core_tb();

//tb signals
reg i_clk_tb ;                       
reg i_rst_tb ;                       
reg i_timer_core_en_tb ;             
reg i_cont_tb ;                      
reg i_irq_clear_tb ;                 
reg [15:0] i_period_tb ;             
wire o_irq_tb ;

//dut instantiation
timer_core timer_tb (
    .i_clk(i_clk_tb),
    .i_rst(i_rst_tb),
    .i_timer_core_en(i_timer_core_en_tb),
    .i_cont(i_cont_tb),
    .i_irq_clear(i_irq_clear_tb),
    .i_period(i_period_tb),
    .o_irq(o_irq_tb)
);

//clock generation
parameter clk_period = 20 ;
parameter half_period = 10 ;
always #half_period i_clk_tb = ~i_clk_tb ; 

//variables for testing
integer tests = 3 ;
integer succeeded = 0 ;

initial begin
    //intial values
    i_clk_tb = 0 ;
    i_rst_tb = 1 ;
    i_timer_core_en_tb = 1 ;
    i_cont_tb = 0 ; //one shot mode
    i_irq_clear_tb = 1 ;//disabled
    i_period_tb = 16'd5 ;

    #clk_period ;
    i_rst_tb = 0 ; //disable reset

    //TEST1 one shot operation
    $display("TEST1 started , one shot operation \n");
    #(clk_period*10) ; //wait till period ends
    if(o_irq_tb == 1) begin 
        $display("TEST1 succeeded\n");
        succeeded = succeeded + 1 ;
    end
    else $display("TEST1 failed \n");

    //TEST2 clear irq
    $display("TEST2 started , clear irq \n");
    i_irq_clear_tb = 0 ; //enable
    #(clk_period*3); 
    i_irq_clear_tb = 1 ; //disable
    #clk_period ;
    if(o_irq_tb == 0) begin 
        $display("TEST2 succeeded\n");
        succeeded = succeeded + 1 ;
    end
    else $display("TEST2 failed \n");

    //TEST3 continuous mode
    $display ("TEST3 , continuous mode operation ");
    i_cont_tb = 1 ; //cont mode
    i_period_tb = 16'd7 ;
    #(clk_period*10);
    if(o_irq_tb == 1)begin
        $display("TEST3 succeeded\n");
        succeeded = succeeded + 1 ;
    end
    else $display("TEST3 failed \n");
    #(clk_period*10);
    $display("!!!!!check that couner keeps incremeing\n"); 



    $display ("TESTING ended %d out of %d succeeded \n",succeeded ,tests);
    $finish ;

end

initial begin
    $monitor ("irq: %b",o_irq_tb);
end



endmodule