innerMountCube=[8,5.7,1.4];
lowerMountPlate=[12.6,13,2.3];
basePlateSize=[40,40,0];

DashCamMount();




module DashCamMount(){
    translate([-basePlateSize[0]/2,0,0])
        rotate([0,270,180])
            arcCylinder(basePlateSize[0],basePlateSize[1],60);
        
    rotate([60,0,0])
        translate([0,basePlateSize[1]-lowerMountPlate[1]/2,0]){
        cubeCenterXY(lowerMountPlate);
        translate([0,0,lowerMountPlate[2]]){
            
            mountHeightHolder=[8,2.4,1.6];
            cubeCenterXY(mountHeightHolder);
            translate([0,0,mountHeightHolder[2]*1]){

                // Inner mount Cube
                cubeCenterXY(innerMountCube);
            }
            
        }
    }
}


module cubeCenterXY(dimensions){
    translate([-dimensions[0]*.5,-dimensions[1]*.5,0])
    cube(dimensions);
}


module halfCylinder(h,r) {
  intersection() {
    cylinder(h=h,r=r);
    translate([0,-r,0]) cube([r,2*r,h]);
  }
}

module arcCylinder(h,r,angle) {
  if (angle > 180) {
    union() {
      halfCylinder(h,r);
      rotate([0,0,angle-180]) halfCylinder(h,r);
    }
  } else {
    intersection() {
      halfCylinder(h,r);
      rotate([0,0,angle-180]) halfCylinder(h,r);
    }
  }
}