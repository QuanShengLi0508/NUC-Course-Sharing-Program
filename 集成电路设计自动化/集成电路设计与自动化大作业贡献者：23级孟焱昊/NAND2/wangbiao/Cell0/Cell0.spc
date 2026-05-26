* SPICE export by:  S-Edit 16.30
* Export time:      Mon Dec 22 11:36:15 2025
* Design:           2shuru
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
* Root path:        D:\BaiduNetdiskDownload\tanner1\NAND2\yuanlitu\2shuru
* Exclude global pins:   no
* Exclude instance locations: no
* Control property name(s): SPICE

********* Simulation Settings - General Section *********

***** Top Level *****
MNMOS_1 out A N_1 Gnd NMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=1800 
+$y=-600 $w=400 $h=600
MNMOS_2 N_1 B Gnd Gnd NMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=1800 
+$y=-1500 $w=400 $h=600
MPMOS_1 out B Vdd Vdd PMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=-100 
+$y=300 $w=400 $h=600
MPMOS_2 out A Vdd Vdd PMOS W=2.5u L=250n AS=2.25p PS=6.8u AD=2.25p PD=6.8u $ $x=1800 
+$y=400 $w=400 $h=600
VVoltageSource_1 Vdd Gnd  DC 5 $ $x=-2300 $y=600 $w=400 $h=600
VVoltageSource_2 In Gnd  PULSE(0 5 0 5n 5n 95n 200n) $ $x=-2200 $y=-800 $w=400 $h=600
.PRINT TRAN V(A) $ $x=-850 $y=950 $w=1500 $h=300
.PRINT TRAN V(B) $ $x=-850 $y=-1850 $w=1500 $h=300
.PRINT TRAN V(out) $ $x=3650 $y=-650 $w=1500 $h=300

********* Simulation Settings - Analysis Section *********

********* Simulation Settings - Additional SPICE Commands *********
.lib "D:\BaiduNetdiskDownload\tanner1\NAND2\library\Models\Generic_025.lib"tt
.tran 1n 1000 start=0


.end

