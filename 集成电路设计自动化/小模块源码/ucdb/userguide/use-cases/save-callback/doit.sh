#!/bin/sh
#
# Copyright 2012 Mentor Graphics Corporation
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
# PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
# LICENSE TERMS.
#
# Example of UCDB Save Callback in FLI
#
# Usage:     Help/usage ..................... doit.sh
#            Run example .................... doit.sh run
#            Clean directory ................ doit.sh clean
#

if [ "$1" = "clean" ] ; then
    rm -f transcript *.wlf core* *.log workingExclude.cov
    rm -f *.dll *.exp *.lib *.obj *.sl *.o *.so
    rm -f vsim_stacktrace.vstf *.h
    rm -rf work
	rm -rf test.ucdb
    exit 0
fi

if [ "$1" != "run" ] ; then
    echo ""
    echo "### Help/Usage ..................... doit.sh"
    echo "### Run example .................... doit.sh run"
    echo "### Clean directory ................ doit.sh clean"
    echo ""
fi

# The rest of the script is "run"
testname=ucdbsave
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
platform=`uname`
`vsim -version | grep "64 vsim" > /dev/null`
if [ $? -eq 0 ]; then
    is64bit=1
else
    is64bit=0
fi
rm -f *.o *.dll *.so

LIBPATH=

case $platform in
Linux)
    gccversion=`gcc -dumpversion | awk -F. '{print $1}'`
    machine=`uname -m`
    if [ "$gccversion" = "2" -o "$machine" = "ia64" ] ; then
        CC="gcc -g -c -fPIC -Wall -ansi -I. -I$MTI_HOME/include"
        LD="gcc -shared -lm -Wl,-Bsymbolic -Wl,-export-dynamic -o "
    elif [ $is64bit -ne 0 ] ; then
        CC="gcc -g -c -m64 -fPIC -Wall -ansi -I. -I$MTI_HOME/include"
        LD="gcc -shared -lm -m64 -Wl,-Bsymbolic -Wl,-export-dynamic -o "
    else
        CC="gcc -g -c -m32 -fPIC -Wall -ansi -I. -I$MTI_HOME/include"
        LD="gcc -shared -lm -m32 -Wl,-Bsymbolic -Wl,-export-dynamic -o "
    fi
    ;;
SunOS)
    if [ "$gccversion" = "2" ] ; then
        CC="gcc -g -c -fPIC -I. -I$MTI_HOME/include"
    elif [ $is64bit -ne 0 ] ; then
        CC="gcc -g -m64 -c -fPIC -I. -I$MTI_HOME/include"
    else
        CC="gcc -g -m32 -c -fPIC -I. -I$MTI_HOME/include"
    fi
    LD="/usr/ccs/bin/ld -Bsymbolic -G -o"
    ;;
Win*|CYGWIN_NT*)
    CC="cl -c -Ox -Oy /MD -DWIN32 -I`cygpath -m $MTI_HOME/include` "
	LD="link -dll -export:vlog_startup_routines"
	PLILIB="$MTI_HOME/win32/mtipli.lib"
    LIBPATH=/LIBPATH:`regtool get '\\HKLM\\SOFTWARE\\Microsoft\\Microsoft SDKs\\Windows\\CurrentInstallFolder'`\\Lib
    LDLIB="`cygpath -d $MTI_HOME/$platform/libucdb.lib`"
    ;;
*)
    echo "Script not configured for $platform, see User's manual."
    exit 0
    ;;
esac

echo ""
echo "### NOTE: Running $testname example ..."
echo ""
vlog test.sv
$CC $testname.c
case $platform in
Win*|CYGWIN_NT*)
    $LD $testname.obj "$PLILIB" "$LIBPATH"
	OBJ=$testname.dll
    ;;
*)
	OBJ=$testname.so
    $LD $OBJ $testname.o
    ;;
esac
vsim -c top -pli $OBJ -do "run -all; coverage save test.ucdb; quit"
vcover report -cvg -details test.ucdb
exit 0
