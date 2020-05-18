#!/bin/bash

#date=`date -I`
#date=`date +%d.%m.%Y-%H-%M-%S`
date=`date +%Y-%m-%d_%H-%M`

fileName="Housing-RDM6300-wemos-D1-Mini"
scadFile="$fileName.scad"
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

if ! [ -s "$scadFile" ]; then
	echo "!!!!!!!! ERROR: missing FIle $scadFile"
	exit;
fi
mkdir -p Archiv
cp "$scadFile" "Archiv/wemos_stack-${date}.scad"


function generateStl {
	echo "--------------------------------------------------------------------------------"
	echo
	# echo "$@"
	partNumber="$1"
	shift 1
	name="$1"
	shift 1
	echo "Generate '$fileName-part-$partNumber-$name.stl'"
	$scadBin "$scadFile" -o "$fileName-part-$partNumber-$name.stl" -D "part=$partNumber" -D 'debug=0' "$@"
	$scadBin "$scadFile" -o "$fileName-part-$partNumber-$name.png" -D "part=$partNumber" -D 'debug=0' "$@"
}  

function generateAllFiles {
    grep -e 'part=.*\[' < "$scadFile" | \
    	 perl -pe 's/.*\[//;s/\].*//; s/:/ /gs; s/,/\n/gs' | \
	 while read number name; do
	 generateStl $number "$name" "$@"
    done
}

# ==================================================================
mkdir -p Upload
perl -p \
	-e 's/debug=.+?;/debug=0;/;' \
	< "$scadFile" \
	> "Upload/$scadFile"

(
	cd Upload 
	mkdir Old
	mv *.stl Old
	mv *.png Old
	generateAllFiles
)

