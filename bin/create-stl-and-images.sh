#!/bin/bash

scadBin="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
if ! [ -s "$scadBin" ]; then
	scadBin="/Applications/MacPorts/OpenSCAD.app/Contents/MacOS/OpenSCAD"
fi
if ! [ -s "$scadBin" ]; then
    scadBin="/usr/bin/openscad"
fi
if ! [ -s "$scadBin" ]; then
	echo "!!!!!!!! ERROR: missing Scad Binary"
	exit;
fi

###################################################################

function generateStl {
	echo "--------------------------------------------------------------------------------"
	echo
	# echo "$@"
	partNumber="$1"
	shift 1
	name="$1"
	shift 1
	echo "Generate '$fileName-part-$partNumber-$name.stl'"
	$scadBin "$scadFile" -o "stl/$fileName-part-$partNumber-$name.stl" -D "part=$partNumber" -D 'debug=0' "$@"
	echo "Generate '$fileName-part-$partNumber-$name.png'"
	$scadBin "$scadFile" -o "stl/$fileName-part-$partNumber-$name.png" -D "part=$partNumber" -D 'debug=0' "$@"
}  

function generateAllFiles {
    grep -e 'part=.*\[' < "$scadFile" | \
    	 perl -pe 's/.*\[//;s/\].*//; s/:/ /gs; s/,/\n/gs' | \
	 while read number name; do
	 generateStl $number "$name" "$@"
    done
}


# ==================================================================
mkdir -p stl
rm -f stl/*.stl
rm -f stl/*.png


# ==================================================================
for scadFile in *.scad; do

    fileName="${scadFile%.scad}"

    if ! [ -s "$scadFile" ]; then
	echo "!!!!!!!! ERROR: missing FIle $scadFile"
	exit;
    fi

    generateAllFiles

done

exit
