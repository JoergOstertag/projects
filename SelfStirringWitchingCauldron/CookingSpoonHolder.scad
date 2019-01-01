$fn=90;

baseDiscHeight=4;

smallVersion=1;

baseDiscDiameter=smallVersion?80:300;

// =================================================
 RotationDisk(baseDiscDiameter=baseDiscDiameter,
              smallVersion=smallVersion);

// =================================================

module RotationDisk(baseDiscDiameter=baseDiscDiameter, smallVersion=0){
    union(){
        difference(){
            
            // Grundscheibe
            cylinder(h=baseDiscHeight,
                    d=baseDiscDiameter);
         
            // Motorachsen Aufnahme
            translate([0,0,-.1])
                cylinder(h=5+.5,d=5.8);
            
            
            // Ausgeschnittene Dreiecke (Material sparen)
            cutOutInnerRadius=smallVersion?15:25;
            outerBorder=smallVersion?10:20;
            cutOutLen=(baseDiscDiameter/2)
                    -cutOutInnerRadius-outerBorder;

            startAngle=smallVersion?40:20;
            endAngle=smallVersion?320:350;
            for ( angel=[startAngle:25:endAngle] ){
                rotate([0,0,angel])
                    translate([cutOutInnerRadius,0,-.1])
                          triAngle(len=cutOutLen,h=baseDiscHeight+1);
        // cube([50,20,baseDiscHeight+2]);
            }
        }

    translate([baseDiscDiameter/2-12,0,baseDiscHeight-1])
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