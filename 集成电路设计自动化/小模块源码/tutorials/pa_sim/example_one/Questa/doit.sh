#!/bin/sh
##############################################################################
# Source:    doit.sh
# Author:    Keith R. Gover
# Date:      March 26, 2009
# Modified:  May 27, 2009
# File:      Simulation shell script for running Questa/ModelSim
#
# Usage:     Help/usage ........................ doit.sh
#            Run RTL simulation ................ doit.sh demo
#            Clean directory ................... doit.sh clean
#
# Remarks:   Mentor Low Power example
##############################################################################
if [ "$1" = "clean" ] ; then
    rm -f transcript *.wlf core* *.log workingExclude.cov
    rm -f vsim_stacktrace.vstf *.dbg report.*
    rm -rf work_rtl
    exit 0
fi

if [ "$1" = "demo" ] ; then
    vsim -c -do ./scripts/compile_rtl.do
    vsim -c -do ./scripts/analyze_rtl.do
    vsim -do ./scripts/doit_rtl.do
    exit 0
fi

echo ""
echo "### Help/Usage ........................ doit.sh"
echo "### Run RTL simulation ................ doit.sh demo"
echo "### Clean directory ................... doit.sh clean"
echo ""
