// Hand Blender Wall-Mount

$fn=30;

if (1){
    translate([60,0,0]) wallBracket();

    translate([0,0,5])
        rotate([0,180,0])
    holderClamp();
}


testDoveTail=0;
if ( testDoveTail){
    translate([60,0,10])
//        rotate([0,180,0])
            doveTail();

    doveTailWallPart();
}

// ==================================================================================================

module wallBracket(){
    count=4;
    tailWidth=60;
    screwDistFromBorder=5;
    dScrew=5;
    posFirst=screwDistFromBorder+4;
    bracketWidth=count*tailWidth+ (2*(posFirst));
    bracketHeight=30;
    {
        difference(){
            union(){
                cube([bracketWidth,5,bracketHeight]);
                for( i=[0:count-1] ) {
                    translate([posFirst + tailWidth*i + tailWidth/2,-5,0])
                        doveTailWallPart(tailWidth=bracketWidth);
                    }
            }

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


module holderClamp(){
    outerDiameter=32;
    innerDiameter=18;
    
    translate([0,2,-5])
        doveTail();

    translate([0,-outerDiameter/2,0])
        difference(){
//            cylinder(d=outerDiameter,h=5);
            translate(outerDiameter*[-.5,-.5,0])
                cube([outerDiameter,outerDiameter,5]);
            translate([0,0,-.01])
                cylinder(d=innerDiameter,h=5+.2);

            translate([0,0,0])
                cylinder(d1=innerDiameter,d2=innerDiameter+10,h=5+.2);

            translate(innerDiameter*[-.5,-1.0,-.01])
                cube([innerDiameter,innerDiameter,5+.2]);

            }
        
}


// ==================================================================================================
module doveTailWallPart(){
    difference(){
        translate([-30,.01,0]) cube([60,6,10+3]);
        translate([0,0,3])         doveTail();
    }
}
    
module doveTail(
    tailLength=4,
    tailWidth=40,
    tailHeight=10
    ) {
    
    x0=tailWidth/2;
    x1=tailWidth/2 +3;
    xd=4;

    attachmentThickness=2;
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
    