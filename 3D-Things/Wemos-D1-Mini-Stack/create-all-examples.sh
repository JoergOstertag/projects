#!/bin/bash

#date=`date -I`
#date=`date +%d.%m.%Y-%H-%M-%S`
date=`date +%Y-%m-%d_%H-%M`

scadFile="wemos_stack.scad"
scadBin="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
if ! [ -s "$scadBin" ]; then
	scadBin="/Applications/MacPorts/OpenSCAD.app/Contents/MacOS/OpenSCAD"
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
	echo "$@"
	outName="$1"
	shift 1
	$scadBin "$scadFile" -o "wemos_stack-$outName" "$@"
}  


function generateAllFiles {
	generateStl Led-Lid.stl      -D 'showBase=0' -D 'lidCutOutType="LED"' 
	generateStl Led-Base.stl     -D 'showLid=0' -D 'innerHeightZ=19.7' -D'batteryHeight=0' -D'dcPowerHeight=0' -D'relayHeight=0'  

	generateStl Lcd-Lid.stl      -D 'showBase=0' -D 'lidCutOutType="LCD"' 
	generateStl Dht-Lid.stl      -D 'showBase=0' -D 'lidCutOutType="DHT"' 
	generateStl Button-Lid.stl   -D 'showBase=0' -D 'lidCutOutType="BUTTON"' 
	generateStl Pinouts-Lid.stl  -D 'showBase=0' -D 'lidCutOutType="NONE"'  -D'lidHasVisiblePinoutSlits=1' 
	generateStl Closed-Lid.stl   -D 'showBase=0' -D 'lidCutOutType="NONE"'  -D'lidHasVisiblePinoutSlits=0' 

	generateStl Mini-Base.stl    -D 'showLid=0' -D 'innerHeightZ=4'    -D'batteryHeight=0' -D'dcPowerHeight=0' -D'relayHeight=0'  
	generateStl Solo-Base.stl    -D 'showLid=0' -D 'innerHeightZ=6.8'  -D'batteryHeight=0' -D'dcPowerHeight=0' -D'relayHeight=0'  
	generateStl LCD-Base.stl     -D 'showLid=0' -D 'innerHeightZ=18.4' -D'batteryHeight=0' -D'dcPowerHeight=0' -D'relayHeight=0'  
	generateStl DHT-Base.stl     -D 'showLid=0' -D 'innerHeightZ=19.7' -D'batteryHeight=0' -D'dcPowerHeight=0' -D'relayHeight=0'  
	generateStl Relay-Base.stl   -D 'showLid=0' -D 'innerHeightZ=30.3' -D'batteryHeight=0' -D'dcPowerHeight=0' -D'relayHeight=14.5'  

	generateStl All-Once.stl -D 'showBase=0' -D 'showLid=0' -D 'showExamples=1' -D 'showAllOnce=true'

	generateStl All-Examples.stl -D 'showBase=0' -D 'showLid=0' -D 'showExamples=1' 
	generateStl All-Examples.png -D 'showBase=0' -D 'showLid=0' -D 'showExamples=1' 
}



if false ; then
# ==================================================================
mkdir -p MyVersion
perl -p \
	-e 's/showExamples=.+?;/showExamples=false;/;' \
	-e 's/showAllOnce=.+?;/showAllOnce=false;/;' \
	-e 's/extraGap=.+?;/extraGap=0.4;/;' \
    -e 's/printerWobble=.+?;/printerWobble=0.101;/;' \
	< "$scadFile" \
	> "MyVersion/$scadFile"

(
	cd MyVersion
	mkdir Old
	mv *.stl Old
	mv *.png Old
	generateAllFiles
)
fi

# ==================================================================
mkdir -p Upload
perl -p \
	-e 's/showExamples=.+?;/showExamples=false;/;' \
	-e 's/showAllOnce=.+?;/showAllOnce=false;/;' \
	-e 's/extraGap=.+?;/extraGap=0.2;/;' \
    -e 's/printerWobble=.+?;/printerWobble=0.01;/;' \
	< "$scadFile" \
	> "Upload/$scadFile"

(
	cd Upload 
	mkdir Old
	mv *.stl Old
	mv *.png Old
	generateAllFiles
)

