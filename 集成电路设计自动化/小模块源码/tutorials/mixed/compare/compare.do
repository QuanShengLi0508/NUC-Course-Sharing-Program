#Copyright 1991-2012 Mentor Graphics Corporation
#
#All Rights Reserved.
#
#THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
#MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.

vlib work
vmap work work
vlog -novopt cache.v memory.v proc.v
vcom -novopt util.vhd set.vhd top.vhd
vsim -novopt -wlf gold.wlf work.top
add wave *
onbreak {resume}
run -all
quit -sim
