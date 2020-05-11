baseDiscHeight=3;


baseDiscDiameter=250;

// =================================================
 RotationDisk(baseDiscDiameter=baseDiscDiameter);

// =================================================

module RotationDisk(baseDiscDiameter=baseDiscDiameter){
    union(){
        difference(){
            
            // Grundscheibe
            cylinder(h=baseDiscHeight,
                    d=baseDiscDiameter);
         
            // Motorachsen Aufnahme
            translate([0,0,-.1])
                cylinder(h=5+.5,d=5.8);
            
            
            // Ausgeschnittene Dreiecke (Material sparen)
            cutOutInnerRadius=25;
            outerBorder=7;
            cutOutLen=(baseDiscDiameter/2)
                    -cutOutInnerRadius-outerBorder;
            for ( angel=[40:20:330] ){
                rotate([0,0,angel])
                    translate([cutOutInnerRadius,0,-.1])
                          triAngle(len=cutOutLen,h=baseDiscHeight+1);
            }
            for ( angel=[339:20:360+40] ){
                rotate([0,0,angel])
                    translate([cutOutInnerRadius+30,0,-.1])
                          triAngle(len=cutOutLen-30,h=baseDiscHeight+1,angle=29);
        // cube([50,20,baseDiscHeight+2]);
            }
        
   translate([28+2.5,0,-5])
            rotate([0,-15,0])
               cylinder(h=35, d=15);
            }

    translate([28,0,baseDiscHeight-1])
        SpoonStickHolder();
    }
}

module SpoonStickHolder(){
    holderInnerDiameter=15;
    holderHeight=35;
    holderWallThickness=5;

    // Löffel Aufnahme
   difference(){
        translate([0,0,-2])
            rotate([0,-15,0])
                difference(){

                    cylinder(h=holderHeight,
                             d=holderInnerDiameter
                                +holderWallThickness*2);
                    translate([0,0,-0.1])
                        cylinder(h=holderHeight+1,                             d=holderInnerDiameter);
                }
    
       translate([0,0,-5])
                cube(size=[30,30,10],center=true);
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