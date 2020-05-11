knochenLaenge=50;
knochenDurchmesser=11;
gelenkDurchmesser=10;

use <lib/kugel.scad>

$fn=30;


Knochen();
 
module Knochen(){
HalbKnochen();
    mirror([1,0,0])
HalbKnochen();
    
}



module cutout2(){
    // hull()
    for ( point=pointlist(deltaAlpha=15,deltaBeta=15))
      translate( point) sphere(r=2.5);
}

module HalbKnochen(){

        BoneMiddleShaft();

        translate([knochenLaenge,0,0])
            BoneBalls();

		translate([20,0,0]) 
            bone_shaft();

}

module bone_shaft() {
    translate([knochenLaenge-20,0,0])
	hull() {
		translate([-20,0,0])  sphere(d=knochenDurchmesser);
		translate([-gelenkDurchmesser/2,0,0]) resize(newsize=[1,2*gelenkDurchmesser,gelenkDurchmesser]) sphere(gelenkDurchmesser);
	}
}


module BoneBalls(){
difference(){
    union(){
              BoneOneBallWithHull();
            mirror([0,90,0]) BoneOneBallWithHull();
          }

    
*   translate([10,0,0]) 
            cutout2(); 
    }
}


module      BoneOneBallWithHull(){
          hull(){      
            translate([0,-gelenkDurchmesser*2/3,0])
                sphere(r=gelenkDurchmesser);
            translate([0,gelenkDurchmesser*.9,0])
                rotate([90,0,0])
                    cylinder(h = gelenkDurchmesser*1.8 /*2/3*/, 
                             d = gelenkDurchmesser*1.7, center = false);
      }
  }

module BoneMiddleShaft(){
    rotate([90,0,90])
              cylinder(h = knochenLaenge, 
                       d = knochenDurchmesser, center = false);
}

