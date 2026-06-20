#!/bin/sh  
#
# Copyright 2012 Mentor Graphics Corporation
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
# PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
# LICENSE TERMS.
#
# UCDB API User Guide Examples: hierarchical execution script
#
# Usage:     Help/usage ..................... doit.sh
#            Run example .................... doit.sh run
#            Clean directory ................ doit.sh clean
#

if [ "$1" = "clean" ] ; then
	for dir in *
	do
		if [ -d $dir ]
		then 
			cd $dir
			echo "Cleaning in $dir ..."
			doit.sh clean
			cd ..
		fi
	done
    exit 0
fi

if [ "$1" != "run" ] ; then
    echo ""
    echo "Run or clean in all sub-directories:"
    echo ""
    echo "### Help/Usage ..................... doit.sh"
    echo "### Run example .................... doit.sh run"
    echo "### Clean directory ................ doit.sh clean"
    echo ""
	exit 0
fi

# The rest of the script is "run"
for dir in *
do
	if [ -d $dir ]
	then 
		cd $dir
		echo "Running in $dir ..."
		doit.sh run
		cd ..
	fi
done
exit 0
