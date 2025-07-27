vlib work
vlog clock_down.v clock_down_tb.v
vsim -voptargs=+acc work.clock_down_tb
add wave *
run -all
#quit -sim