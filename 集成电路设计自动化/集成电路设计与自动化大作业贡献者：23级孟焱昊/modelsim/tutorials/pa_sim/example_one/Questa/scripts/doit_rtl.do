##############################################################################
# Source:    doit_rtl.do
# Author:    Keith R. Gover
# Date:      March 26, 2009
# Modified:  May 27, 2009
# File:      Tcl script for compiling & simulating with Questa/ModelSim
# Remarks:   Mentor Low Power example
##############################################################################
onbreak {resume}
if {[batch_mode]} {
    onerror {quit -f}
}

echo "#"
echo "# NOTE: Starting simulator and running DEMO ..."
echo "#"
vsim work.interleaver_tester \
     -novopt \
     +nowarnTSCALE \
     +nowarnTFMPC \
     -l rtl.log \
     -wlf rtl.wlf \
     -L mtiPA \
     -pa \
     -assertdebug \
     +notimingchecks

# run simulation
do ./Questa/scripts/sim.do
