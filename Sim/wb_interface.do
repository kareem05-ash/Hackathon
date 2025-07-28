vlib work
vlog wb_interface.v wb_interface_tb.v
vsim -voptargs=+acc work.wb_interface_tb
add wave *
run -all
#quit -sim