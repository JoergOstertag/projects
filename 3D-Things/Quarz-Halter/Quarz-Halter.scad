// Halterung für Ulm

debug=1;

debugFrames=1*debug;

// Select part to render/print
part=0; // [ 0:All, 11:Halter 2x2 ,12:Halter 3x4 ,13:Halter 10x10]


// Border for walls 
border=1.3;
// Border thinner walls 
border1=1;

// Add Space to fit
addSpace=.3;
addSpaceXYZ=addSpace*[1,1,1];
addSpace2XYZ=addSpace*2*[1,1,1];

// 1.9 mm x 5.1 mm  und 1.35 mm tief.
quarz=[1.9,5.1,1.35];
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
	if ( part == 11) QuarzHolder(numX=2,numY=2);
	if ( part == 12) QuarzHolder(numX=3,numY=4);
	if ( part == 13) QuarzHolder(numX=10,numY=10);
	
	
    if ( debug ) {
        if ( part == 21) sidePartCover(l=50);
        }
}

module sidePartCover(l=10,border=2){
    
    overlap=2;
    h1=2;
    h2=5;

    difference(){
        cube([l,border+overlap,h2]);
        
        translate([-.1,border,-.1])
           cube([l+1,overlap,h1]+.1*[1,1,1]);
        
        translate([-.1,border,h1])
            rotate([-45,0,0])
           cube([l+1,overlap,h1+2]+.1*[1,1,1]);
    }
}


module QuarzHolder(numX=3,numY=4 ){ 
    border=2;
    
    boden=2;
    dist0=1.3;
    distX= quarz[0]+dist0;
    distY= quarz[1]+dist0;
    X=numX*distX + dist0 + border;
    Y=numY*distY + dist0 + 2*border;
    Z=boden+quarz[2];
    
    
    translate(-.5*[X,Y,0])
    difference(){
        union(){
            // Boden
            cube( [X,Y,Z] );

            //Seiten
            translate([-.1,0,Z-.1]){
                translate([0,0,0]) sidePartCover(l=X,border=border);
                
                translate([X,Y,0]) rotate([0,0,180]) sidePartCover(l=X,border=border);
                translate([0,Y,0]) rotate([0,0,-90])sidePartCover(l=Y,border=border);
            }
            
        }

    for ( x= [0:numX-1] ){
        for ( y= [0:numY-1] ){
                translate( dist0*[1,1,0]
                          + border*[1,1,0]
                          +[ x*distX, y*distY, boden+.1 ] )
                            cube(quarz);
                }
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
