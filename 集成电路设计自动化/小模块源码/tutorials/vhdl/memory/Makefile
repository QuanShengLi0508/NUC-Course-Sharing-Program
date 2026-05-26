

build:
	-vlib work
	vcom -novopt -93 sp_syn_ram.vhd dp_syn_ram.vhd ram_tb.vhd

sim:
	vsim -novopt ram_tb 

clean:
	/bin/rm -rf work transcript *.wlf data_mem.mem reloc.mem
