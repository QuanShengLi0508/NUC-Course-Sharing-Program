##############################################################################
# Source:    setup.csh
# Author:    Keith R. Gover
# Date:      March 26, 2009
# Modified:  May 27, 2009
# File:      Environment setup script for Questa/ModelSim
# Remarks:   Mentor Low Power example
##############################################################################
echo ""
echo "Questa Environment Setup:"

# setup path to Questa installation
setenv QUESTA_HOME $HOME/tools/questasim
echo "    Using QUESTA_HOME = $QUESTA_HOME"
alias mhome "pushd $QUESTA_HOME"

# setup licensing
setenv LM_LICENSE_FILE "1700@licsvr"
echo "    Using LM_LICENSE_FILE = $LM_LICENSE_FILE"
echo ""

# setup PATH
set path = ($QUESTA_HOME/linux $path)
