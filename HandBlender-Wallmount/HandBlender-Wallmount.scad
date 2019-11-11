// Hand Blender Wall-Mount
// Designed for a Koios Blender

$fn=30;

//tailOuterWidth=20+2*4;
tailOuterWidth=38;
tailHeight=35;
tailThickness=9;
tailWidth=12;


if (1){
    translate([-110,-70,5]) 
        rotate([-90,0,0])
            backPlane();

//    rotate([0,180,0]) 
    {
        translate([0,0,-5])     holderClamp(type="mixer");
        translate([70,0,-5])    holderClampMotor(type="motor");
//        translate([120,0,-5])     holderClamp(type="unknown");
    }
}


testDoveTail=1;
if ( testDoveTail){
    translate([190,-0,0]){
        translate([0,0,10])
//        rotate([0,180,0]) // For printing
          rotate([0,0,180]) // For printing
        translate([-28,5,-10])
            doveTail(count=2);

            doveTailWallPart(count=2);
}
}

// ==================================================================================================

module backPlane(){
    count=8;
    tailWidth=tailOuterWidth;
    screwDistFromBorder=5;
    dScrew=5;
    posFirst=screwDistFromBorder+4;
    bracketWidth=count*tailWidth+ (2*(posFirst));
    bracketHeight=30;
    bracketThickness=5;
    
    translate([0,0,bracketThickness]){
        difference(){
            union(){
                cube([bracketWidth,bracketThickness,bracketHeight]);
                    translate([posFirst + tailWidth/2,-5,0])
                        doveTailWallPart(tailWidth=bracketWidth,count=count);
            }

            // Screw Holes
            for (x=[screwDistFromBorder,bracketWidth-screwDistFromBorder])
                for (z=[screwDistFromBorder,bracketHeight-screwDistFromBorder])
                    translate([x,z>screwDistFromBorder?-.1:-5,z]){
                        rotate([270,0,0])
                            union(){
                                cylinder(d=dScrew,h=20);
                                translate([0,0,0]) cylinder(d1=dScrew+3,d2=dScrew,h=2);
                            }
                    }
                }
            }
            
}


module holderClampMotor(){
    clampHeight=35;

    translate([tailOuterWidth/2,-2,0])
        rotate([0,0,180])
            doveTail(count=2);

        motorDiameter=53;
        innerDiameter=42;
        outerDiameter=54;
        
        stegLength=12;
        translate(outerDiameter*[-.5,0,0]+[0,0,0])
            color("blue")
                cube([outerDiameter,stegLength,clampHeight]);

        translate([0,stegLength,0])
            difference(){
                translate(outerDiameter*[-.5,0,0])
                    cube([outerDiameter,outerDiameter,clampHeight]);

                translate([0,+motorDiameter/2,-.01])
                    difference(){
                        cylinder(d=motorDiameter,h=clampHeight+.2);
                        translate([-30,-motorDiameter/2+8,-.1]) cube([60,motorDiameter,20]);
                    }

                translate([0,+motorDiameter/2,-.01])
                    difference(){
                        cylinder(d1=innerDiameter,d2=motorDiameter,h=clampHeight+.2);
                        translate([-30,-motorDiameter*1.5+8,-.1]) cube([60,motorDiameter,20]);
                    }
                            
//#                    translate([0,innerDiameter/2+5,-.01]) cylinder(d=innerDiameter,h=5+.2);


                    translate(innerDiameter*[-.5,0,0]+[0,8,-.1])
                         cube([innerDiameter,motorDiameter,clampHeight+.2]);
            }
            
            for (x=[-motorDiameter/2+4,motorDiameter/2]){
                translate([x+1,motorDiameter+8,clampHeight])
                    rotate([0,-90,0])
                        cylinder(d=10,h=6);
            }    
        }


module holderClamp(type="mixer"){
    clampHeight=35;
    translate([0,-2,0])
        rotate([0,0,180])
            doveTail(count=1);
            
        if(type=="mixer"){
            outerDiameter=35;

            stegLength=12;
            translate(outerDiameter*[-.5,0,0]+[0,0,0])
                color("blue")
                    cube([outerDiameter,stegLength,clampHeight]);


            translate([0,stegLength+outerDiameter/2,0]){
                difference(){
                    translate(outerDiameter*[-.5,-.5,0])
                        cube([outerDiameter,outerDiameter,clampHeight]);

                        innerDiameter=18;
                        translate([0,0,-.01])
                            cylinder(d=innerDiameter,h=clampHeight+.2);

                        translate([0,0,clampHeight-10])
                            cylinder(d1=innerDiameter,d2=innerDiameter+10,h=10+.2);

                        translate(innerDiameter*[-.5,0,-.01])
                            cube([innerDiameter,innerDiameter,clampHeight+.2]);
                }
        }
    }
}



// ==================================================================================================

module doveTailWallPart(count=1){
    tailOffset=3;
    backThickness=4;
    difference(){
        translate([-tailOuterWidth/2,.01,0]) 
            cube([tailOuterWidth*count,tailThickness+backThickness,35+tailOffset]);
        translate([0,0*backThickness,tailOffset+.1])
            doveTail(count=count);
    }
}
    
module doveTail(
    count=1
    ) {
    
    x0=tailWidth/2;
    x1=tailWidth/2 +3;
    xd=4;

    attachmentThickness=2;
        
    for( i=[0:count-1] ) {
        translate([ tailOuterWidth*i ,0,0])
        union(){
            translate([-x0+.1,-attachmentThickness,0])  
                cube([2*x0-.2,attachmentThickness,tailHeight]);

            hull()
                for(z=[0,1])
                    translate([0,0,z*tailHeight])
                       linear_extrude(.001){
                            polygon([
                                [-x0, 0], 
                                [-x1-z*xd, tailThickness],
                                [x1+z*xd, tailThickness],
                                [x0, 0]
                            ]);
                       }
                   }
           }
}
    