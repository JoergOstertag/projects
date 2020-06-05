#!/bin/bash

# This script takes all *.scad Files and creates png and stl files for them
# if a parts=.. line is found it iterates over these and generates one set of files for each

DO_GENERATE_STL=true
DO_GENERATE_PNG=true


scadBin="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
if ! [ -s "$scadBin" ]; then
	scadBin="/Applications/MacPorts/OpenSCAD.app/Contents/MacOS/OpenSCAD"
fi
if ! [ -s "$scadBin" ]; then
    scadBin="/usr/bin/openscad"
fi
if ! [ -s "$scadBin" ]; then
    scadBin="/cygdrive/c/Program Files/OpenSCAD/openscad.exe"
fi
if ! [ -s "$scadBin" ]; then
	echo "!!!!!!!! ERROR: missing Scad Binary"
	exit -1;
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

	partDefinition=""
	baseName="stl/$fileName"
	if [ -n "$patNumber" ]; then
	    partDefinition=" -D 'part=$partNumber' "
	    baseName="stl/$fileName-part-$partNumber-$name"
	fi


	if $DO_GENERATE_STL ; then
	    stlName="$baseName.stl"
	    echo "Generate '$stlName'"
	    $scadBin "$scadFile" -o "$stlName" $partDefinition -D 'debug=0' "$@"
	fi

	if $DO_GENERATE_PNG ; then
	    pngName="$baseName.png"
	    echo "Generate '$pngName'"
	    $scadBin "$scadFile" -o "$pngName" $partDefinition -D 'debug=0' "$@"
	fi
}  

function generateAllFiles {
    if grep -q  -e 'part=.*\[' "$scadFile" ; then
	grep -e 'part=.*\[' "$scadFile" | \
    	    perl -pe 's/.*\[//;s/\].*//; s/:/ /gs; s/,/\n/gs' | \
	    while read number name; do
		generateStl $number "$name" "$@"
	    done
    else
	generateStl "" "" "$@"
    fi
    
}


find . -name "*.scad" | while read a ; do echo `dirname "$a"`; done | sort -u >/tmp/scadDirts.txt

cat /tmp/scadDirts.txt | while read dir; do
    (
	cd $dir
	echo "Create Files in $dir"

	
	# ==================================================================
	mkdir -p stl
	if $DO_GENERATE_STL ; then
	    rm -f stl/*.stl
	fi
	if $DO_GENERATE_PNG ; then
	    rm -f stl/*.png
	fi
	
	# ==================================================================
	for scadFile in *.scad; do
	    
	    fileName="${scadFile%.scad}"
	    
	    if ! [ -s "$scadFile" ]; then
		echo "!!!!!!!! ERROR: missing FIle $scadFile"
		exit;
	    fi

	    if $DO_GENERATE_STL_PNG ; then
  		generateAllFiles
	    fi

	    find stl -name "*.png" | while read f ; do
		name="`basename $f`"
		name="${name%.png}"
		echo "![$name]($f)"
	    done >README-images.md
	done
    )
done

exit
