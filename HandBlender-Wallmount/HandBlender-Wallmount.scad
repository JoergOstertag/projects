// Hand Blender Wall-Mount
// Designed for a Koios Blender

$fn=30;

tailOuterWidth=20+2*4;

if (1){
    translate([-110,-70,5]) 
        rotate([-90,0,0])
            backPlane();

//    rotate([0,180,0]) 
    {
        translate([0,0,-5])     holderClamp(type="mixer");
        translate([70,0,-5])    holderClampMotor(type="motor");
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
    
    translate([tailOuterWidth/2,-2,0])
        rotate([0,0,180])
            doveTail(count=2);

        motorDiameter=54;
        innerDiameter=41;
        outerDiameter=54;
        
        stegLength=22;
        translate(outerDiameter*[-.5,0,0]+[0,0,0])
                cube([outerDiameter,stegLength,15]);

        translate([0,stegLength,0])
            difference(){
                translate(outerDiameter*[-.5,0,0])
                    cube([outerDiameter,outerDiameter,15]);

                translate([0,+motorDiameter/2,-.01])
                    difference(){
                        cylinder(d=motorDiameter,h=5+.2);
                        translate([-30,-20,-.1]) cube([60,70,6]);
                    }
                            
//#                    translate([0,innerDiameter/2+5,-.01]) cylinder(d=innerDiameter,h=5+.2);

                translate([0,innerDiameter/2+7,4-.01])
                    rotate([30,0,0])
                        cylinder(d1=innerDiameter,d2=innerDiameter+15,h=20);

                    translate(innerDiameter*[-.5,.5,0]+[0,-3,-.1])
                       cube([innerDiameter,innerDiameter,5+.2]);
                }
            
            
        }


module holderClamp(type="mixer"){
    
    rotate([0,0,180]){

        translate([0,2,0])
            doveTail();
            
        if(type=="mixer"){
            outerDiameter=35;
            translate(outerDiameter*[-.5,0,0]+[0,-24,0])
                    cube([outerDiameter,22+2,15]);

            translate([0,-22-outerDiameter/2,0])
                difference(){
                    translate(outerDiameter*[-.5,-.5,0])
                        cube([outerDiameter,outerDiameter,15]);

                        innerDiameter=18;
                        translate([0,0,-.01])
                            cylinder(d=innerDiameter,h=15+.2);

                        translate([0,0,5])
                            cylinder(d1=innerDiameter,d2=innerDiameter+10,h=10+.2);

                        translate(innerDiameter*[-.5,-1.0,-.01])
                            cube([innerDiameter,innerDiameter,15+.2]);
                }
        }
    }
}



// ==================================================================================================

module doveTailWallPart(count=1){
    difference(){
        translate([-tailOuterWidth/2,.01,0]) cube([tailOuterWidth*count,6,15+3]);
        translate([0,0,3])         doveTail(count=count);
    }
}
    
module doveTail(
    tailLength=4,
    tailWidth=12,
    tailHeight=15,
    count=1
    ) {
    
    x0=tailWidth/2;
    x1=tailWidth/2 +3;
    xd=4;

    attachmentThickness=2;
        
    for( i=[0:count-1] ) {
        translate([ tailOuterWidth*i ,0,0])
        union(){
            translate([-x0+.1,-attachmentThickness,0])  cube([2*x0-.2,attachmentThickness,tailHeight]);

            hull()
                for(z=[0,1])
                    translate([0,0,z*tailHeight])
                       linear_extrude(.001){
                            polygon([
                                [-x0, 0], 
                                [-x1-z*xd, tailLength],
                                [x1+z*xd, tailLength],
                                [x0, 0]
                            ]);
                       }
                   }
           }
}
    