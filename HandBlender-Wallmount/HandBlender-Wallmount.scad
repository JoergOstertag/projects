// Hand Blender Wall-Mount

$fn=30;

if (0){
    wallBracket();
    holderClamp();
}

testDoveTail=1;
if ( testDoveTail){
    translate([60,0,10])
        rotate([0,180,0])
            doveTail();

    difference(){
        translate([-30,.01,0]) cube([60,6,10+3]);
        translate([0,0,3])         doveTail();
    }
}
    
module wallBracket(){
    bracketWidth=30;
    bracketHeight=30;
    translate([-bracketWidth/2,0,-bracketHeight*2/3]){
        difference(){
            cube([bracketWidth,5,bracketHeight]);
            dist=5;
            for (x=[dist,bracketWidth-dist])
                for (z=[dist,bracketWidth-dist])
                    translate([x,0,z]){
                        rotate([270,0,0])
                            cylinder(d=3,h=10);
                    }
                }
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
    

module holderClamp(){
    outerDiameter=24;
    
    translate([0,-outerDiameter/2,0])
        difference(){
//            cylinder(d=outerDiameter,h=5);
            translate(outerDiameter*[-.5,-.5,0])
                cube([outerDiameter,outerDiameter,5]);
            translate([0,0,-.01])
                cylinder(d=18,h=5+.2);
        }
}


