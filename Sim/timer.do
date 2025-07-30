vlib work
vlog timer_core.v timer_core_tb.v
vsim -voptargs=+acc work.timer_core_tb
add wave *
run -all
#quit -sim
