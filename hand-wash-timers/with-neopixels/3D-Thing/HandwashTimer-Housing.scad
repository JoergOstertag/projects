// use <../LibExternal/Triangles.scad>;
// use <MCAD/shapes/triangles.scad>;
use <MCAD/triangles.scad>;

debug=0;


border=2;
border1=1;
addSpace=.5;
wemosD1Mini=[26,36,5]+addSpace*[2,2,2];
wemosD1ExperimentBoard=[26,29,20]+addSpace*[2,2,2];


// ---------------------------------------------------------------------------------------------------------
// do not need to modify anything below here
// ---------------------------------------------------------------------------------------------------------
/* [Hidden] */

$fn=45;
numberOfBaseMountingClips=0;

// Main
difference(){
    translate([0,debug*20,0]) HandWashTimerHousing();
    
    // cube to cut fee for Debugging
    // translate([25,-60,-.1])cube([120,120,20]);
    // # translate([-25,-60,-14-.1])cube([120,120,20]);
    // translate([11,border,-.1])cube([28,39,border+.2]);
}
//translate([0,90,0]) bottomLid(cutout=0);
//wemosCutout();
// neoPixelCutout();

if ( debug ) {
    translate([-60,0,0]) wemosCutout();

    translate([-90,50,0]) UltrasonicHousing();

    translate([0,-60,0]) neoPixelHolder();

    translate([90,-60,0]) neoPixelCutout();



}

neoPixelRingH=3.2;
neoPixelRingDInner=72;
neoPixelRingDOuter=86.5;


module HandWashTimerHousing(){

    connectionHeight=10;
//    offsetX=9.5;
     offsetX=0;
    borderX=4;
    
    outerSize=[ 1*wemosD1Mini[0] + 2*border,
                1*wemosD1Mini[1] + 2*border,
                1*wemosD1Mini[2] + 2*border
                    +wemosD1ExperimentBoard[2]
                ]
               +[2*borderX,0,0];
    
    difference(){
        cube(outerSize);

        // CUt away outer part for fitting SR04
        translate(border*[0,-1,1]
                    + [-4,.1 ,wemosD1Mini[2]+border1 ]
                ) 
            cube([47,8,32]);
        
        // Wemos cutout
        translate( border * [1,1,1] 
                  + borderX*[1,0,0]) 
            wemosCutout();

    /*
        translate( border*[0,-1,0]
                    + [offsetX,wemosD1Mini[1] -2 ,-.01 ]
                ) 
            backLid(cutout=1);
    */
        // remove border bottom
        translate([borderX+border,border,-.1])
            cube([wemosD1Mini[0],wemosD1Mini[1],border]
                +.2*[1,1,1]);
       
        // remove border back
        translate([borderX+border,wemosD1Mini[1]+border,-.1])
            cube([wemosD1Mini[0],2,border-5
                    + wemosD1Mini[2]+wemosD1ExperimentBoard[2]]
                +.2*[0,1,1]);
        }

    // SR04
    translate([borderX+15,8,border+14+4.5])
        rotate([90,0,0])
            UltrasonicHousing();

    // Neo Pixel Holder
    translate([borderX+15,7.5,outerSize[2]-1.2*border+2])
        rotate([0,0,180]) neoPixelHolder();
    
    // Base Mount Clips
    translate([0,0,0]) 
        BaseMountingClips(
            numberOfBaseMountingClips=numberOfBaseMountingClips,
            outerSize= outerSize);
	
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
            cube([14,15,9+4]); 

        // SC04 4-Pin Plug cutout
        // y direction is larger so we can slide in the SR04
        translate([6,-3,7])
            cube([14,16,13]);


}

module neoPixelHolder(){
    dOuter=neoPixelRingDOuter +addSpace +border +4;
    dInner=0;
    // dInner=neoPixelRingDInner -addSpace -border -14;
    hTotal=neoPixelRingH                +border;
    difference(){
        cylinder(h=hTotal,d=dOuter);
        translate([0,0,-.01])
            cylinder(h=hTotal+.02,d=dInner);
        
        translate([0,0,.01+border])
            rotate([0,0,180])
                neoPixelCutout();
        
        // cutout for SR04
        translate([-22.5,2,-.01])
            cube([45,21,hTotal+1]);
        
    }
}


module neoPixelCutout(){
    dOuter=neoPixelRingDOuter+addSpace;
    dInner=neoPixelRingDInner-addSpace;
    hTotal=neoPixelRingH;
    difference(){
        cylinder(h=hTotal,d=dOuter);
        translate([0,0,-.01])
            cylinder(h=hTotal+.02,d=dInner);
    }

    translate([-3,dOuter/2-.2,0])    cube([6,6,hTotal]);

    // FOr cables
    translate([-10,dInner/2,-3])        cube([20,7,3.1]);

    // for cable tie to fix cables
    rotate([0,0,-12])
        translate([-6,dInner/2-3,-3]) 
        cube([8,12,hTotal+6]);

    numLeds=24;
    for ( i=[0:360/numLeds:360] ){
        rotate([0,0,i])
            translate([-3,dInner/2+1,hTotal])
                cube([6,6,2]);
    }
}



// Modules
module UltrasonicHousing(){
    innerCutout=[45.5,3.4,20]+border1*[1,0,1];

    tubeLen=12;

    holeDistance=26;
    diameter=16.3+1;

	outerBase = innerCutout
                + [0,tubeLen,0]
                + 2*border*[1,0,1];

	color("blue")
    difference(){
    // union(){
        translate([-outerBase[0]/2,0,0])
            cube(outerBase);

        // Inner cutout
        translate(  [ -innerCutout[0]/2 ,-.01,border])
            cube(  innerCutout
                   +border*[0,1,0]
                   );
	
        // IC / Pinrow cutout
	    translate( [ -6, 0 , border ] )
	            cube([12,6,innerCutout[2]]);
         // cutout for Pins
        translate([-6,-3,-2])
            cube([12,6,3.5]); 	

		// Holes for sonic Receiver and Transmitter
	    translate([0,innerCutout[1],0])
            for ( x=[-holeDistance/2,holeDistance/2] )
                translate([x,0,border+innerCutout[2]/2])
                    rotate([-90,0,0])
                        cylinder(d=diameter,h=12.3);
    }
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
