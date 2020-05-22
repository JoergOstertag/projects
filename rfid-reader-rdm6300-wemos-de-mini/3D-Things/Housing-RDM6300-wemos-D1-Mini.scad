// use <../LibExternal/Triangles.scad>;
// use <MCAD/shapes/triangles.scad>;
use <MCAD/triangles.scad>;

debug=1; // [ 0:Debuggin off, 1:Debuggin on]

part=0; // [ 0:All, 1:RFID-Reader Housing, 2:Antenna Holder, 3:Bottom Lid ]

border=2;
border1=1;
addSpace=.25;
wemosD1Mini=[26,36,5]+addSpace*[2,2,2];
wemosD1ExperimentBoard=[26,29,12.5]+addSpace*[2,2,2];


// ---------------------------------------------------------------------------------------------------------
// do not need to modify anything below here
// ---------------------------------------------------------------------------------------------------------
/* [Hidden] */

$fn=45;
numberOfBaseMountingClips=0;

difference(){
    showPart(part=part);
 
    // cube to cut fee for Debugging
    if ( 0*debug ) 
        translate([25,0,-.1]) 
            cube([60,60,45]);
    
} 

module showPart(part=0){
    distX=70;
    distY=100;
    if ( part == 0) {
        for ( i = [1:10] )
            for ( j = [0:10] )
                translate([ (i-1)*distX, j*distY, 0]){
                    showPart(part= i + j*10);
                if ( debug) 
                    debugFrame(size=[distX-3,distY-3,2]);
            }
    } else {
        if ( part == 1) RFIDReaderHousing(placeForPrint=1);
        if ( part == 2) antennaHolder(placeForPrint=1);
        if ( part == 3) bottomLid(placeForPrint=1);
            
        if ( debug ) {
            if ( part == 11 ) {
                    RFIDReaderHousing();
                    translate([ 40,-1,41]) 
                        rotate([0,180,0]) 
                            antennaHolder();
                }

            if ( part == 12 ) {
                    translate([10,10,0]) antennaFrame(cutOut=1,placeForPrint=1);
                    translate([10,10,10]) antennaFrame(cutOut=0,placeForPrint=1);
            }
            if ( part == 13 ) bottomLid(cutOut=1,placeForPrint=1);

            if ( part == 21 ) {
                translate([ 0,10,0]) wemosCutout();
                translate([35,10,0]) RDM6300(cutOut=1);
                translate([60,10,0]) RDM6300(cutOut=0);
            }
        }
    }
}
antennaRingH=3.2;
antennaRingDInner=72;
antennaRingDOuter=86.5;


module RFIDReaderHousing(placeForPrint=0){
    connectionHeight=10;
    borderX=4;
    addY=12;
    
    outerSize=[ 1*wemosD1Mini[0] + 2*border,
                1*wemosD1Mini[1] + 2*border,
                1*wemosD1Mini[2] + 2*border
                   +wemosD1ExperimentBoard[2]
                ]
               +[2*borderX,15+addY,5];
    translate(placeForPrint*[0,outerSize[1],outerSize[2]]    )
    rotate([placeForPrint*180,0,0])
    union(){
    difference(){
        cube(outerSize);
       
        // Wemos cutout
        translate( border * [1,1,1] 
                  + borderX*[1,0,0]) 
            wemosCutout();


        translate([20,25, wemosD1Mini[2] + 2*border
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
}

module bottomLid(cutOut=0,placeForPrint=0){
    bottomHeight=4;
    addY=14;
    
    translate(placeForPrint*[14,19,bottomHeight]){
        // large bottom plate
        translate([-15,-20,-bottomHeight+cutOut*addSpace])
            cube([60,80,bottomHeight]);
        
        X= wemosD1Mini[0] + 2*border + cutOut*addSpace*2;
        Y= wemosD1Mini[1] + 2*border + cutOut*addSpace*2 + 14 + addY;
        
        // fit size of wemos
        cube(
            [X,Y, 2*border  +cutOut*addSpace*2]);

        // small fitting brim to hold things togeter
        sizeFitting=.5;
        translate(sizeFitting*[-1,-1,0]+[0,0,2])
            cube(
                [X,Y, cutOut*addSpace*2]
                +sizeFitting*[2,2,1]);
    }
}

module wemosCutout(){
        hBase=wemosD1Mini[2];
        height=hBase
            +wemosD1ExperimentBoard[2];
 
        addY=17;
        cube(wemosD1Mini + [.1,.1,.1]
            +[0,addY,0]
            );
        
        deltaY=wemosD1Mini[1]-wemosD1ExperimentBoard[1];
        translate([0,deltaY,hBase])
            cube(wemosD1ExperimentBoard
                +[0,addY,0]
                +[.1,.1,.1]);
        
        // Usb Cutout
        translate([6,31,-3])
            cube([14,45,9+4]); 

        // RFIDReader Board cutout  
        translate([4.6,13,7])
             RDM6300(cutOut=1);
}

module RDM6300(cutOut=1){
    translate(-[5,0,0])
        color("green")
        cube(   [16,38.5,6]
            +[6,0,0] // buffer-x
            +cutOut*2*[1,1,1]
            +cutOut*addSpace*2*[1,1,1]
        );

    color("white")
        translate([10,30,0])
            cube(   [6,8,15]
                    +cutOut*addSpace*[2,2,2]
                );

    color("black")
        translate([10,30,0])
            cube(   [5.6,7.3,25]
                    +cutOut*addSpace*[1,1,0]
                );

}


antennaOuterBase=[34.5,46.5,2.2];
antennaSpace=2;
module antennaHolder(){
    outerCube=  antennaOuterBase
            + border*[2,2,1]
            + addSpace*[2,2,2]
            + antennaSpace*[2,2,2];

    translate([outerCube[0]/2,outerCube[1]/2,0]) {
        difference(){
            translate(border*[0,0,1])
                cube(outerCube,center=true);
            translate([0,0,+0.2])
                antennaFrame(cutOut=1,antennaSpace=antennaSpace);
            
        }
        
        translate([0,0,border-.01])
            verbinder();
    }
}

module verbinder(cutOut=0){
    Z1=12;
    Z2=3;
    Z=Z1+Z2;
    D=10;
    noseSize=.2;
    
    rotate([0,cutOut*180,0])
    for (x=[-1,1])
        for (y=[-1,1])
            translate([x*8,y*11,-Z*cutOut]){
                cylinder(h=Z1,d=D+cutOut*addSpace);
                translate([0,0,Z1-.1])
                    cylinder(h=Z2+.1+cutOut*addSpace,
                            d1=noseSize+D+cutOut*addSpace,
                            d2=D-2);
            }
}

module antennaFrame(cutOut=0,antennaSpace=2,placeForPrint=0){
    wiresThick=1.3;
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

module debugFrame(size=[distX,distY,2],border=.1){
    difference(){
        cube(size);
        translate([0,0,-1])cube(size - border*[1,1,0]+[0,0,2]);
    }
}
                