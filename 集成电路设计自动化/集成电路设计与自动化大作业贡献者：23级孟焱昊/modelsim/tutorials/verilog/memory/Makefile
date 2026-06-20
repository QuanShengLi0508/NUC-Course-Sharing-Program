

build:
	-vlib work
	vlog -novopt sp_syn_ram.v dp_syn_ram.v ram_tb.v

sim:
	vsim -novopt ram_tb 

clean:
	/bin/rm -rf work transcript vsim.wlf data_mem.mem reloc.mem
