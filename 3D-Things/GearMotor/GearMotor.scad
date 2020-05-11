gearBlock=[46,31.9,21.8];

motorHeight=30.8;
motorDiameter=24.3;
motorOffset=[0,1.5,2.9];

axisDiameter=6.1;
axisHeight=15.8;
axisOffset=[14.6,15.9,gearBlock[2]];

mountingHoleDistance=[32.7,17.9,0];
mountingHoleOffset=[5.5,6.9,gearBlock[2]];
mountingHoleOuter=7.4;
mountingHoleInner=2.6;
mountingHoleZ=2.6;

debug=0;


// ========================================================================
translate([0,60,0]) GearMotor();
translate([0, 0,0]) GearMotorHolder();
// ========================================================================

module GearMotorHolder(){
if ( debug){
            translate([5,5,5])
                GearMotor();
}
    difference(){
        
        // Base Block
        cube([80,45,27]);

        // Keep motor Free
        translate([51,-1,18])
            cube([90,50,20]);

        // Motor
        translate([5,5,5])
            scale(1.01*[1,1,1])
                GearMotor();
    }
}


module GearMotor(){
    color("silver"){
        // Gear Block
        cube(gearBlock);

        // Motor
        translate(   [gearBlock[0],gearBlock[1],0]
                   + [0,-motorDiameter/2,motorDiameter/2]
                   - motorOffset
                   - [1,0,0] // For Overlap
                  )
            rotate([0,90,0])
                cylinder(h=motorHeight+1,d=motorDiameter);
                
                
        // Axis
        translate(
                  +[0,-axisDiameter/2,axisDiameter/2]
                  +axisOffset
                  )
        //    rotate([0,90,0])
                cylinder(h=axisHeight,d=axisDiameter);

        // Mounting Holes
        translate(mountingHoleOffset){
            for(x=[0,mountingHoleDistance[0]]){
                for(y=[0,mountingHoleDistance[1]]){
                    translate([x,y,0])
                        MoutingHole();
                }
            }
        }
    }
    
}

module MoutingHole(){
    difference(){
        cylinder(d=mountingHoleOuter,h=mountingHoleZ);
        translate([0,0,-.5])
            cylinder(d=mountingHoleInner,h=mountingHoleZ+1);
    }
}