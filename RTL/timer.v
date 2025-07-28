module timer (
    input wire clk, // slow clock signal
    input wire rst, // reset
    input wire start, // start counting (ctrl[2])
    input wire enable, // counting enable (ctrl[3])
    input wire [15:0] period,
    output reg counter_rst, //reset the counter (ctrl[7])
    output reg interrupt, // indicates an interrupt (ctrl[5])
    output reg [15:0] counter
);
always@( posedge clk ) begin
if (!rst) begin
    counter_rst <= 1; // Reset the counter
    counter <= 16'b0; // Initialize counter to 0
    interrupt <= 0; // Clear interrupt
end 
else if (start) begin 
    if (counter == period) begin
        if (!enable) begin
        interrupt<=1;
        counter<=counter;
        end
        else counter <=counter+1'b1; 
    end
    else counter <= counter+1'b1;
end
else counter<=counter;
end
endmodule