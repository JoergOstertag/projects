//
use <MCAD/boxes.scad>;
use <../Lib/Ruler.scad>

// Select part to render/print
part=0; // [ 0:All, 1:Raspi 3A with LCD-Housing, 2:Bottom Lid ,3:Bottom Lid with Mounting holes]


cutOutMiddlePartForDebugging=1;

StempelSize=[30,20,10]
            +2*[1,1,1]
            ;
echo ("StempelSize: ", StempelSize);

// -----------------------------------------------------------------
// do not need to modify anything below here
// -----------------------------------------------------------------
/* [Hidden] */

// Number of segments in circle
$fn=25;

 Stempel();
 Pfanne();

// Zum Debugging halb aufschneiden
if(cutOutMiddlePartForDebugging)
            translate([10,-100,0])cube([50,400,400]);

//translate([40,10,0])            Rulers();

module Pfanne(){
    difference(){
#        cube([30,30,30]);

        // Stempel
        Stempel();
}


// -------------- Modules --------------
module Stempel(){
   union(){
        translate(StempelSize/2){ 
            roundedBox(StempelOutSide, 2, false);
        }
    }
}
     

module roundedHollowBox(size, radius, sidesonly,wallThickness){
    innerSize = size-(2*wallThickness*[1,1,1]);
    translate(size/2){ // Da das Original centered ist
        difference(){
            roundedBox(size, radius, sidesonly);
            roundedBox(innerSize, radius, sidesonly);
        }
    }
}

