///////////////////////////////////////////////////////////
// Kareem Ashraf Mostafa
// kareem.ash05@gmail.com
// 01002321067
// github.com/kareem05-ash
///////////////////////////////////////////////////////////
`timescale 1ns/1ps
module wb_interface#
(
    parameter base_adr = 16'h0000,      //base address
    parameter ctrl_spacing = 0,         //ctrl reg address : base_adr + ctrl_spacing
    parameter divisor_spacing = 2,      //divisor reg address : base_adr + divisor_spacing
    parameter period_spacing = 4,       //period reg address : base_adr + period_spacing
    parameter DC_spacing = 6            //DC reg address : base_adr + DC_spacing
)
(
    // Inputs
    input wire i_wb_clk,                //system active-high clk
    input wire i_wb_rst,                //system async. active-high reset
    input wire i_wb_cyc,                //should set to start any process
    input wire i_wb_stb,                //should set to start a single process
    input wire i_wb_we,                 //1:write process, 0:read process
    input wire [15:0] i_wb_adr,         //address used for read/write process
    input wire [15:0] i_wb_data,        //input data to be written 
    input wire [15:0] i_reg_data,       //data from reg_file
    // Outputs
    output reg o_wb_ack,                //indication of process completion (set for one i_wb_clk cycle)
    output reg [15:0] o_wb_data,        //read data from reg_file during read process
    output reg [15:0] o_reg_adr,        //address to choose between registers (ctrl, divisor, period, & dc)
    output reg [15:0] o_reg_data,       //data to be written in reg_file
    output reg o_reg_we,                //write enable to write on reg_file
    output reg o_reg_re                 //read enable to read data from reg_file
);
    // Neede internal signals

    //handling invalid address only (0, 2, 4, 6) are valid
    wire adr_valid = ((i_wb_adr == base_adr + ctrl_spacing)    ||   // ctrl
                      (i_wb_adr == base_adr + divisor_spacing) ||   // divisor
                      (i_wb_adr == base_adr + period_spacing)  ||   // period
                      (i_wb_adr == base_adr + DC_spacing));         // DC

    // Slave WB logic
    always@(posedge i_wb_clk or posedge i_wb_rst)
        begin
            if(i_wb_rst)
                begin   //reset all outputs
                    o_wb_ack <= 1'b0;
                    o_wb_data <= 16'h0000;
                    o_reg_adr <= 16'h0000;
                    o_reg_data <= 16'h0000;
                    o_reg_we <= 1'b0;
                    o_reg_re <= 1'b0;
                end
            else
                begin
                    o_wb_data <= i_reg_data;                //resend data from reg_file to wb_interface to provide the host with it
                    if(i_wb_cyc && i_wb_stb && adr_valid)
                        begin
                            //address decoding
                            o_reg_adr <= i_wb_adr;      
                            //write operation    
                            if(i_wb_we)     
                                begin
                                    o_reg_data <= i_wb_data;
                                    o_reg_we <= 1;          //enable write operation
                                    o_wb_ack <= 1;          //indicates complete operation
                                end
                            //read operation  
                            else           
                                begin
                                    o_reg_data <= i_wb_data;
                                    o_reg_re <= 1;          //enable read opreration
                                    o_wb_ack <= 1;          //indicates complete operation
                                end
                        end
                end
        end 
endmodule