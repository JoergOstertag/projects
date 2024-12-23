//
use <MCAD/boxes.scad>;
// use <../Lib/Ruler.scad>

debug=0;
debugFrames=1*debug;

// Select part to render/print
part=0; // [ 0:All, 1:Stempel, 2:Pfanne, 11:StempelPlusFolie, 12:StempelFolie]


cutOutMiddlePartForDebugging=0;
dickeFolie=1;
radiusEcken=2;
bumperDist=1.9;
bumperSize=bumperDist * 0.8;

StempelSize=[14,21,8];
BorderSize = [10,10,10] ;
echo ("StempelSize: ", StempelSize);

// For Debugging
cutX=StempelSize[0]*.8;

// -----------------------------------------------------------------
// do not need to modify anything below here
// -----------------------------------------------------------------
/* [Hidden] */

// Number of segments in circle
$fn=14;

// Show the selected part
// part=0 shows all parts in a grid
module showPart(part=0){
    if ( part == 0) showAllParts();
    
    if ( part == 1) Stempel();
    if ( part == 2) Pfanne();
    if ( debug ) {
        if ( part == 11) StempelPlusFolie();
        if ( part == 12) StempelFolie();
    
    // Part Ids for Debugging
//    if ( part == 11) Pfanne();
    
    if ( part == 21 ) TestDebug();
//        if ( part == 22 ) Pfanne();
    }
}

module TestDebug(){
    // Vergleichs Block für Folie
    y=dickeFolie;
    translate([cutX,0,0]) {
        color("blue") cube([dickeFolie,dickeFolie,3*dickeFolie]);
        color("blue") cube([dickeFolie,3*dickeFolie,dickeFolie]);
        if(0)color([0,1,0])
                translate([-StempelSize[0],dickeFolie,dickeFolie])
                    translate([+2,0,0])
                        cube(.001*StempelSize);
    }
    
    difference(){
            //StempelPlusFolie();
            StempelFolie();
        
            // Ausschneiden, damit man innen sieht
            translate([cutX,-1,-0.1])
                cube(2*StempelSize);
    }
}

module StempelFolie(){
    difference(){
        StempelPlusFolie();
        translate(dickeFolie*[1,1,1])
            Stempel();
    }
}

module StempelPlusFolie(){
    //[StempelSize[0],StempelSize[1],StempelSize[2]]
    factor= [ 1 + 2*( dickeFolie / StempelSize[0]  ),
              1 + 2*( dickeFolie / StempelSize[1]  ),
              1 + 2*( dickeFolie / StempelSize[2]  )  ];
    echo ("factor: ", factor);
    
    scale(factor)
        Stempel();

};

// -------------- Modules --------------
module Stempel(){
   union(){
        // cube(StempelSize);
        translate(StempelSize/2)
            roundedBox(StempelSize, radiusEcken, false);
        
        // Abstand der Bumber
        dX=bumperDist;
        dY=bumperDist;
        d=bumperSize;
        translate(+[0,0,StempelSize[2]])
            for ( x = [dX+radiusEcken:dX:StempelSize[0]-radiusEcken ] )
                for ( y = [dY+radiusEcken:dY:StempelSize[1]-radiusEcken ] )
                    translate( [x,y,0] )
                       sphere(r=d/2);
            
        
    }
    
}

module Pfanne(){
    difference(){
        cube([2*BorderSize[0],2*BorderSize[1],BorderSize[2]] +StempelSize);

        // Stempel
        translate(BorderSize +[0,0,3])
            rotate([0,180,0])
                translate(-[StempelSize[0],0*StempelSize[1],StempelSize[2]])
                        StempelPlusFolie();
    }
}


// ------------------------------------------------------------------------
// Main
difference(){
    showPart(part=part);
 
    // for Debugging 
    // to see inside Objects
    // cube to cut object apart 
    if ( 0 * debug ) 
        translate([59,-2,-11.1]) 
        // translate([-14,2,-31.1]) 
            cube([120,190,55]);
    // Zum Debugging halb aufschneiden
    if(cutOutMiddlePartForDebugging)
        translate([10,-100,0])
            cube([50,400,400]);

    //translate([40,10,0])            Rulers();
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
