
* SPICE export by:  S-Edit 16.30
* Export time:      Wed Dec 31 12:55:47 2025
* Design:           finv
* Cell:             Cell0
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
* Root path:        D:\BaiduNetdiskDownload\example1\finv
* Exclude global pins:   no
* Exclude instance locations: no
* Control property name(s): SPICE
********* Simulation Settings - General Section *********
***** Top Level *****
MNMOS_1 Out In Gnd Gnd NMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=-500 
+$y=-1000 $w=400 $h=600
MPMOS_1 Out In Vdd Vdd PMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=-500 
+$y=100 $w=400 $h=600
VVoltageSource_1 Vdd Gnd  DC 5 $ $x=-1800 $y=700 $w=400 $h=600
VVoltageSource_2 In Gnd  PULSE(0 5 0 5n 5n 95n 200n) $ $x=-2500 $y=-500 $w=400 $h=600
.PRINT TRAN V(In) $ $x=-1250 $y=-1450 $w=1500 $h=300
.PRINT TRAN V(Out) $ $x=1450 $y=-250 $w=1500 $h=300

********* Simulation Settings - Analysis Section *********

********* Simulation Settings - Additional SPICE Commands *********
.lib "D:\BaiduNetdiskDownload\example1\finv\library\Models\Generic_025.lib"tt
.tran 1n 1000n start=0
.end

