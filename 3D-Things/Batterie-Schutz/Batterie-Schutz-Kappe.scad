// Schutz Kappe für LiFepo verbinder
debug=0;

debugFrames=1*debug;

// Select part to render/print
part=0; // [ 0:All, 11:SchutzKappe]

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

showMain();

// ----------------------------------------------------------------
// Definition of Available Parts

// Show the selected part
// part=0 shows all parts in a grid
module showPart(part=0){
    if ( part == 0) showAllParts();
    
 
    // Part Ids for Debugging
	if ( part == 11) SchutzKappe();

	
    if ( debug ) {
	if ( part == 21) Screw();
    if ( part == 22) GrinderWheel();
	
    }
}


// --------------------------------------------------------------------
module SchutzKappe(){ 

    verbinder=[21.9,90,1];
    M8_Kopf=10;
    M8_Kopf_h=4.5;

//    dicke=3;
    dickeOben=M8_Kopf_h;
    dickeSeite=3;
    
    difference(){
        // Äußere Hülle
        cube(verbinder+[2*dickeSeite,2*dickeSeite,dickeOben]);
    
        // Ausschnitt Verbinder
        translate([dickeSeite,-.1+dickeSeite,-.1+0])
            cube(verbinder+.01*[2,2,2]);
    
        // Schrauben Aussparung
        for ( y = [20,80]){
            translate([verbinder[0]/2+dickeSeite,y,0]){
            
            translate([0,0,-.1])
               cylinder(h=verbinder[2]+dickeOben*2+1,r=M8_Kopf);
            }
        };
    }
    
}


// ------------------------------------------------------------------
// Helper Routines

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


module showMain(){
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
}

