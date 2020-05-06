// Hand Blender Wall-Mount
// Designed for a Koios Blender

$fn=30;

//tailOuterWidth=20+2*4;
tailOuterWidth=38;
tailHeight=35;
tailThickness=9;
tailWidth=12;
tailAttachmentThickness=3;
tailThicknessTotal=tailAttachmentThickness+tailThickness;

placeForPrint=1;

testDoveTail=0;
showAllMain=0;
showBackplane=0;
showMotor=0;
showMixer=0;
showQuirl=1;

placeForPrint0=(1-placeForPrint);

if (showAllMain){
    showBackplane=1;;
    showMotor=1;
    showMixer=1;
    showQuirl=1;
}

if (showBackplane)
        translate([0,-60,16])
        rotate([placeForPrint*-90,0,0])
            backPlane();

if (showMixer)
        translate([0,0,-5])     holderClamp(type="mixer");

if (showQuirl)
        translate([0,0,-5])     holderClamp(type="quirl");

if (showMotor)
    translate([70,0,-5])    holderClampMotor(type="motor");
//        translate([120,0,-5])     holderClamp(type="unknown");
    



if ( testDoveTail ){
    translate([showAllMain*190,-0,0]){
        translate(placeForPrint0*[-8,12.5,40])
        translate(placeForPrint*[30,50,tailThicknessTotal])
            rotate(placeForPrint*[-90,0,0]) // For printing
            rotate(placeForPrint0*[0,0,180]) // For printing
                translate([-28,0,-10])
                    color("green")
                        doveTail(count=1);

    translate(placeForPrint0*[20,0,10])
        rotate(placeForPrint0*[90,0,180]) // For printing
            doveTailWallPart(count=1);

//    translate(placeForPrint0*[70,0,10])
  //      rotate(placeForPrint0*[90,0,180]) // For printing
    //        doveTailWallPart(count=1);
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
    bracketHeight=40;
    bracketThickness=5;
    
//    translate([0,0,bracketThickness])
    {
        translate([posFirst + tailWidth/2,0,0])
             doveTailWallPart(tailWidth=bracketWidth,count=count);
        
      translate([0,12.2,0])
            difference(){
                cube([bracketWidth,bracketThickness,bracketHeight]);
                    
                // Screw Holes
                for (x=[screwDistFromBorder,bracketWidth-screwDistFromBorder])
                    //cube([12,bracketThickness,bracketHeight]);
                    for (z=[screwDistFromBorder,bracketHeight-screwDistFromBorder])
//                        translate([x,z>screwDistFromBorder?-.1:-5,z]){
                         translate([x,-.1,z]){
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

    translate([tailOuterWidth/2,0,0])
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
/*
    outerDiameter= ( type == "quirl" ) ? 50:35;
    innerDiameter= ( type == "quirl" ) ? 20:35;
*/
    innerCone1D1= ( type == "quirl" ) ? 42:35;
    innerCone1D2= ( type == "quirl" ) ? 50:35;
    innerCone1H= ( type == "quirl" ) ? 18:18;

    innerCone2D1= ( type == "quirl" ) ? 20:35;
    innerCone2D2= innerCone1D1;
    innerCone2H= ( type == "quirl" ) ? 10:18;

    outerDiameter= innerCone1D2+2*5;
    innerDiameter= ( type == "quirl" ) ? 20:35;
    
    clampHeight=innerCone1H+innerCone2H+8;
    
    rotate([0,0,180])
        doveTail(count=1);
        
    if( ( type=="mixer" ) || ( type=="quirl" ) ){

        stegLength=12;
        translate(outerDiameter*[-.5,0,0]+[0,0,0])
            color("blue")
                cube([outerDiameter,stegLength,clampHeight]);


        translate([0,stegLength+outerDiameter/2,0]){
            difference(){
                translate(outerDiameter*[-.5,-.5,0])
                    cube([outerDiameter,outerDiameter,clampHeight]);

                // Central cylinder cutout
                translate([0,0,-.01])
                    cylinder(d=innerDiameter,h=clampHeight+.2);
                // Central cutout to front
                translate(innerDiameter*[-.5,0,-.01])
                    cube([innerDiameter,2*innerDiameter,clampHeight+2]);

                translate([0,0,clampHeight-innerCone1H])
                    cylinder(d1=innerCone1D1,d2=innerCone1D2,h=innerCone1H+.2);

                translate([0,0,clampHeight-innerCone1H-innerCone2H])
                    cylinder(d1=innerCone2D1,d2=innerCone2D2,h=innerCone2H+.2);
                    
/*
                translate([0,0,clampHeight-10])
                    cylinder(d1=innerCone2D1,d2=innerCOne2D2,h=10+.2);
*/
                
                
                
                if( (type=="no-quirl") ){
                        translate([outerDiameter*-.5-.1,0,-5])
                            cube([outerDiameter+.2,innerDiameter*2,clampHeight]);
                }
            }
        }
    }
}



// ==================================================================================================

module doveTailWallPart(count=1){
    tailOffset=4;
    backThickness=4;
    difference(){
            translate([-tailOuterWidth/2,.1,0]) 
                cube([tailOuterWidth*count,
                        tailThickness+backThickness-.5,
                        35+tailOffset]);
            translate([0,0*backThickness,tailOffset+.1])
                    doveTail(count=count,cutout=1);
        }
}
    
module doveTail(
    count=1,
    cutout=0
    ) {
    

    dCutout=cutout*.5;

    x0=tailWidth/2 + dCutout;
    x1=tailWidth/2 +3 + dCutout;
    xd=4;

        
    translate([0,tailAttachmentThickness,0])  
    for( i=[0:count-1] ) {
        translate([ tailOuterWidth*i ,0,0])
        union(){
            translate([-x0+.1,-tailAttachmentThickness,-.01])  
                cube([2*x0-.2,tailAttachmentThickness,tailHeight+.01]);

            hull()
                for(z=[0,1])
                    translate([0,0,z*tailHeight])
                       linear_extrude(.0001){
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
    