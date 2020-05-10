use <../LibExternal/Triangles.scad>;

wemosD1Mini=[26,36,12];
wemosD1ExperimentBoard=[0,0,5+6.9];

servoSize=[30,20,14+1];

border=2;


/* [Others] */
wallThickness = 1;
wallThicknessXY=wallThickness*[1,1,0];
wallThicknessXYZ=wallThickness*[1,1,1];
wallThicknessXZ=wallThickness*[1,0,1];
wallThicknessXYZ2=wallThicknessXYZ*2;

// ---------------------------------------------------------------------------------------------------------
// do not need to modify anything below here
// ---------------------------------------------------------------------------------------------------------
/* [Hidden] */

$fn=45;
numberOfBaseMountingClips=4;

// Main
HandWashTimerHousing();
//UltrasonicHousing();

module HandWashTimerHousing(){

    connectionHeight=10;

    outerSize=[ 0*wemosD1Mini[0] + 1*servoSize[0] + 2*border,
                1*wemosD1Mini[1] + 1*servoSize[1] + 2*border,
                1*wemosD1Mini[2] + 0*servoSize[2] + 2*border
                    +wemosD1ExperimentBoard[2]
                ];
    
    difference(){
        cube(outerSize);
        
        translate( border * [1,1,1] 
                  + [0,servoSize[1],0])
            wemosCutout();
            
        // Servo cutout
        translate([-.1,-.1,border])
            servoCutout();
        
    }


    translate([15,20+4+border,outerSize[2]])
        rotate([0,0,180])
            UltrasonicHousing();

    translate([0,0,0]) 
        BaseMountingClips(
            numberOfBaseMountingClips=numberOfBaseMountingClips,
            outerSize= outerSize);
	
    }
    
module wemosCutout(){
        cube(wemosD1Mini
            +wemosD1ExperimentBoard
            +[0,0,10]
            +[.1,.1,.1]);
        
        // Usb Cutout
        translate([7,31,-3])
            cube([12,15,9+4]);

}
    
module servoCutout(){
    cube(servoSize);
        
    // cable cutout
     translate([-2,servoSize[1]-4.5-5,1])
        cube([5,5,15]);
}

// Modules
module UltrasonicHousing(){
    innerCutout=[45.5,4.4,20]+1*[1,1,1];

    tubeLen=12;

    holeDistance=26;
    diameter=16.3;

	outerBase = innerCutout
                + [0,tubeLen,0]
                + 2*wallThicknessXZ;

	difference(){
    // union(){
        translate([-outerBase[0]/2,0,0])
            cube(outerBase);

        // Inner cutout
        translate(  [ -innerCutout[0]/2 ,-.01,wallThickness])
            cube(  innerCutout
                   +wallThickness*[0,1,0]
                   );
	
        // IC / Pinrow cutout
	    translate( [ -6, 0 , wallThickness ] )
	            cube([12,6,innerCutout[2]]);
         // cutout for Pins
        translate([-6,-3,-2])
            cube([12,6,3.5]); 	

		// Holes for sonic Receiver and Transmitter
	    translate([0,innerCutout[1],0])
            for ( x=[-holeDistance/2,holeDistance/2] )
                translate([x,0,wallThickness+innerCutout[2]/2])
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
    	    rotate([0,0,(x>0.01?-90:90)])
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
       				Right_Angled_Triangle(a=2, b=sizeBaseMountY,height=reinforcementX);
       

        
        

    }        
}
