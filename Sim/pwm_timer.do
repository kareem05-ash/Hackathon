vlib work
vlog pwm_timer.v pwm_timer_tb.v
vsim -voptargs=+acc work.pwm_timer_tb
add wave *
run -all
#quit -sim