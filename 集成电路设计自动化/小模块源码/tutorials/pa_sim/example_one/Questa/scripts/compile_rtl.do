##############################################################################
# Source:    compile_rtl.do
# Author:    Keith R. Gover
# Date:      March 26, 2009
# Modified:  March 12, 2010
# File:      Tcl script for compiling with Questa/ModelSim
# Remarks:   Mentor Low Power example
##############################################################################
onbreak {resume}
if {[batch_mode]} {
    onerror {quit -f}
}

echo "#"
echo "# NOTE: Creating library and compiling design ..."
echo "#"
if [file exists work] {
    vdel -lib work -all
}
vlib work
vlog -work work -novopt -f ./Questa/scripts/compile_rtl.f

if {[batch_mode]} {
    quit -f
}
