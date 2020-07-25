debug=1; 

debugFrames=1*debug;

// Select part to render/print
part=0; // [ 0:All, 1:Raspi A1 +LCD Housing, 2:Bottom Lid ,3:Bottom Lid with Mounting holes]

// Border for walls 
border=1.3;
// Border thinner walls 
border1=1;

// Add Space to fit
addSpace=.3;
addSpaceXYZ=addSpace*[1,1,1];
addSpace2XYZ=addSpace*2*[1,1,1];

// Dimensions Wemos D1 Mini
raspberryPiA1=[62,53.2,14.8]+addSpace*[2,2,2];
raspberryPiA1Lcd=[36.7,30.2,2.66]+addSpace*[2,2,2];


// -----------------------------------------------------------------
// do not need to modify anything below here
// -----------------------------------------------------------------
/* [Hidden] */

// Number of segments in circle
$fn=25;

difference(){
    showPart(part=part);
 
    // for Debugging 
    // to see inside Objects
    // cube to cut object apart 
    if ( 0 * debug ) 
        translate([59,-2,-11.1]) 
        // translate([-14,2,-31.1]) 
            cube([120,190,55]);
} 

// Show the selected part
// part=0 shows all parts in a grid
module showPart(part=0){
    if ( part == 0) showAllParts();
    
	if ( part == 1) RaspberryPiA1Housing(placeForPrint=1);
	if ( part == 2) bottomLid(placeForPrint=1,numberOfBaseMountingClips=0);
    if ( part == 3) bottomLid(placeForPrint=1,numberOfBaseMountingClips=4);
 
    // Part Ids for Debugging
	if ( part == 11) RaspberryPiA1Housing(placeForPrint=0);
	if ( part == 12) {
		translate([0,0,0.1])	RaspberryPiA1Housing(placeForPrint=0);
		translate([1,3,0])	bottomLid(placeForPrint=0,numberOfBaseMountingClips=0,cutOut=0);
	}
	if ( part == 13) {
		translate([0,0,0.2])	RaspberryPiA1Housing(placeForPrint=0);
		translate([border,border,0])	bottomLid(placeForPrint=0,numberOfBaseMountingClips=4,cutOut=0);
	}			
    
    if ( debug ) {
        if ( part == 21 ) raspberryPiCutOut();
        if ( part == 22 ) bottomLid(placeForPrint=1,cutOut=1);       
    }
}


module RaspberryPiA1Housing(
    numberOfBaseMountingClips=0,
    placeForPrint=0
    ){

    connectionHeight=10;
	offsetX=0;
    borderX=4;
    
    outerSize=[ 1*raspberryPiA1[0] + 2*border,
                1*raspberryPiA1[1] + 2*border,
                1*raspberryPiA1[2] + 2*border
                 +raspberryPiA1Lcd[2]
                ]
               +[2*borderX,0,0];
    
     translate( placeForPrint*[outerSize[0],0,outerSize[2]] )
		rotate(placeForPrint*[0,180,0]) {
		    difference(){
                cube(outerSize);
                
                
		        // Rspberry Pi cutOut
		        translate( border * [1,1,2] 
		                  + borderX*[1,0,0]) 
		            raspberryPiCutOut();
		
                
		        // remove border bottom
		        translate([borderX,1,0]
		                    +border*[0,1,0]
		                    +addSpace*[-1,-1,-1])
		            bottomLid(cutOut=1);
	        }
        }
}


// Cut out for Raspery Pi including LCD
module raspberryPiCutOut(){
        hBase=raspberryPiA1[2];
        height=hBase
            +raspberryPiA1Lcd[2];
 
        // Base Raspi
       cube(raspberryPiA1 + [.1,.1,.1]);
       
        // LCD
        deltyX=14.4;
        deltaY=raspberryPiA1[1]-raspberryPiA1Lcd[1];
        translate([deltyX,deltaY,hBase]-addSpaceXYZ)
            cube(raspberryPiA1Lcd
                +addSpace2XYZ
                +[.1,.1,.1]);
        
        // Mini Usb cutOut
       translate([5.6,-border-1,4]-addSpaceXYZ)
            cube([10.4,15,6.6]+addSpace2XYZ); 

        //  HDMI Cut Out
       translate([22.4,-border-1,3.6]-addSpaceXYZ)
            cube([18.9,15,10.5]+addSpace2XYZ); 

        // Audio Cut out
       translate([54.2,-border-1,6.6]-addSpaceXYZ)
            rotate([-90,0,0])
                cylinder(h=12,d=9); 

        // Usb-Out cutOut
       translate([raspberryPiA1[0],23.3,4.5]-addSpaceXYZ)
            cube([10.4,15,6.6]+addSpace2XYZ); 

        // SD-Card
       translate([-5,22.6,1.2]-addSpaceXYZ)
            cube([10,11,2]); 

        // Buttons (y=[start:step:end])
        for (y=[7.4:3.5+2.4:19.3]){
            translate([5.2,raspberryPiA1[1]-y+border,hBase-.1]-addSpaceXYZ)
                cube([6.0,3.6,7]+addSpace2XYZ); 
        }

        // JoyStick
        translate([58,41,hBase-.1])
            cylinder(h=12,d=5); 
    
}




module bottomLid(cutOut=0,placeForPrint=0,numberOfBaseMountingClips=0){
    bottomHeight=2.5;
    addY=0;
    addYcutOut=.0*cutOut;
    
    
    X= raspberryPiA1[0] + 2*border + cutOut*addSpace*2;
    Y= raspberryPiA1[1] + 1*border + cutOut*addSpace*2 
        + addY +addYcutOut;
                
//    color("green")
    translate(placeForPrint*[14,19,bottomHeight]){
        difference(){
            union(){
                // large bottom plate
                bottomBorderX=4.5;
                bottomBorderY=3;
                //JOS
                
                basePlate=[X+2*bottomBorderX,Y+2*bottomBorderY,bottomHeight];
                translate([-bottomBorderX,-bottomBorderY,
                            -bottomHeight+cutOut*addSpace]) {
                    cube(basePlate);
		        
		        	// Base Mount Clips
			    	translate([0,0,0]) 
			        	BaseMountingClips(
			            	numberOfBaseMountingClips=numberOfBaseMountingClips,
			            	outerSize=basePlate);
	            	}
                
                // fit size of Rspberry Pi
                cube(
                        [X,Y, 2*border  +cutOut*addSpace*2]);

                // small fitting brim to allow sliding Housing into Bottom plate
                sizeFitting=1.1;
                translate(sizeFitting*[-1,-1,0]+[0,0,1.2])
                    cube(
                        [X,Y, cutOut*addSpace]
                        +sizeFitting*[2,2,1]);
                
                
                // small fitting brim snap Housing into fixed position against Bottom plate
                sizeSnap=.8;
                translate(sizeSnap*[0,-1,0]
                        +[0,Y-5, 2*border  +cutOut*addSpace*2-.1])
                    cube(
                        [X,0, 0]
                        +sizeSnap*[0,2,1]);

            }
        }


    }
}


module BaseMountingClips(numberOfBaseMountingClips=4,outerSize=10){

    diameterBaseClipHoles=3;
    
    outerSizeX = outerSize[0];
    outerSizeY = outerSize[1];
    outerSizeZ = outerSize[2];


    yRange= (numberOfBaseMountingClips==4) ? [5.5,outerSizeY-5.5]
                :(numberOfBaseMountingClips==2) ? [outerSizeY/2] : [];

    
    for( x=[0,outerSizeX]){
        for( y=yRange){
            translate([x,y,0])
    	    rotate([0,0,(x > 0.01?-90:90)])
    	        BaseMountingClip(diameterBaseClipHoles=diameterBaseClipHoles);
        }
    }
}

module BaseMountingClip(diameterBaseClipHoles=3){
    diameterSkrewHead=diameterBaseClipHoles+4;
    reinforcementX=1.5;
    sizeBaseMountX=diameterSkrewHead + 1 + 2*reinforcementX;
    sizeBaseMountY=diameterSkrewHead + 3;
    sizeBaseMountZ=2.5;
    
    translate([-sizeBaseMountX/2,0,0])
    union(){
        difference(){
        	
            cube([sizeBaseMountX,sizeBaseMountY,sizeBaseMountZ]);

            // central hole for screw
            translate([sizeBaseMountX/2,sizeBaseMountY/2,-0.01])
                cylinder(d=diameterBaseClipHoles,h=sizeBaseMountZ+1);

            //  hole for screw-head
            translate([sizeBaseMountX/2,sizeBaseMountY/2,2])
                cylinder(d=diameterSkrewHead,h=sizeBaseMountZ+1);
        }
    }        
}

// place all Partes in a grid
module showAllParts(){
    distX=100;  maxX=5;
    distY=100; maxY=5;

    for ( i = [1:maxX] )
        for ( j = [0:maxY] )
            translate([ (i-1)*distX, j*distY, 0]){
                showPart(part= i + j*10);
                if ( debugFrames ) 
                    debugFrame(size=[distX-3,distY-3,1]);
            }
}

module debugFrame( size=[60,60,2], border=.3) {
    translate([0,0,-size[2]])
	    color("white") 
		    difference(){
		        cube(size);
		        translate( [0, 0, .01]
		        		 + border*[1, 1, 0])
		            cube(size - 2*border*[1,1,0]+[0,0,size[2]]);
		    }
}
