onerror {quit}

# Create work library

file delete -force work
vlib work

# Create or clear the Triage database (TDB) file

triage dbfile -name top.tdb -clear

# Compile the example design

vlog -coverAll top.sv

# Run a series of three tests with different errors/warnings/notes

foreach TEST {top1 top2 top3} {
  switch $TEST {
    top1 {
      vsim -c top -assertdebug -coverage -novopt -wlf top1.wlf -l top1.log
    }
    top2 {
      vsim -c top -assertdebug -coverage -novopt -wlf top2.wlf -l top2.log +warning
    }
    top3 {
      vsim -c top -assertdebug -coverage -novopt -wlf top3.wlf -l top3.log +warning +error
    }
  }

  echo "Running test $TEST..."
  run -all

  echo "Setting TESTNAME to $TEST..."
  coverage attr -name TESTNAME -value $TEST

  echo "Saving UCDB file..."
  coverage save $TEST.ucdb

  echo "Quitting simulation..."
  quit -sim

  echo "Importing UCDB into triage database..."
  triage dbfile -verbose -name top.tdb \
    -teststatusAll -severityAll -rulesfile top.xform $TEST.ucdb
}

echo "Generating Triage report..."
triage report -name top.tdb

quit -f
