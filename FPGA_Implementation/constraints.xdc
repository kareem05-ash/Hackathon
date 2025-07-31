# Kareem Ashraf Mostafa
# kareem.ash05@gmail.com
# github.com/kareem05-ash
# +201002321067

# FPGA Implementation

# Clock signals
## The Design works @ 2 different clk domains without glitches
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports i_clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports i_clk]

set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports i_clk]
create_clock -period 100.000 -name sys_clk_pin -waveform {0.000 50.000} -add [get_ports i_ext_clk]


# Switches
## Actual terminated inputs
set_property -dict { PACKAGE_PIN V17 	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[0]]
set_property -dict { PACKAGE_PIN V16 	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[1]]
set_property -dict { PACKAGE_PIN W16 	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[2]]
set_property -dict { PACKAGE_PIN W17 	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[3]
set_property -dict { PACKAGE_PIN W15 	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[4]]
set_property -dict { PACKAGE_PIN V15 	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[5]]
set_property -dict { PACKAGE_PIN W14 	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[6]]
set_property -dict { PACKAGE_PIN W13  	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[7]]
set_property -dict { PACKAGE_PIN V2 	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[8]]
set_property -dict { PACKAGE_PIN T3   	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[9]]
set_property -dict { PACKAGE_PIN T2   	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[10]]
set_property -dict { PACKAGE_PIN R3   	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[11]]
set_property -dict { PACKAGE_PIN W2   	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[12]]
set_property -dict { PACKAGE_PIN U1   	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[13]]
set_property -dict { PACKAGE_PIN T1   	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[14]]
set_property -dict { PACKAGE_PIN R2   	IOSTANDARD LVCMOS33 } [get_ports i_wb_data[15]]

## Non-terminated actually inputs
### i_wb_adr
set_property DONT_TOUCH true [get_ports i_wb_adr[0]]
set_property DONT_TOUCH true [get_ports i_wb_adr[1]]
set_property DONT_TOUCH true [get_ports i_wb_adr[2]]
set_property DONT_TOUCH true [get_ports i_wb_adr[3]]
set_property DONT_TOUCH true [get_ports i_wb_adr[4]]
set_property DONT_TOUCH true [get_ports i_wb_adr[5]]
set_property DONT_TOUCH true [get_ports i_wb_adr[6]]
set_property DONT_TOUCH true [get_ports i_wb_adr[7]]
set_property DONT_TOUCH true [get_ports i_wb_adr[8]]
set_property DONT_TOUCH true [get_ports i_wb_adr[9]]
set_property DONT_TOUCH true [get_ports i_wb_adr[10]]
set_property DONT_TOUCH true [get_ports i_wb_adr[11]]
set_property DONT_TOUCH true [get_ports i_wb_adr[12]]
set_property DONT_TOUCH true [get_ports i_wb_adr[13]]
set_property DONT_TOUCH true [get_ports i_wb_adr[14]]
set_property DONT_TOUCH true [get_ports i_wb_adr[15]]
### i_DC
set_property DONT_TOUCH true [get_ports i_DC[0]]
set_property DONT_TOUCH true [get_ports i_DC[1]]
set_property DONT_TOUCH true [get_ports i_DC[2]]
set_property DONT_TOUCH true [get_ports i_DC[3]]
set_property DONT_TOUCH true [get_ports i_DC[4]]
set_property DONT_TOUCH true [get_ports i_DC[5]]
set_property DONT_TOUCH true [get_ports i_DC[6]]
set_property DONT_TOUCH true [get_ports i_DC[7]]
set_property DONT_TOUCH true [get_ports i_DC[8]]
set_property DONT_TOUCH true [get_ports i_DC[9]]
set_property DONT_TOUCH true [get_ports i_DC[10]]
set_property DONT_TOUCH true [get_ports i_DC[11]]
set_property DONT_TOUCH true [get_ports i_DC[12]]
set_property DONT_TOUCH true [get_ports i_DC[13]]
set_property DONT_TOUCH true [get_ports i_DC[14]]
set_property DONT_TOUCH true [get_ports i_DC[15]]


# LEDs
## Outputs
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {o_wb_ack}]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {o_pwm}]


# Buttons
## Some inputs like (i_rst, i_wb_cyc, i_wb_stb, i_wb_we, i_DC_valid) 
set_property -dict {PACKAGE_PIN U18   IOSTANDARD LVCMOS33} [get_ports i_rst]
set_property -dict {PACKAGE_PIN T18   IOSTANDARD LVCMOS33} [get_ports i_wb_cyc]
set_property -dict {PACKAGE_PIN W19   IOSTANDARD LVCMOS33} [get_ports i_wb_stb]
set_property -dict {PACKAGE_PIN T17   IOSTANDARD LVCMOS33} [get_ports i_wb_we]
set_property -dict {PACKAGE_PIN U17   IOSTANDARD LVCMOS33} [get_ports i_DC_valid]


# Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]


# SPI configuration mode options for QSPI boot, can be used for all designs
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]