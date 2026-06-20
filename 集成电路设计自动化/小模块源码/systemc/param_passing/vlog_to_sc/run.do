# Copyright 1991-2012 Mentor Graphics Corporation
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
# WHICH IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION
# OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.

# Use this run.do file to run this example.
# Either bring up ModelSim and type the following at the "ModelSim>" prompt:
#     do run.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -do run.do -c
# (omit the "-c" to see the GUI while running from the shell)

onbreak {resume}

proc set_vopt_arg {} {
    # the -novopt option is required for param passing w/Verilog
    # (for ModelSim LE, -novopt is the default behavior, there is no option)
    global vopt_arg
    set vsim_version_str [vsimAuth]
    set vopt_arg [ expr { [string match "LE*" $vsim_version_str] || \
                          [string match "PE*" $vsim_version_str] ?  \
                          "" : "-novopt" } ]
    return
}

set_vopt_arg

# create library
if [file exists work] {
    vdel -all
}
vlib work

# compile the Verilog source files
if {$vopt_arg == ""} {
    vlog *.v
} else {
    vlog $vopt_arg *.v
}

# compile and link C source files
sccom -g ringbuf.cpp
sccom -link

# open debugging windows
quietly view *

# start and run simulation
vsim $vopt_arg test_ringbuf
run 500000 ns
