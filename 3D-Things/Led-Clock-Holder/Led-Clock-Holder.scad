// Switch on Debugging Features (show Debug Object, Show frames, cutout part to see inside)
debug=1; 

// Switch on Debugging Feature cut-out part to see inside
debugCutOutToLookInside=0;

// Draw Frames around the raster-Squares
debugFrames=1*debug;

part=0; // [ 0:All, 1:Led in cylinder, 2: Cable channel]

// Border for walls 
border=2.3;

// Add Space to fit
addSpace=.4;


ledFrontD=7.8;
ledFrontH=3.9;
ledBackShellD=11.5;
ledBackShellH=23.8;
nibbleX=2.9;
nibbleY=1.2;
nibbleZ=ledBackShellH;

ledCableZ=6;

ledDistance=60;
cableW=5.5;
cableH=2.0;
frontThickness=.4;





difference(){
    showPart(part=part);
 
    //for Debugging 
    // to see inside Objects
    // cube to cut object apart 
    if ( debugCutOutToLookInside * debug ) 
        translate([59,2,-11.1]) 
        // translate([-14,2,-31.1]) 
            cube([120,190,55]);
    
} 

module showPart(part=0){
    if ( part == 0) showAllParts();
    
	if ( part == 1) LedInCylinder();
	if ( part == 2) CableChannel();
    
    if ( debug ) {
        if ( part == 11 ) LedCutout();
        
		if ( part == 12 ) LedInCube();
        if ( part == 13 ) LedInCylinder();
       	if ( part == 14 ) CableChannel();
    }
}

module CableChannel(){
	difference(){
		translate([-border,0,0])
			cube([cableW,ledDistance,cableH]+border*[2,0,1]+[0,0,clipZ]);
		translate([-addSpace,-addSpace,border-addSpace+.01])
			cube([cableW,ledDistance,cableH]
				+addSpace*[2,2,1]
				+[0,0,clipZ]);
	}
	
	// clips to hold cable
	clipX=1.9;
	clipY=3;
	clipZ=0.9;
	for ( x=[-addSpace,cableW+addSpace-clipX]){
		dist=25;
		offset=10+(x>0?dist/2:0);
		for (y=[offset:dist:ledDistance-1])
			translate([x,y,border+cableH])
				cube([clipX,clipY,clipZ]);
		}
}

module LedInCube(){
    difference(){
        X=ledBackShellD+2*border+2*nibbleY;
        Y=ledBackShellD+2*border+2*nibbleY;
        Z=ledFrontD/2+ledBackShellH+ledFrontH+frontThickness+ledCableZ-.01;
        translate(-.5*[X,Y,0])
            cube([X,Y,Z]);
        translate([0,0,frontThickness])
        	LedCutout();
    }
}

module LedInCylinder(){
    difference(){
        cylinderD=ledBackShellD+2*border+2*nibbleY;
        Z=ledFrontD/2+ledBackShellH+ledFrontH+frontThickness+ledCableZ-.01;
        cylinder(d=cylinderD,h=Z);
        translate([0,0,frontThickness])
        	LedCutout();
    }
}

module LedCutout(cutOut=1){
    $fn=22;
    
    translate([0,0,ledFrontH+ledFrontD/2]){
        // Gummi Hülle im hinteren Teil 
		cylinder(d=ledBackShellD+cutOut*addSpace,ledBackShellH+.01+ledCableZ);
    
    	// Nibble at Back with Rubber shell
    	addInside=.2;
        for (winkel=[0:90:360]){
            rotate([0,0,winkel])
                translate([-nibbleX/2-cutOut*addSpace/2, ledBackShellD/2 -addInside,  ,0])
                    cube( [nibbleX, nibbleY +addInside , nibbleZ+ledCableZ]
                    	+cutOut*addSpace*[1,1,1]);
        }
    }
    
    // The LED itself
    translate([0,0,ledFrontD/2]){
        cylinder(d=ledFrontD,ledFrontH+.01);
        sphere(d=ledFrontD);
    }
    
    // Cable Cut out
    translate([-cableW/2,0,0]
    	+[-border,-border-.01,0]
    	+[0,-ledBackShellD/2-nibbleY-.01,ledBackShellH]
    	+ [0,0,ledFrontD/2+ledFrontH]
    	){
    	cube([cableW+2*border,ledBackShellD+2*nibbleY+2*border+.2,ledCableZ+.01]);
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


frameDistX=100; 
frameDistY=100;
frameHalfOffset=0.5*[frameDistX,frameDistY,0];
module showAllParts(){
    maxX=5;
    maxY=5;

	
    for ( i = [1:maxX] )
            for ( j = [0:maxY] )
                translate([ (i-1)*frameDistX, j*frameDistY, 0]){
                    showPart(part= i + j*10);
                	if ( debugFrames ) 
                    	debugFrame(size=[frameDistX-3,frameDistY-3,1]);
            		}
        
}
