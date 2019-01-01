debug=0;

loopDiameter=140;
//loopDiameter=200;
loopRadius=loopDiameter/2;
loopThickness=loopDiameter<80?4:8;
loopHeight=loopDiameter<80?2:4;

jointRadius=loopThickness*2;
jointHole=4.1;

gripLength=loopDiameter*3/4;
gripWidth=loopDiameter<80?5:10;

// MeasuringLoopComplete(gripAngle=-0);
MeasuringLoopComplete(gripAngle=35,mounted=0);

  
if (debug){
    translate([0,2*(loopRadius+jointRadius+20),0])   
        MeasuringLoopComplete(gripAngle=-0,mounted=1);

    translate([0,2*2*(loopRadius+jointRadius+20),0])   
        MeasuringLoopComplete(gripAngle=35,mounted=1);

    if (0) // Debug CylinderSegments
        for ( a=[0:15:360] ){
            translate([-100,0,8*(a-180)/15])
                CylinderSegment(r1=40,r1=50,angle=a);
    }
}


// =============================================================================
module MeasuringLoopComplete(gripAngle=-0,mounted=0){
    color("green")
        MeasuringLoop(withScale=1,gripAngle=gripAngle);
    translate([0,mounted?0:-2*(jointRadius+1),mounted?loopHeight+.2:0])
        MeasuringLoop(withScale=0,gripAngle=gripAngle);
}

// =============================================================================
module MeasuringLoop(withScale=1,    gripAngle=-0){   
    translate([0,0,withScale?0:loopThickness/2])
    rotate([withScale?0:180,0,0]){
        MeasurementCircle(withScale=withScale);
        Joint(withScale=withScale);
        Grip(gripAngle=gripAngle);
        if(withScale)
            Scale(gripAngle=gripAngle);       
    }
}


// =============================================================================
module Grip(gripAngle=0){
    difference(){
        rotate([0,0,gripAngle]){
            translate([jointRadius/2,-gripWidth/2,0])
                cube([gripLength-jointRadius/2,gripWidth,loopHeight]);
            // End round
            translate([gripLength,0,0])
                cylinder(h=loopHeight,d=gripWidth);
        }
        
        // cut out Joint Hole
        translate([0,0,-1]) 
            cylinder(d=jointHole,h=loopHeight+2,$fn=20);    
    }
}
 
// =============================================================================
module Scale(gripAngle=0){
    scaleAngle=70;
    scaleRadius=(loopRadius-loopThickness)*2/3;
    scaleRadiusOuter=scaleRadius+loopThickness;
    
    rotate([0,0,gripAngle>0?gripAngle-scaleAngle:gripAngle])
        difference(){
            CylinderSegment(r1=scaleRadius,r2=scaleRadiusOuter,angle=scaleAngle);

            // Cutouts as markers (1.5mm)
            for ( a=[0:10:scaleAngle])
                rotate([0,0,a])
                    translate([scaleRadiusOuter-1.5,0,-1])
                        rotate([0,0,-45])
                            cube([loopThickness,loopThickness,loopHeight+2]);


            // Cutouts as markers (3mm)
            for ( a=[0:20:scaleAngle])
                rotate([0,0,a])
                    translate([scaleRadiusOuter-3,0,-1])
                        rotate([0,0,-45])
                            cube([loopThickness,loopThickness,loopHeight+2]);
        }
}

// =============================================================================
module Joint(withScale=1){ 
    difference(){
        // Joint
        cylinder(h=loopHeight,r=jointRadius,$fn=35);

        // cut out Joint Hole
        translate([0,0,-1]) 
            cylinder(d=jointHole,h=loopHeight+2,$fn=20);

        // Hole for Nut
        if (withScale){
            translate([0,0,-.1]) 
                cylinder(d=7.8,h=1.7,$fn=6);

        }
    }
}

// =============================================================================
module SpringHolder(withScale=withScale){
    dZ=5;
    dX=5;
    dY=2;
    
    difference(){
        cube([dX,dY,dZ]);

        translate([dX*1/3,dY*2,dZ*2/3])
            rotate([90,0,0])
                cylinder(d=1.5,h=3*dY,$fn=10);
    }
}

// =============================================================================
module MeasurementCircle(withScale=0){
//    translate([0,0,withScale?0:-loopHeight])
    height=loopHeight* ( withScale?2:1);
    difference(){
        translate([-loopRadius+loopThickness/2,0,0]){
            CircleHalfSegment(h=height);
 
            // Spring Holder
            rotate([0,0,40])
                translate([loopRadius-loopThickness,0,(withScale?2:-0)*loopHeight])
                    rotate([withScale?0:180,0,0])
                    color("blue")
                        SpringHolder();
            if (! withScale ){
                translate([loopRadius-1.7*loopThickness,-10,-1.5*loopHeight])
                    cube([5,20,1.5*loopHeight]);
            }
        }

        // Cut out measurement stinger
        translate([-2*loopRadius+loopThickness/2,0,-1]){
            hull(){
                translate([0,0,0])                      cylinder(r=.1,h=height+2);
                translate([loopThickness,0,0])          cylinder(r=.1,h=height+2);
                translate([loopThickness*1.4,loopThickness,0]) cylinder(r=.1,h=height+2);
            }
        }
    
        // cutout Joint
        translate([0,0,-.1]) 
            cylinder(h=height+1,r=jointRadius,$fn=35);
    }


}

// =============================================================================
module CircleHalfSegment(h=loopHeight){
    difference(){
        cylinder(h=h,r=loopRadius,$fn=50);
        translate([0,0,-.1]) {
            cylinder(h=h+.2,r=loopRadius-loopThickness,$fn=50);
        
            translate([-loopRadius-5,-loopRadius-10,0])
                cube([loopRadius*2+10,loopRadius+10,h+.2]);
        }
    }
}

// =============================================================================
module CylinderSegment(r1=(loopRadius-loopThickness)*2/3,r2=loopRadius/2,angle=45,h=loopHeight){
    difference(){
        cylinder(h=loopHeight,r=r2);
        translate([0,0,-.1]) {
            cylinder(h=h+.2,r=r1,$fn=30);
        
            hull(){
                cylinder(h=h+.2,r=.01,$fn=30);
                
                for ( a=[angle:90:angle>=180?360:180])
                    rotate([0,0,a])
                        translate([1.5*r2,0,0])
                            cylinder(h=h+.2,r=.01,$fn=4);
                rotate([0,0,angle>180?360:180])
                    translate([1.5*r2,0,0])
                        cylinder(h=h+.2,r=.01,$fn=4);

            }
            
          if ( angle<180 ){
             hull(){
                cylinder(h=h+.2,r=.01,$fn=30);
                for ( a=[180:45:360])
                    rotate([0,0,a])
                        translate([1.5*r2,0,0])
                            cylinder(h=r2+.2,r=.01,$fn=4);
            }
        }
            
        }
    }
}


function cat(L1, L2) = [for(L=[L1, L2], a=L) a];