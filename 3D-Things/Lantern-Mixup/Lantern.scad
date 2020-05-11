// For printing arrange parts flat
showAllPartsForPrinting=0;

smallVersion=1;

showCompleteLantern=1;


width=smallVersion?20:90;
//height=smallVersion?25:150;
height=width*15/9;
frameThickness=smallVersion?2:8;
baseHeight=smallVersion?4:12;
studSize=smallVersion?5:10;
baseOverstand=studSize/6;
wallThickness=smallVersion?1.5:2.5;
frameThickness=smallVersion?6:14;
hoodHeight=smallVersion?22:60;
cutoutAddition=.2;

// ===========================================================
if (showAllPartsForPrinting){
    AllPartsForPrinting();
} else {
    SinglePartsForDebugging();
}


// ===========================================================
// Single parts for Debugging
module SinglePartsForDebugging(){
    if (1)
            difference(){
            Base();
            // Cutout for debugging
//            translate([-10,-10,-10])                cube([40,60,50]);
        }

    if (1) // SideWall
        translate([0,2*width-10,0]) {
            for ( i=[0:1] ) {
                translate([i*(width+15),0,0]) SideWall();
            }
        }
        
    if (1) // Hood
        translate([-width-40 ,0,0])
            difference(){
                Hood();
                // Cutout for debugging
                translate(-(wallThickness+studSize)*[1,1,0])
                    cube([width*2/3,width*2/3,hoodHeight]);
            }
    

    if (showCompleteLantern)
        translate(width*[2,0,0]){
    //        cylinder(h=400);
            LanternFullBuild();
        }
}

// ===========================================================
module AllPartsForPrinting(){
    // Final Base
    translate([0,-width-15,0])
//        Base();
    
    // Final Walls
    for ( x=[0:1] ){
        for ( y=[0:0] ){
            translate([x*(width+20),y*(height+20),0])    
                SideWall();
        }
    }
    
    // Final Hood
//    translate([width+25,-width-15,0])    Hood();
}

// ===========================================================
module Hood(){
    hoodOuterOverlap=smallVersion?0:5;
    hoodInnerOverlap=smallVersion?3:15;
    hoodWallThickness=hoodInnerOverlap+hoodOuterOverlap+studSize+wallThickness;
    hoodInnerWidth=width-2*hoodInnerOverlap;
    hoodOuterWidth=hoodInnerWidth+2*hoodWallThickness;
    difference(){
        translate([-hoodWallThickness+hoodInnerOverlap,
                    -hoodWallThickness+hoodInnerOverlap,0]){
                Pyramid(h=hoodHeight, b=hoodOuterWidth);

                // at bottom
                cube([hoodOuterWidth,hoodOuterWidth,1.2]);
        }

        // Inner cutout
        translate([hoodInnerOverlap,hoodInnerOverlap,-.1])
            Pyramid(h=hoodHeight-hoodWallThickness,
                    b=hoodInnerWidth,
                    b2=hoodWallThickness);

        // Hole for hanging
        translate([hoodInnerWidth/2+hoodInnerOverlap,
                   hoodOuterWidth*2/3,hoodHeight-hoodWallThickness*1/3])
            rotate([90,0,0])
                cylinder(h=hoodOuterWidth,d=3,$fn=30);

        // WallCutouts();
        mirror([0,0,1])
            WallCutouts();
    }        

}
    
// ===========================================================
module LanternFullBuild(){
    translate([0,0,-1.1])    Base();
    
    // Side walls
    translate([width/2,width/2,0])
    for (a=[0,90,180,270])
        rotate([0,0,a]){
            translate([-width/2,-width/2,0]){ 
                // Senkrechte Wand
                rotate([90,0,0])
                    SideWall();
            }
        
            
        }
       
   
   translate([0,0,height])    Hood();     
}

// ===========================================================
module Base(){
    floorAddition=wallThickness+baseOverstand+studSize/2+1; //wallThickness;
    translate([0,0,-baseHeight+wandStarke])
//    color("green")
    color("")
        difference(){
            translate(floorAddition*[-1,-1,0])
                cube([width+floorAddition*2,
                      width+floorAddition*2,
                      baseHeight]);

            translate([0,0,baseHeight])
                WallCutouts();
            }
        }
        
// ===========================================================
module WallCutouts(){
    cutoutHeight=(baseHeight-wallThickness);
    cutAdd=cutoutAddition;
    translate([width/2,
               width/2,-cutoutHeight]){
        // cutout for Studs
        for (a=[0,90,180,270])
            rotate([0,0,a])
        {
               translate([width/2,-width/2]){

               translate(wallThickness/2*[1,-1,0]
                        +studSize*[-.5,-.5,0]
                        + cutAdd*[-1,-1,0]
                        )    
                    cube( [studSize,studSize/2,cutoutHeight+.1]
                           + 2*cutAdd*[1,1,0]);
                                    
               translate(wallThickness/2*[1,-1,0]
                        +studSize/2*[0,-1,0]
                        + cutAdd*[-1,-1,0]
                        )    
                        cube( [studSize/2,studSize,cutoutHeight+.1]
                               + 2*cutAdd*[1,1,0]);
                }

                // cutout for walls
                translate([-width/2-wallThickness,
                           -width/2-wallThickness,
                            0])
                    cube([width+2*wallThickness,
                        wallThickness,
                        cutoutHeight+.1]);
            }
        }
}


// ===========================================================
module SideWall(){
    difference() {
        union(){
            color("white")
                difference(){
                    // Base Plate
                     cube([width+wallThickness,
                           height,
                           wallThickness]);
                     
                     // Thinner part (cutout) of Side pannel
                     translate([frameThickness,frameThickness,-.1])
                         cube([width - 2*frameThickness,
                               height - 2*frameThickness,
                               wallThickness+2]);
                 }

                // Side Stud 
                translate([-studSize/2-wallThickness/2,0,0])
                    color("black")
                        cube([studSize,height,(wallThickness+studSize)/2]);

                // Side Stud dummy
                translate([width-studSize/2,
                            0,0])
                    color("black")
                        cube([studSize/2-.2,
                              height,
                              (wallThickness+studSize)/2]);
             }
            
             // cutout for other wall
             translate([-wallThickness-cutoutAddition,-1,-1])
                cube([wallThickness+cutoutAddition*2,height+2,studSize/2]);
        }

}

// ===========================================================
module Pyramid(b=100,h=70,b2=0){
    sqrt2=sqrt(2);
    translate([b/2,b/2,0])
        rotate([0,0,45])
            cylinder(h=h,
                    r1=sqrt2*b/2,
                    r2=sqrt2*b2/2,$fn=4);
    
}
