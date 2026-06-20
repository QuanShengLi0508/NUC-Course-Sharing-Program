# Copyright 1991-2012 Mentor Graphics Corporation
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
# WHICH IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION
# OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
#
# To run this example, bring up the simulator and type the following at the prompt:
#     do run.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -do run.do -c
# (omit the "-c" to see the GUI while running from the shell)
# Remove the "quit -f" command from this file to view the results in the GUI.

onbreak {resume}
if {[batch_mode]} {
    echo "Run this test in the GUI mode."
    quit -f
}

# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the source files.
vlog -work work -novopt -f compile_rtl.f

# Optimize the design.
 vopt -work work +acc -debugdb\
     interleaver_tester \
     -pa_upf rtl_top.upf \
     -pa_top "/interleaver_tester/dut" \
     -pa_genrpt=pa+de+v+u \
     -pa_checks=s+ul+umi+i+r+p+cp+t+upc+npu+ugc \
     -pa_opt=n35 \
     -o top_opt

# Simulate the design and view the results.
vsim work.top_opt \
     -debugDB \
     +nowarnTSCALE \
     +nowarnTFMPC \
     -l rtl.log \
     -wlf rtl.wlf \
     -L mtiPA \
     -pa \
     -pa_highlight \
     -assertdebug \
     -coverage \
     +notimingchecks

log -r /*
add wave -expand -group "Testbench Signals"
add wave -group "Testbench Signals" /interleaver_tester/clock1
add wave -group "Testbench Signals" /interleaver_tester/clock2
add wave -group "Testbench Signals" /interleaver_tester/reset_n
add wave -expand -group "Power Control Signals"
add wave -group "Power Control Signals" /interleaver_tester/mc_PWR
add wave -group "Power Control Signals" /interleaver_tester/mc_SAVE
add wave -group "Power Control Signals" /interleaver_tester/mc_RESTORE
add wave -group "Power Control Signals" /interleaver_tester/mc_ISO
add wave -group "Power Control Signals" /interleaver_tester/mc_CLK_GATE
add wave -group "Power Control Signals" /interleaver_tester/sram_PWR
add wave -group "Interleaver"
add wave -group "Interleaver" -ports /interleaver_tester/dut/i0/*
add wave -group "Asynchronous Bridge"
add wave -group "Asynchronous Bridge" -ports /interleaver_tester/dut/i1/*
add wave -expand -group "Memory Controller"
add wave -group "Memory Controller" -ports /interleaver_tester/dut/mc0/*
add wave -expand -group "SRAM #1"
add wave -group "SRAM #1" /interleaver_tester/dut/m1/CLK
add wave -group "SRAM #1" /interleaver_tester/dut/m1/PD
add wave -group "SRAM #1" /interleaver_tester/dut/m1/CEB_i
add wave -group "SRAM #1" /interleaver_tester/dut/m1/WEB_i
add wave -group "SRAM #1" -unsigned /interleaver_tester/dut/m1/A_i
add wave -group "SRAM #1" -unsigned /interleaver_tester/dut/m1/D
add wave -group "SRAM #1" -unsigned /interleaver_tester/dut/m1/Q
add wave -group "Assertions"
add wave -group "Assertions" /interleaver_tester/a_addr_m1_iso
add wave -group "Assertions" /interleaver_tester/a_ret_clk_gate

run -all
wave zoomrange 156400ns 185000ns
coverage report -detail -pa
coverage save -pa pa.ucdb
vcover report pa.ucdb -pa

echo "Adding design elements to the schematic window."

add schematic /interleaver_tester/dut/i1/do_rdy_out
add schematic /interleaver_tester/dut/mc0/ceb
add schematic /interleaver_tester/dut/m4/Q
add schematic /interleaver_tester/dut/m4/D
add schematic /interleaver_tester/dut/m3/Q
add schematic /interleaver_tester/dut/m3/Q
add schematic /interleaver_tester/dut/m2/Q
add schematic /interleaver_tester/dut/m2/D
add schematic /interleaver_tester/dut/m1/Q
add schematic /interleaver_tester/dut/m1/D
add schematic /interleaver_tester/dut/i0/out2wire/downstream_rdy

quit -f
