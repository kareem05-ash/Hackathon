module timer_tb ();
    reg clk;
    reg rst;
    reg start;
    reg enable;
    reg [15:0] period;
    wire interrupt;
    wire [15:0] counter;
    wire counter_rst;

    // Instantiate the timer module
    timer uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .enable(enable),
        .period(period),
        .interrupt(interrupt),
        .counter_rst(counter_rst),
        .counter(counter)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Test sequence
    initial begin
        rst = 0; // Assert reset
        start = 0;
        enable = 0;
        period = 16'h000A; // Set period to 10

        #10 rst = 1; // Deassert reset

        // Start the timer
        #10 start = 1;

        // Enable counting after some time
        #20 enable = 1;
        #50 enable=0;
        // Wait for some time to observe behavior
        #100;

        // Stop the timer and check results
        start = 0;
       

        #20 $stop; // End simulation
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t, Counter: %d, Interrupt: %b", $time, counter, interrupt);
    end
endmodule