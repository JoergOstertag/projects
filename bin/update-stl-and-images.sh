#!/bin/bash

# This script takes all *.scad Files and creates png and stl files for them
# if a parts=.. line is found it iterates over these and generates one set of files for each

DO_GENERATE_STL=true
DO_GENERATE_PNG=true

if echo "$@" | grep -e '--no-stl' ; then
	DO_GENERATE_STL=false
fi
if echo "$@" | grep -e '--no-png' ; then
	DO_GENERATE_PNG=false
fi


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
	echo "generateStl ( $@ )"
	scadFile="$1"
	shift 1
	fileName="$1"
	shift 1
	partNumber="$1"
	shift 1
	name="$1"
	shift 1

	echo "generateStl ( $scadFile, $fileName, $partNumber, $name	)"

	partDefinition=""
	baseName="stl/$fileName"
	if [ -n "$partNumber" ]; then
	    partDefinition=" -D part=$partNumber "
	    baseName="stl/$fileName-part-$partNumber-$name"
	fi


    stlName="$baseName.stl"
	if $DO_GENERATE_STL ; then
	    echo "Generate '$stlName' $partDefinition -D 'debug=0'"
	    "$scadBin" "$scadFile" -o "$stlName" $partDefinition -D 'debug=0'
    else
	    echo "Skip generating '$stlName' $partDefinition "
	fi

    pngName="$baseName.png"
	if $DO_GENERATE_PNG ; then
	    echo "Generate '$pngName' $partDefinition -D 'debug=0'"
	    "$scadBin" "$scadFile" -o "$pngName" $partDefinition -D 'debug=0'
    else
	    echo "Skip generating '$pngName' $partDefinition "
	fi
}  

function generateAllFiles {
    $DEBUG && echo "generateAllFiles ( $@ )"
    
    scadFile="$1"
	shift 1
    
    fileName="${scadFile%.scad}"
    
    if grep -q  -e 'part=.*\[' "$scadFile" ; then
		grep -e 'part=.*\[' "$scadFile" | \
	    	    perl -pe 's/.*\[\s*//;' \
	    	    	-e 's/\s*\].*//;' \
	    	    	-e 's/\s*:\s*/ /gs;' \
	    	    	-e 's/\s*,\s*/\n/gs' >/tmp/part-definitions-in-scad-file.txt
	    
	    echo "parts to create ...."
	    head -99 /tmp/part-definitions-in-scad-file.txt
	     
		echo "Start creating"
		cat /tmp/part-definitions-in-scad-file.txt | \
			while read number name; do
				generateStl "$scadFile" "$fileName" "$number" "$name" "$@"
		    done
    else
		generateStl "$scadFile" "$fileName" "" "" "$@"
    fi
    
}


# -----------------------------------------------
find . -name "*.scad" | while read a ; do echo `dirname "$a"`; done | sort -u >/tmp/scadDirectories.txt

echo "Directories to create files for ..."
cat /tmp/scadDirectories.txt
echo 

cat /tmp/scadDirectories.txt | while read dir; do
    (
	cd $dir
	echo
	echo "======================================================="
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
    
	    if ! [ -s "$scadFile" ]; then
			echo "!!!!!!!! ERROR: missing File $scadFile"
			exit;
	    fi

		generateAllFiles "$scadFile"
	done

	echo "Generated files in $dir/stl:"
	find stl 

	echo 
	echo "Generate $dir/README-images.md"
    find stl -name "*.png" | while read f ; do
		name=`basename "$f"`
		name="${name%.png}"
		name="${name//-/ }"
		name="${name//_/ }"
		echo "### $name"
		echo "![$name]($f)"
		echo
		
    done >README-images.md
    )
done

exit
