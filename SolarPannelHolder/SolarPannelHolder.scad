// Holder for 

cutOutDifference=.5; // gap added for cutouts
showPannelInHolder=0;

// Dimensions Solar Pannel
pannelX=110;
pannelY=2;
pannelZ=110;

//wire Box attached to solar Pannel
wireBoxX=45+3;
wireBoxY=22.6;
wireBoxZ=23.4+5;
wireBoxOffsetZ=10-.5;

// Dimensions border added for holder Base
borderBase=2; // Border in every direction
borderX=4+borderBase+cutOutDifference;
borderY=0+borderBase+cutOutDifference;
borderZ=21+borderBase+cutOutDifference;

if(showPannelInHolder){

    translate([0,-80,0])    SolarPannel(cutOut=1);
    translate([0,-160,0])   SolarPannel();

    translate([-40,0,0])    ScrewHole();
}

translate([0,0,0]){
    difference(){
        SolarPannelHolder();
        // translate([100,-40,-10])            cube([100,100,100]);
        }
    
    if(showPannelInHolder)
        translate([0,0,0*borderZ])
            color("white")
                SolarPannel();
}

module SolarPannel(cutOut=0){
    cutOutAdd=cutOutDifference*cutOut;
    
    color("white"){
        // Pannel
        translate( cutOutAdd*[-1,-1,-1])
            cube( [pannelX,pannelY,pannelZ]
                + 2*cutOutAdd*[1,1,1]
                );

        // Pannel cutout to have free view
        if ( cutOut ){
            cutFreeY=borderY+1;
            cutReduceBorder=1.5;
            color("black")
            translate(
                [0,-cutFreeY+.1,0]
                +cutReduceBorder*[1,0,1]
//                + cutOutAdd*[1,1,1]
                )
                 cube( [pannelX,cutFreeY,.5*pannelZ]
                    - 2*cutReduceBorder*[1,0,0]);
            
/*
            translate([0,-cutFreeY-pannelY-.2,-cutOutAdd]
                +cutReduceBorder*[1,1,1]
                + cutOutAdd*[1,1,1]
                )
            #    rotate([0,0,-45])
                    cube( [10,cutFreeY,pannelZ]
                    - 2*cutReduceBorder*[1,0,1]);
*/
            }
        
        translate([0,0,wireBoxOffsetZ]){
            // Wire Box
            translate([pannelX/2-wireBoxX/2+cutOutAdd,cutOutAdd,0])
                cube( [wireBoxX,wireBoxY,wireBoxZ]
                    + 2*cutOutAdd*[1,1,11]);
            // Wire
            translate([pannelX/2+wireBoxX/2,12,10])
                rotate([0,90,0])
                    cylinder(d=3+cutOutAdd,h=20);
            
            if(cutOut){
              // Wire cutout
                translate([pannelX/2+wireBoxX/2,1,7])
                    cube([20,50,6]);
                translate([pannelX/2+wireBoxX/2,13,7])
                    cube([20,10,50]);
                translate([pannelX/2+wireBoxX/2+10,0,10])
                    rotate([0,90,90])
                        cylinder(d=13,h=50);
            }
            }
        }
}

module SolarPannelHolder(){
    
    difference(){
        holderZ=wireBoxZ+borderZ+wireBoxOffsetZ-5;

        translate(-[borderX,borderY,borderZ])
            cube([pannelX,pannelY+wireBoxY,holderZ-borderZ]
                +2*[borderX,borderY,borderZ]);

        SolarPannel(cutOut=1);

        // For saving Material cut out a lot in the back
        translate([-.1,0,0]
            +[-borderX*0,pannelY+borderY,borderZ])
            cube([pannelX,pannelY+wireBoxY,holderZ-borderZ]
                +2*[borderX*0,borderY,borderZ]
                +[.2,0,0]);
     
        // Screw holes
        screwLen=holderZ+borderZ+1;
        screwOffset=3+2;
        for ( x=[screwOffset,pannelX-screwOffset])
            for ( y=[pannelY+screwOffset,
                    pannelY+wireBoxY-0*screwOffset])
                translate([x,y,borderZ])
                   ScrewHole(d=4,screwLen=screwLen);
    }
}


// Schrauben Loch fuer Senkkopf Schrauben
module ScrewHole(
    d=3, 
    screwLen=20){         

    dScrew=d;
    dHead=dScrew+4;
    $fn=20;
        
    translate([0,0,0]){
//        rotate([270,0,0])
            union(){
                translate([0,0,-screwLen]) 
                    cylinder(d=dScrew,h=screwLen);
                translate([0,0,-2]) 
                    cylinder(d2=dHead,d1=dScrew,h=2);
                translate([0,0,-.01]) 
                    cylinder(d=dHead,h=51);
            }
    }
}