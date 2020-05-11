baseDiscDiameter=200;
baseDiscHeight=4;

use <../GearMotor/GearMotor.scad>;

union(){
    translate([-20, -20,baseDiscHeight-.01]) {
        GearMotorHolder();
    }
    
    difference(){
         
        // Grundscheibe
        cylinder(h=baseDiscHeight,
                d=baseDiscDiameter);
     
        
        
        // Ausgeschnittene Dreiecke (Material sparen)
        cutOutInnerRadius=25;
        cutOutLen=(baseDiscDiameter/2)-cutOutInnerRadius-12;
        for ( angel=[0:20:360] ){
            rotate([0,0,angel])
                translate([cutOutInnerRadius,0,-.1])
                      triAngle(len=cutOutLen,h=baseDiscHeight+1);
    // cube([50,20,baseDiscHeight+2]);
        }
    }


}


module triAngle(len=40,angle=20,h=5){
    $fn = 20;
    cornerDiameter=2;
   hull () {
      translate([0,0,0]) cylinder(r=cornerDiameter,h=h);
      for ( a=[-angle/2,angle/2]){
        rotate([0,0,a])
            translate([len,0,0]) cylinder(r=cornerDiameter,h=h);
      }
    }
}