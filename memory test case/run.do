vlib work
vlog memory_testcase_tb.v
vsim tb +test_name=CONSECUTIVESA
add wave -r sim:/tb/dut/*
run -all

