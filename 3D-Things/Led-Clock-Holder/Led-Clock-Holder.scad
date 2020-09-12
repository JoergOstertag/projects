// Switch on Debugging Features (show Debug Object, Show frames, cutout part to see inside)
debug=1;

// Switch on Debugging Feature cut-out part to see inside
debugCutOutToLookInside=0;

// Draw Frames around the raster-Squares
debugFrames=1*debug;

part=44; // [ 0:All, 1:Led in Cylinder with cable channel 2:Led in cylinder, 3: Cable channel, 4: Led in Cube, 5: 3 Segments of Led in Cylinder with cable channel 6:Complete Ring with Led and cable, 7: Ring of Led cubes with 5 Elements]

// Border for walls 
border=1.8;

// Add Space to fit
addSpace=.6;

// Number of LEDs in the Ring
numberOfLeds=50;

frontThickness=.4;

ledFrontD=7.8;
ledFrontH=3.9;
ledBackShellD=11.7;
ledBackShellH=23.8;
nibbleX=2.9;
nibbleY=1.2;
nibbleZ=ledBackShellH;


ledDistance=75;
cableW=5.5;
cableH=2.0;
clipX=1.9;
clipY=3;
clipZ=0.9;
cableChannelZ=cableH+border+clipZ;
cableChannelX=cableW+2*border;
cableChannelY=ledDistance;


cylinderOuterD=ledBackShellD+2*border+2*nibbleY;



difference(){
    showPart(part=part);
 
    // for Debugging 
    // to see inside Objects
    // cube to cut object apart 
    if ( debugCutOutToLookInside * debug ) 
        //translate([59,2,-11.1]) 
         translate([-54,-82,11.1]) 
            cube([120,190,55]);
    
} 

module showPart(part=0){
    if ( part == 0) showAllParts();
    
	if ( part == 1) LedAndCableShaft(forPrint=1);
	if ( part == 2) LedInCylinder();
	if ( part == 3) CableChannel();
    if ( part == 4) LedInCube();
	if ( part == 5) rotate([0,0,40]) CompleteRingLedAndCableShaft(noCenter=1,numElements=3);
	if ( part == 6) CompleteRingLedAndCableShaft();
    if ( part == 7 ) RingLedCubes(numElements=5);
    
    if ( debug ) {
		if ( part == 11 ) LedAndCableShaft(forPrint=0);
        if ( part == 12 ) LedCutout();
        if ( part == 13 ) CableChannel();
        if ( part == 14 ) CylinderHolder();
    }
}



module RingLedCubes(noCenter=1,numElements=0){
	X=ledBackShellD+2*border+2*nibbleY;
	Z=ledBackShellD+2*border+2*nibbleY;
    Y=ledFrontD/2+ledBackShellH+ledFrontH+frontThickness+cableChannelZ-.01;
    u=(X)*numberOfLeds;
    d=u/PI/2;
	anglePerLed=360/numberOfLeds;
	maxDegrees=( numElements>0)?anglePerLed*numElements-1:360;
    translate([0,-noCenter*d,0])
    for ( winkel=[0:anglePerLed:maxDegrees] )
        rotate([0,0,winkel]){
            translate([0,d,0]){
            		LedInCube(forPrint=1);
                }
        	}
}
    


module LedInCube(){
    difference(){
        X=ledBackShellD+2*border+2*nibbleY;
        Y=ledFrontD/2+ledBackShellH+ledFrontH+frontThickness+cableChannelZ-.01;
        Z=ledBackShellD+2*border+2*nibbleY;
    
		union(){
	        translate([-X/2,0,0])
        		cube([X,Y,Z]);		
     
     			// Cable Cube
		        xCube=X+2;
		        yCube=22;
		        translate([-xCube/2,-yCube+.1,0])
		        	cube([xCube,yCube,Z]);
		}
	   
	   	translate([0,Y-frontThickness,Z/2])
	    	rotate([0,-90,90]) 
	        	LedCutout(cablesNonStreight=0);
		}
    
}


module CompleteRingLedAndCableShaft(noCenter=1,numElements=0){
    u=(cableChannelY)*numberOfLeds;
    d=u/PI/2;
	anglePerLed=360/numberOfLeds;
	maxDegrees=( numElements>0)?anglePerLed*numElements-1:360;
    translate([noCenter*d,0,0])
    for ( winkel=[0:anglePerLed:maxDegrees] )
        rotate([0,0,winkel]){
            translate([-d,0,0])
                rotate([0,0,180-anglePerLed/2])
                    LedAndCableShaft(forPrint=1);
        	}
}
    
        
    
module LedAndCableShaft(forPrint=0){
    Z=ledFrontD/2+ledBackShellH+ledFrontH+frontThickness-.01;
	translate(forPrint*[0,0,Z+cableChannelZ])
    	rotate(forPrint*[180,0,0])
    	 {
		    LedInCylinder();
		    translate([0,0,Z]){
		        CableChannel();
		        translate([0,ledDistance,0])
		                CylinderHolder();
		    	}
		    }
}


module CylinderHolder(){
    Z=cableChannelZ;
    difference(){
        cylinder(d=cylinderOuterD+2*border,h=Z);
        translate([0,0,-.1])
            cylinder(d=cylinderOuterD,h=Z+.5);


        for ( winkel=[180,360/numberOfLeds])
            rotate([0,0,winkel]){
            // Cable Cut out
            translate([-cableW/2,0,winkel<180?-.10:border]
                +[-border,-border-.01,0]
                +[0,ledBackShellD/2-nibbleY-.01,0]
                ){
                cube([ cableW+2*border,
                        ledBackShellD/2+nibbleY+border+.2,
                        Z+.2]);
            }
        }

    }

}
    
module CableChannel(){
    difference(){
        translate([-cableW/2-border,0,0])
            cube(   [cableChannelX,ledDistance,cableChannelZ] );
            
        translate([-cableW/2-addSpace,-addSpace,border-addSpace+.01])
            cube(   [cableW,ledDistance,cableH]
                    +addSpace*[2,2,1]
                    +[0,0,clipZ]);

		Z=ledFrontD/2+ledBackShellH;
    	for ( y=[0,ledDistance])
       		translate([0,y,-Z])
    			LedCutout();
    }
    

    // clips to hold cable
    for ( x=[-addSpace,cableW+addSpace-clipX]){
        dist=25;
        offset=10+(x>0?dist/2:0);
        for (y=[offset:dist:ledDistance-1])
            translate([-cableW/2+x,y,border+cableH])
                cube([clipX,clipY,clipZ]);
        }
}

module LedInCylinder(){
    difference(){
        Z=ledFrontD/2+ledBackShellH+ledFrontH+frontThickness+cableChannelZ-.01;
        cylinder(d=cylinderOuterD,h=Z);
        translate([0,0,frontThickness])
        	LedCutout();
    }
}

module LedCutout(cutOut=1,cablesNonStreight=1){
    $fn=22;
    
    translate([0,0,ledFrontH+ledFrontD/2]){
        // Gummi Hülle im hinteren Teil 
		cylinder(d=ledBackShellD+cutOut*addSpace,ledBackShellH+.01+cableChannelZ);
    
    	// Nibble at Back with Rubber shell
    	addInside=.2;
        for (winkel=[0:90:360]){
            rotate([0,0,winkel])
                translate([-nibbleX/2-cutOut*addSpace/2, ledBackShellD/2 -addInside,  ,0])
                    cube( [nibbleX, nibbleY +addInside , nibbleZ+cableChannelZ]
                    	+cutOut*addSpace*[1,1,1]);
        }
    }
    
    // The LED itself
    translate([0,0,ledFrontD/2]){
        cylinder(d=ledFrontD,ledFrontH+.01);
        sphere(d=ledFrontD);
    }

	// Cable attachments cutout
    for ( winkel=[180,cablesNonStreight*-360/numberOfLeds])
        rotate([0,0,winkel]){
        // Cable Cut out
        translate([-cableW/2,0,0]
            +[-border,-border-.01,0]
            +[0,-ledBackShellD/2-nibbleY-.01,ledBackShellH]
            + [0,0,ledFrontD/2+ledFrontH]
            +[0,4,0]
            ){
            cube([  cableW+2*border,
                    ledBackShellD/2+nibbleY+border+.2,
                    cableChannelZ+.01]
                    +[0,12,32]);
        }
    }
}


// ==========================================================================
// Debug Framework

module debugFrame( size=[60,60,2], border=.3) {
    translate(-frameHalfOffset)
	    translate([0,0,-size[2]])
		    color("white") 
			    difference(){
			        cube(size);
			        translate( [0, 0, .01]
			        		 + border*[1, 1, 0])
			            cube(size - 2*border*[1,1,0]+[0,0,size[2]]);
			    }
}


frameDistX=150; 
frameDistY=150;
frameHalfOffset=0.5*[frameDistX,frameDistY,0];
module showAllParts(){
    maxX=7;
    maxY=5;

	
    for ( i = [1:maxX] )
            for ( j = [0:maxY] )
                translate([ (i-1)*frameDistX, j*frameDistY, 0]){
                    showPart(part= i + j*10);
                	if ( debugFrames ) 
                    	debugFrame(size=[frameDistX-3,frameDistY-3,1]);
            		}
        
}
