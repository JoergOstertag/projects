// GWS10.8-76V Asapter

debug=0; 

debugFrames=1*debug;

// Select part to render/print
part=11; // [ 0:All, 1:adapter 16mm mit raste]

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
	if ( part == 11) Adapter16mm();
    
	
    if ( debug ) {
	if ( part == 21) Screw();
    if ( part == 22) GrinderWheel();
	
        }
}




module Adapter16mm(){ 
    h=2.8;
    difference(){

        // innerhalb des Werkzeuges
        union(){
            translate([16.0/2-.2,-3.8/2,-.01])
                cube([2.5,3.5,h]);
            cylinder(d=16.0,h=h+.1);
            
            // Abdeckplatte vertiefung
            translate([0,0,h+.01])
                cylinder(d=11.3,h=.6+.01);
        }
        
        // schraube
        translate([0,0,-.01])
            cylinder(d=4.9,h=9);

        // auflage am motor
        translate([0,0,-.01])
            cylinder(d=10.2,h=1.5+.01);
    }
}

 
module Screw(){
    cylinder(d=4.9,h=11.5);
    difference(){
        cylinder(d=19.5,h=3.4);
        translate([0,0,3.4-.6+.01])
            cylinder(d=11.3,h=.6+.01);
    }
}



module GrinderWheel(){    difference(){
        cylinder(d=74,h=2.9);
        translate([0,0,-.01]){
            translate([16.0/2-.2,-4.1/2,-.01])
                cube([2.7,4.1,3]);
            cylinder(d=16.0,h=2.9+.1);
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
