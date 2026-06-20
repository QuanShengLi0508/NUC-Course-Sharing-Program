##############################################################################
# Source:    analyze_rtl.do
# Author:    Keith R. Gover
# Date:      March 26, 2009
# Modified:  May 27, 2009
# File:      Tcl script for compiling with Questa/ModelSim
# Remarks:   Mentor Low Power example
##############################################################################
onbreak {resume}
if {[batch_mode]} {
    onerror {quit -f}
}

echo "#"
echo "# NOTE: Analyzing UPF and extracting PA netlist ..."
echo "#"
vopt -work work \
     rtl_top \
     -pa_upf ./UPF/rtl_top.upf \
     -pa_prefix "/interleaver_tester/" \
     -pa_replacetop "dut" \
     -pa_genrpt=u+v \
     -pa_checks=i+r+p+cp+s+uml \
     -o discard_opt

if {[batch_mode]} {
    quit -f
}
