
module RegFile8x16 #
(   // Parameters
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter addressbits = 16 
)
(   // Inputs
    input clk,
    input rst,                          //active low rst to reset all regs to 0
    input wrEN,                         //signal to write to a specified reg
    input [addressbits-1:0] address,    //address of the desired reg
    input [DEPTH-1:0] wrData            //data to be writen to a reg
);

    reg [WIDTH-1:0] REG [DEPTH-1:0] ;       //actual stored regs
    integer k;
    always @(posedge clk ,posedge rst)begin
        if (rst) begin //set all regs to 0
            for ( k = 0 ; k < DEPTH ;k = k + 1)begin 
                REG[k] <= 'b0;
            end
        end
        else begin 
            if (wrEN)begin //write to a reg
                REG[address] <= wrData;
            end
        end
    end

endmodule