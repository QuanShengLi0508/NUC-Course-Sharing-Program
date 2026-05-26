* SPICE export by:  S-Edit 16.30
* Export time:      Mon Dec 22 15:18:58 2025
* Design:           Dsuocun
* Cell:             Dlatch
* Interface:        view0
* View:             view0
* View type:        connectivity
* Export as:        top-level cell
* Export mode:      hierarchical
* Exclude empty cells: no
* Exclude .model:   yes
* Exclude .end:     no
* Exclude simulator commands:     no
* Expand paths:     yes
* Wrap lines:       80 characters
* Root path:        D:\BaiduNetdiskDownload\tanner1\NAND2\yuanlitu\Dsuocun
* Exclude global pins:   no
* Exclude instance locations: no
* Control property name(s): SPICE
********* Simulation Settings - General Section *********
*************** Subcircuits *****************
.subckt inv In Out Gnd Vdd 
MNMOS_1 Out In Gnd Gnd NMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=-100 
+$y=-1100 $w=400 $h=600
MPMOS_1 Out In Vdd Vdd PMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=-100 
+$y=200 $w=400 $h=600
.ends
.subckt NAND2 A B Y Gnd Vdd 
MNMOS_1 Y A N_1 Gnd NMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=1200 
+$y=-700 $w=400 $h=600
MNMOS_2 N_1 B Gnd Gnd NMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=1200 
+$y=-1600 $w=400 $h=600
MPMOS_1 Y B Vdd Vdd PMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=-100 
+$y=300 $w=400 $h=600
MPMOS_2 Y A Vdd Vdd PMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=1200 
+$y=300 $w=400 $h=600
.ends
***** Top Level *****
Xinv_1 D N_3 Gnd Vdd inv $ $x=-1400 $y=-1200 $w=1600 $h=1600
XNAND2_1 D CLK N_1 Gnd Vdd NAND2 $ $x=1300 $y=1000 $w=2000 $h=1801
XNAND2_2 N_1 NQ Q Gnd Vdd NAND2 $ $x=3800 $y=1000 $w=2000 $h=1801
XNAND2_3 CLK N_3 N_2 Gnd Vdd NAND2 $ $x=1200 $y=-1100 $w=2000 $h=1801
XNAND2_4 Q N_2 NQ Gnd Vdd NAND2 $ $x=3700 $y=-1100 $w=2000 $h=1801
********* Simulation Settings - Analysis Section *********
********* Simulation Settings - Additional SPICE Commands *********
.lib "D:\BaiduNetdiskDownload\tanner1\Dsuocun\library\Models\Generic_025.lib"tt
.tran 1n 1000 start=0
.end

