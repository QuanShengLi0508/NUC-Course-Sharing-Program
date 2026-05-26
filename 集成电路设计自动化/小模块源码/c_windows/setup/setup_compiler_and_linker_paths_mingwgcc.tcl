quietly set platform [file tail $env(MODEL_TECH)]
# Check if 64-bit executables are being run.
if {[string match "*64 vsim*" [vsim -version]]} {
	quietly set is64bit 1
	quietly set gcc_path "$INSTALL_HOME/gcc-4.5.0-mingw64/bin"
	quietly set mingw_gcc_exists [file exists  "$INSTALL_HOME/gcc-4.5.0-mingw64/bin/gcc.exe"]
	quietly set builtin_compiler "gcc-4.5.0-mingw64.zip"
} else {
	quietly set is64bit 0
	quietly set gcc_path "$INSTALL_HOME/gcc-4.2.1-mingw32vc9/bin"
	quietly set mingw_gcc_exists [file exists  "$INSTALL_HOME/gcc-4.2.1-mingw32vc9/bin/gcc.exe"]
	quietly set builtin_compiler "gcc-4.2.1-mingw32vc9.zip"
}

if {$mingw_gcc_exists != 1} {
	echo "Please download and install $builtin_compiler from the Mentor ftp site."
	echo "Using cygwin gcc is not supported."
	quit -f
}

quietly set env(PATH) "$gcc_path;$::env(PATH)"
# quietly setup - quietly set path to the C compiler and linker.
if {$is64bit == 1 } {
	quietly set CC "gcc -g -c -m64 -Wall -I. -I$INSTALL_HOME/include "
	quietly set LD "gcc -shared -lm -m64 -Wl,-Bsymbolic -Wl,-export-all-symbols -o "
	quietly set UCDB_LD "gcc -lm -m64 -o "
} else {
	quietly set CC "gcc -g -c -m32 -Wall -ansi -pedantic -I. -I$INSTALL_HOME/include "
	quietly set LD "gcc -shared -lm -m32 -Wl,-Bsymbolic -Wl,-export-dynamic -o "
	quietly set UCDB_LD "gcc -lm -m32 -o "
}
quietly set MTIPLILIB " -L$INSTALL_HOME/$platform -lmtipli"
quietly set UCDBLIB " -L$INSTALL_HOME/$platform -lucdb"
quietly set ext "dll"
