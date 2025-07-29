///////////////////////////////////////////////////////////
// Kareem Ashraf Mostafa
// kareem.ash05@gmail.com
// 01002321067
// github.com/kareem05-ash
///////////////////////////////////////////////////////////
module timer_core
(
    // Inputs
    input wire i_clk,                       // divided clk signal
    input wire i_rst,                       // async. active-high reset
    input wire i_timer_core_en,             // ~ctrl[1] & ctrl[2]
    input wire i_cont,                      // ctrl [3] continuous mode
    input wire i_irq_clear,                 // ctrl [5] (interrupt clear)
    input wire [15:0] i_period,             // reg period
    // Outputs 
    output reg o_irq                        // Interrupt outupt
);

    reg [15:0] count;                       // Internal main counter
    reg [15:0] period_sync;                 // Syncronous poeriod reg
    reg one_shot = 0;                       // A register for (cont vs one-shot) handling

    // Syncronization of i_period reg
    always@(posedge i_clk)
        period_sync <= i_period;

    // timer core logic
    always@(posedge i_clk or posedge i_rst)
        begin
            if(i_rst || !i_timer_core_en)       // mode stays on reset while not enabled
                begin
                    o_irq <= 0;         // default value
                    one_shot <= 0;      // reg handles one-shot vs cont logic
                    count <= 16'd0;     // reset the counter
                end
            else    
                begin
                    // highest priority
                    if(!i_irq_clear) 
                        begin
                            o_irq <= 0;     // dafault value
                            one_shot <= 0;  // to start new time cycle
                        end
                    // start counting logic
                    if(i_timer_core_en && !one_shot)
                        begin
                            if(count >= period_sync)
                                begin
                                    o_irq <= 1;     // interrupt flag
                                    count <= 16'd0; // reset counter
                                    if(!i_cont)
                                        one_shot <= 1;
                                end
                            else
                                // increment count if < period_sync
                                count <= count + 1;
                        end       
                end
        end
endmodule