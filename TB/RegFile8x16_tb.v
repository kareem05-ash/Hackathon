`timescale 1us/1ns
module RegFile8x16_tb ();
//parameters
parameter WIDTH = 8 ;
parameter DEPTH = 16 ;
parameter addressbits = 16 ;

//declare tb signals 
reg clk_tb ;
reg rst_tb ;                          
reg wrEN_tb ;                        
reg rdEN_tb ;                       
reg [addressbits-1:0] address_tb ; 
reg [DEPTH-1:0] wrData_tb ;       
wire[DEPTH-1:0] rdData_tb ;

//DUT instantiation
RegFile8x16 regfile (
    .clk(clk_tb),
    .rst(rst_tb),
    .wrEN(wrEN_tb),
    .rdEN(rdEN_tb),
    .address(address_tb),
    .wrData(wrData_tb),
    .rdData(rdData_tb)
);

//clock generation 
always #5 clk_tb = ~ clk_tb ;

integer tests = 4 ; //! edit this if u added more tests
integer succeeded = 0 ; 
integer count ; //used for test2

initial begin 
    //intial values 
    clk_tb = 0;
    rst_tb = 1'b1;
    wrEN_tb = 1'b0;
    rdEN_tb = 1'b0;
    address_tb = 3'b0;
    wrData_tb = 'd5;
    #2

    //TESTING 
    $display("Started TESTING\n");
    
    //TEST1 Write data and read from one reg
        wrEN_tb = 1'b1;        //rise write enable
        address_tb = 3'b000;  //REG0
        wrData_tb = 'd5;     //write 5
        #10
        wrEN_tb = 1'b0;    //drop write enable 
        #10
        rdEN_tb = 1'b1;  //rise read enable
        #10
        if (rdData_tb == 'd5)begin
            $display("TEST1 succeeded\n");
            succeeded = succeeded + 1;
        end 
        else $display("TEST1 failed\n");
        rdEN_tb =1'b0;//drop write
        #10

    //TEST2 Write data and read from multiple reg
        //write REG1 13
        count = 0 ;             //start counter
        wrEN_tb = 1'b1;        //rise write enable
        address_tb = 3'b001;  //REG1
        wrData_tb = 'd13;    //write 13
        #10
        //write REG5 25
        wrEN_tb = 1'b1;        //rise write enable
        address_tb = 3'b101;  //REG5
        wrData_tb = 'd25;    //write 25
        #10
        //write REG7 9
        wrEN_tb = 1'b1;        //rise write enable
        address_tb = 3'b111;  //REG7
        wrData_tb = 'd9;     //write 9
        #10
        wrEN_tb = 1'b0;    //drop write enable 
        #10
        //read
        rdEN_tb = 1'b1; //rise read enable
        #10
        address_tb = 3'b001;  //REG1
        #10
        if (rdData_tb == 'd13) count = count + 1;
        #10
        address_tb = 3'b101;  //REG5
        #10
        if (rdData_tb == 'd25) count = count + 1;
        #10
        address_tb = 3'b111;  //REG7
        #10
        if (rdData_tb == 'd9) count = count + 1;
        #10
        rdEN_tb =1'b0;//drop write

        if (count == 3)begin
            $display("TEST2 succeeded\n");
            succeeded = succeeded + 1;
        end 
        else $display("TEST2 failed count is %d\n",count);


    //TEST3 Write data when active is not enabled
        address_tb = 3'b000;  //REG0
        wrData_tb = 'd98;    //write 98 
        #10
        rdEN_tb = 1'b1;    //rise read enable
        #10
        if (rdData_tb == 'd5)begin //the old stored value
            $display("TEST3 succeeded\n");
            succeeded = succeeded + 1;
        end 
        else $display("TEST3 failed\n");
        rdEN_tb =1'b0;//drop write
    
    //TEST4 reset enabled
        rst_tb = 1'b0;
        #10
        rst_tb = 1'b1;
        #10
        address_tb = 3'b000;  //REG0
        #10
        rdEN_tb = 1'b1;     //rise read enable
        #10
        if (rdData_tb == 'd0)begin //REG0 back to 0
            $display("TEST4 succeeded\n");
            succeeded = succeeded + 1;
        end 
        else $display("TEST4 failed\n");
        rdEN_tb =1'b0;//drop write

    $display("TESTING ended %d out of %d succedded\n",succeeded,tests);    
    $finish;
end

//monitor
initial begin
    $monitor("rst: %b ,wrEN: %b ,rdEN: %b ,address: %3b ,wrData: %d ,rdData: %d \n"
                ,rst_tb ,wrEN_tb ,rdEN_tb ,address_tb ,wrData_tb ,rdData_tb );
end
endmodule