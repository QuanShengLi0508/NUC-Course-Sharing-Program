#!/bin/sh  
#
# Copyright 1991-2012 Mentor Graphics Corporation
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
# PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
# LICENSE TERMS.
#
# Simple SystemVerilog UCDB Example - Simulation shell script
#
# Usage:     Help/usage ..................... doit.sh
#            Run ucdbcrawl example .......... doit.sh run [platform]
#            Clean directory ................ doit.sh clean
#
if [ "$1" = "clean" ] ; then
    rm -f transcript *.wlf core* *.log workingExclude.cov
    rm -f *.dll *.exp *.lib *.obj *.sl *.o *.so *.ucdb ucdbcrawl ucdbcrawl.out
    rm -f vsim_stacktrace.vstf
    rm -rf work
    exit 0
fi

if [ "$1" != "run" ] ; then
    echo ""
    echo "### Help/Usage ..................... doit.sh"
    echo "### Run ucdbcrawl example .......... doit.sh run [platform]"
    echo "### Clean directory ................ doit.sh clean"
    echo ""
fi

# The rest of the script is "run"
rm -rf work
vlib work
if [ $? -ne 0 ]; then
    echo "ERROR: Couldn't run vlib. Make sure \$PATH is set correctly."
    exit 0
fi
if [ -z "$MTI_HOME" ] ; then
    echo "ERROR: Environment variable MTI_HOME is not set"
    exit 0
fi
`vsim -version | grep "64 vsim" > /dev/null`
if [ $? -eq 0 ]; then
    MTI_VCO_MODE=64
else
    MTI_VCO_MODE=32
fi
export MTI_VCO_MODE
if [ "X$2" != "X" ] ; then
	platform=$2
	echo "Platform set to $platform"
else
	platform=`$MTI_HOME/vco`
fi
rm -f *.o *.dll *.so

case `uname` in
Linux)
    gccversion=`gcc -dumpversion | awk -F. '{print $1}'`
    machine=`uname -m`
    if [ "$gccversion" = "2" -o "$machine" = "ia64" ] ; then
        CC="gcc -g -c  -Wall -I. -I$MTI_HOME/include"
        LD="gcc -lm -Wl,-export-dynamic -o "
    elif [ "$MTI_VCO_MODE" = "64" ] ; then
        CC="gcc -g -c -m64 -Wall -I. -I$MTI_HOME/include"
        LD="gcc -lm -m64 -Wl,-export-dynamic -o "
    else
        CC="gcc -g -c -m32 -Wall -I. -I$MTI_HOME/include"
        LD="gcc -lm -m32 -Wl,-export-dynamic -o "
    fi
    LDLIB="ucdbcrawl.o ucdb_print.o $MTI_HOME/$platform/libucdb.a"
    ;;
SunOS)
    if [ "$gccversion" = "2" ] ; then
        CC="gcc -g -c -I. -I$MTI_HOME/include"
        LD="gcc -ldl -lm -o "
    elif [ "$MTI_VCO_MODE" = "64" ] ; then
        CC="gcc -g -m64 -c -I. -I$MTI_HOME/include"
        LD="gcc -ldl -lm -m64 -o "
    else
        CC="gcc -g -m32 -c -I. -I$MTI_HOME/include"
        LD="gcc -ldl -lm -m32 -o "
    fi
    LDLIB="ucdbcrawl.o ucdb_print.o $MTI_HOME/$platform/libucdb.a"
    ;;
Win*|CYGWIN_NT*)
    CC="cl -c -Ox -Oy /MD -I $MTI_HOME/include "
    LD="link"
    LDLIB="ucdbcrawl.obj ucdb_print.obj $MTI_HOME/$platform/libucdb.lib"
    ;;
*)
    echo "Script not configured for `uname`, see User's manual."
    exit 0
    ;;
esac

echo ""
echo "### NOTE: Running ucdbcrawl example ..."
echo ""

vlog -cover bsectf -sv sink.sv
vcom -cover bsectf sink.vhd
vsim -togglenovlogints -coverage -c top -do sim.do
$CC ucdbcrawl.c
$CC ucdb_print.c
$LD ucdbcrawl $LDLIB
ucdbcrawl sink.ucdb < ucdbcrawl.in > ucdbcrawl.out
exit 0
