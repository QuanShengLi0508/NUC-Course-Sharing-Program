#
# Copyright 1991-2012 Mentor Graphics Corporation
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
# WHICH IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION
# OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
#
# Use this run.do file to run this example.
# Either bring up the Simulator and type the following at the "Simulator>" prompt:
#     do run.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -do run.do -c
# (omit the "-c" to see the GUI while running from the shell)
# Remove the "quit -f" command from this file to view the results in the GUI.
#

onbreak {resume}

# Create the library.
if [file exists work] {
    vdel -all
}
vlib work
 
# Compile the source files.
vlog gates.v and2.v cache.v memory.v proc.v set.v top.v

# Optimize the design.
vopt +acc top -o top_opt

# Collect combinatorial and sequential logic data into the work library.
vdbg top_opt

# Load simulator with optimized design.
vsim -debugdb top_opt
add wave /top/p/*
add log -r /*
run -all

