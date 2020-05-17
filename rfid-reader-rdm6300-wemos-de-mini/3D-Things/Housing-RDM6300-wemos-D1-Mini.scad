// use <../LibExternal/Triangles.scad>;
// use <MCAD/shapes/triangles.scad>;
use <MCAD/triangles.scad>;

debug=1; // [ 0:Debuggin off, 1:Debuggin on]

part=0; // [ 0:All, 1:RFID-Reader Housing, 2:Bottom Lid, 3:Antenna Holder]

border=2;
border1=1;
addSpace=.5;
wemosD1Mini=[26,36,5]+addSpace*[2,2,2];
wemosD1ExperimentBoard=[26,29,12.5]+addSpace*[2,2,2];


// ---------------------------------------------------------------------------------------------------------
// do not need to modify anything below here
// ---------------------------------------------------------------------------------------------------------
/* [Hidden] */

$fn=45;
numberOfBaseMountingClips=0;

if ( debug ) {
    translate([  0,110,0])
        difference(){
            union(){
                RFIDReaderHousing();
                translate([ 20,30,41]) 
                    rotate([0,180,0]) 
                        antennaHolder();
            }
            
            // cube to cut fee for Debugging
            if ( 0*debug ) 
                    translate([25,0,-.1]) 
                        cube([60,60,45]);
        }
    translate([ 60,110,0]) wemosCutout();
    translate([120,110,0]) antennaFrame(cutOut=0);
    translate([160,110,0]) antennaFrame(cutOut=1);
    translate([190,110,0]) RDM6300(cutout=1);
    
} 
showPart(part=part);

module showPart(part=0){
    if ( part == 0) {
        for ( i = [1:10] )
            for ( j = [0:10] )
                translate([ (i-1)*60, j*60, 0])
                    showPart(part= i + j*10);
    } else {
        if ( part == 1) RFIDReaderHousing();
        if ( part == 2) bottomLid();
        if ( part == 3) antennaHolder();
    }
}
antennaRingH=3.2;
antennaRingDInner=72;
antennaRingDOuter=86.5;


module RFIDReaderHousing(){
    connectionHeight=10;
    borderX=4;
    
    outerSize=[ 1*wemosD1Mini[0] + 2*border,
                1*wemosD1Mini[1] + 2*border,
                1*wemosD1Mini[2] + 2*border
                   +wemosD1ExperimentBoard[2]
                ]
               +[2*borderX,15,5];
    
    difference(){
        cube(outerSize);
       
        // Wemos cutout
        translate( border * [1,1,1] 
                  + borderX*[1,0,0]) 
            wemosCutout();


        translate([20,30, wemosD1Mini[2] + 2*border
                    +wemosD1ExperimentBoard[2]
               ])
            verbinder(cutOut=1);


        // remove border bottom
        translate([borderX,0,-.1]
                    +border*[0,1,0]
                    +addSpace*[-1,-1,0])
            bottomLid(cutOut=1);

        // remove border back
        translate([borderX+border,wemosD1Mini[1]+border,-.1])   
            cube([wemosD1Mini[0],2,border
                    + wemosD1Mini[2]+0.5*wemosD1ExperimentBoard[2]]
                +.2*[0,1,1]);
        }

    // Antenna Holder
//    translate([borderX+15,7.5,outerSize[2]-1.2*border+2])
  //      rotate([0,0,180]) antennaHolder();
    
    // Base Mount Clips
    translate([0,0,0]) 
        BaseMountingClips(
            numberOfBaseMountingClips=numberOfBaseMountingClips,
            outerSize= outerSize);
	
    }


module bottomLid(cutOut=0){
    cube(
        [wemosD1Mini[0],wemosD1Mini[1],border]
        +border*[2,2,1]
        +cutOut*addSpace*[2,2,2]);
}

module backLid(cutout=0){
    cube([  wemosD1Mini[0] + 2*border,
            1,
            wemosD1Mini[2]+ wemosD1ExperimentBoard[2] ]
        +cutout*[1,1,2]
    );
}

module wemosCutout(){
        hBase=wemosD1Mini[2];
        height=hBase
            +wemosD1ExperimentBoard[2];
 
       cube(wemosD1Mini + [.1,.1,.1]);
        deltaY=wemosD1Mini[1]-wemosD1ExperimentBoard[1];
        translate([0,deltaY,hBase])
            cube(wemosD1ExperimentBoard
                +[.1,.1,.1]);
        
        // Usb Cutout
        translate([6,31,-3])
            cube([14,45,9+4]); 

        // RFIDReader Board cutout  
        translate([4,13,7])
             RDM6300(cutout=1);
}

module RDM6300(cutout=1){
    color("green")
        cube(   [16,38.5,6]
            +cutout*addSpace*[2,2,2]
        );

    color("white")
        translate([10,30,0])
            cube(   [6,8,15]
                    +cutout*addSpace*[2,2,2]
                );

    color("black")
        translate([10,30,0])
            cube(   [5.6,7.3,25]
                    +cutout*addSpace*[1,1,0]
                );

}


antennaOuterBase=[34.5,46.5,2.2];
module antennaHolder(){
    outerCube=  antennaOuterBase
            + border*[2,2,1];

    difference(){
        translate(border*[0,0,1])
            cube(outerCube,center=true);
        translate([0,0,+0.2])
            antennaFrame(cutOut=1);
        
    }
    
    translate([0,0,border-.01])
        verbinder();
}

module verbinder(cutOut=0){
    for (x=[-1,1])
        for (y=[-1,1])
            translate([x*8,y*11,0])
                cylinder(h=15,d=8+cutOut*.2);

}

module antennaFrame(cutOut=0){
    wiresThick=1.3;
    antennaSpace=1;
    height=antennaOuterBase[2];
    antennaInner= antennaOuterBase
                -wiresThick*[1,1,0]
                +cutOut*antennaSpace*[-2,-2,2]
                + [0,0,.2];
    antennaOuter=   antennaOuterBase
                    +cutOut*antennaSpace*[2,2,2];

    translate(  [0,0,height/2]
                +cutOut*antennaSpace*[0,0,1]
             )
        difference(){
            cube(antennaOuter,center=true);
            cube(antennaInner,center=true);
       }
    // cable cut out
    translate([antennaOuterBase[0]/2-3,-4,0]
+                border*[0,0,0])
        cube([4,26,4]);
}



module BaseMountingClips(numberOfBaseMountingClips=4,outerSize){

    diameterBaseClipHoles=3;
    
    outerSizeX = outerSize[0];
    outerSizeY = outerSize[1];
    outerSizeZ = outerSize[2];


    yRange= (numberOfBaseMountingClips==4) ? [5.5,outerSizeY-5.5]
                :(numberOfBaseMountingClips==2) ? [outerSizeY/2] : [];

    
    for( x=[0,outerSizeX]){
        for( y=yRange){
            translate([x,y,0])
    	    rotate([0,0,(x > 0.01?-90:90)])
    	        BaseMountingClip(
                    diameterBaseClipHoles=diameterBaseClipHoles,
                    x=x,y=y);
        }
    }
}

module BaseMountingClip(diameterBaseClipHoles=3){
    diameterSkrewHead=diameterBaseClipHoles+4;
    reinforcementX=1.5;
    sizeBaseMountX=diameterSkrewHead + 1 + 2*reinforcementX;
    sizeBaseMountY=diameterSkrewHead + 3;
    sizeBaseMountZ=2.5;
    
    translate([-sizeBaseMountX/2,0,0])
    union(){
        difference(){
        	
            cube([sizeBaseMountX,sizeBaseMountY,sizeBaseMountZ]);

            // central hole for screw
            translate([sizeBaseMountX/2,sizeBaseMountY/2,-0.01])
                cylinder(d=diameterBaseClipHoles,h=sizeBaseMountZ+1);

            //  hole for screw-head
            translate([sizeBaseMountX/2,sizeBaseMountY/2,2])
                cylinder(d=diameterSkrewHead,h=sizeBaseMountZ+1);

            *translate([2,2,1])
                cube([sizeBaseMountX-3*2,sizeBaseMountY-3*2,sizeBaseMountZ]);
        }
        
        for(x=[0,sizeBaseMountX-reinforcementX])
       		translate([x,0,sizeBaseMountZ])
       			rotate([90,0,90]) 
       				Right_Angled_Triangle(a=2, 
                            b=sizeBaseMountY,height=reinforcementX);
       

        
        

    }        
}
