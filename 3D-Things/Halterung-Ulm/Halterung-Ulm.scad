// Halterung für Ulm

debug=1;

debugFrames=1*debug;

// Select part to render/print
part=0; // [ 0:All, 11:Halter]

// Border for walls 
border=1.3;
// Border thinner walls 
border1=1;

// Add Space to fit
addSpace=.3;
addSpaceXYZ=addSpace*[1,1,1];
addSpace2XYZ=addSpace*2*[1,1,1];


// -----------------------------------------------------------------
// do not need to modify anything below here
// -----------------------------------------------------------------
/* [Hidden] */

// Number of segments in circle
$fn=55;

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
    
 
    // Part Ids for Debugging
	if ( part == 11) Adapter();
	
	
    if ( debug ) {
	if ( part == 21) Screw();
    if ( part == 22) GrinderWheel();
	
        }
}




module Adapter( ){ 
    z=12;
    x=40;
    y=18;
    
    z2=5;
    b2=3; // Seitlie border
    
    boden=3;
    
    difference(){
//                translate([d/2-.2,-3.8/2,-.01])
                    cube([x,y,z]);

                translate([-.1,b2,z-z2])
                    cube([x+.2,y-2*b2,z2+.1]);

                translate([0,0,boden]){
                    translate([-.1,b2,0])
                       rotate([0,-45,0])
                            cube([z,y-2*b2,z2+.1]);

                    translate([-.1+x,-b2+y,0])
                       rotate([0,-45,180])
                            cube([z,y-2*b2,z2+.1]);
                }
    }
}


// place all Partes in a grid
 module showAllParts(){
    distX=100;  maxX=5;
    distY=100; maxY=5;

    for ( i = [1:maxX] )
            for ( j = [0:maxY] ){
                translate([ (i-.5)*distX, (j-.5)*distY, 0])
                    showPart(part= i + j*10);
                if ( debugFrames ) 
                    translate([ (i-1)*distX, j*distY, 0])
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
