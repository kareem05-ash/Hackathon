///////////////////////////////////////////////////////////
// Kareem Ashraf Mostafa
// kareem.ash05@gmail.com
// 01002321067
// github.com/kareem05-ash
///////////////////////////////////////////////////////////
module clock_down
(
    // inputs
    input wire i_clk,                               //active-high clk isgnal to be divided
    input wire i_rst,                               //async. active-high rst signal
    input wire [15:0] i_divisor,                    //divisor from reg_file
    // outputs
    output wire o_slow_clk                           //divided clk signal. It can be down clocked at most (1/(2^16 - 1)) of original frequency                       
);
    // internal signals needed
    wire zero_flag = i_divisor == 0;                //track zero ratio
    wire one_flag = i_divisor == 1;                 //track one ratio
    wire enable = (!zero_flag && !one_flag);        //set if i_divisor is greater than one. it can be implemented by (i_divisor > 1)
    wire odd_flag = i_divisor[0];                   //set if the i_divisor is odd to maintain unequal low and high levels in case of odd i_divisor
    wire [14:0] i_divisor_shifted = i_divisor >> 1; //floor the result of (i_divisor/2)
    reg [14:0] count;                               //counter counts i_clk cycles to handle division operation
    reg slow_clk ;


assign o_slow_clk = (zero_flag | one_flag )? i_clk : slow_clk ;

    // division logic block
    always@(posedge i_clk or posedge i_rst)
        begin
            if(i_rst)
                begin
                    count <= '0;                    //reset the counter
                    slow_clk <= 0;                //initialize the slow clk to avoid 'x' : unknown o_slow_clk signal output 
                end
            else if(enable)
                begin
                    if(!odd_flag && count == i_divisor_shifted-1)   //even ratio
                        begin
                            count <= '0;                            //reset the counter
                            slow_clk <= ~slow_clk;              //toggle o_slow_clk signal
                        end
                    else if(odd_flag)                               //odd ratio
                        begin
                            if(((count == i_divisor_shifted) && !slow_clk) || ((count == i_divisor_shifted-1) && slow_clk))
                                begin
                                    count <= '0;                    //reset the counter
                                    slow_clk <= ~slow_clk;      //toggle o_slow_clk signal    
                                end
                            else 
                                count <= count + 1;                 //increment the counter to reach the needed value
                        end
                    else    
                        count <= count + 1;                 //increment the counter to reach the needed value
                end
        end
endmodule