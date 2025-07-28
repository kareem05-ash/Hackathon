module RegFile8x16 #(parameter WIDTH = 8 ,DEPTH = 16 ,addressbits = 16 )(
input clk,
input rst,                          //active low rst to reset all regs to 0
input wrEN,                        //signal to write to a specified reg
input rdEN,                       //signal to read data from a specified reg
input [addressbits-1:0] address, //address of the desired reg
input [DEPTH-1:0] wrData,       //data to be writen to a reg
output reg [DEPTH-1:0] rdData  //data to be read from a reg
);

reg [WIDTH-1:0] REG [DEPTH-1:0] ; //actual stored regs
integer k;
always @(posedge clk ,negedge rst)begin
    if (! rst) begin //set all regs to 0
        for ( k = 0 ; k < WIDTH ;k = k + 1)begin 
            REG[k] <= 'b0;
        end
    end
    else begin 
        if (wrEN && ~ rdEN)begin //write to a reg
            REG[address] <= wrData;
            rdData <= 0; //out 0 on data bus when no read operation
        end
        else if (~ wrEN && rdEN) begin //read from a reg
            rdData <= REG[address];
        end
        else begin
            rdData <= 0 ; //out 0 on data bus when no read operatio
        end
    end
    
end

endmodule