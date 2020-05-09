use <../LibExternal/Triangles.scad>;

wemosD1Mini=[26,36,12];
wemosD1ExperimentBoard=[0,0,5+11];

servoSize=[30,30,14+2];

border=2;

innerCutout=[45.1,20,2,8]+1*[1,1,1];
topThicknessZ=12;

holeDistance=26.2;
diameter=15.9;

/* [Others] */
wallThickness = 2;
wallThicknessXY=wallThickness*[1,1,0];
wallThicknessXYZ=wallThickness*[1,1,1];
wallThicknessXYZ2=wallThicknessXYZ*2;

// ---------------------------------------------------------------------------------------------------------
// do not need to modify anything below here
// ---------------------------------------------------------------------------------------------------------
/* [Hidden] */

printerWobble=0.01;
printerWobbleXY=printerWobble*[1,1,0];
printerWobbleXYZ=printerWobble*[1,1,1];
printerWobbleXYZ2=printerWobbleXYZ*2;
$fn=45;
numberOfBaseMountingClips=4;

// Main
HandWashTimerHousing();

module HandWashTimerHousing(){

 connectionHeight=10;
    
 translate([14,border,servoSize[2]+connectionHeight+2*border])
    rotate([90,0,0])
        translate([-25,0,0]) // center to pins
        UltrasonicHousing();

    // connection Block
    // connectionBlock=[wemosD1Mini[0]+2*border,servoSize[1]+border,connectionHeight];
    connectionBlock=[wemosD1Mini[0]+2*border,17,connectionHeight];
    translate([0,-connectionBlock[1],servoSize[2]+2*border])
        cube(connectionBlock);

    // Wemos-D1-Mini Holder
    translate([0,0,0])
        difference(){
            wemosHolder();
            // cutout for SR04 cable
            translate([10,-5,25])
                cube([10,10,10]);
        }
        
    // Servo
    translate([0,-32,0]) 
        servoHolder();

    translate([0,0,0]) 
        BaseMountingClips(
            numberOfBaseMountingClips=numberOfBaseMountingClips,        outerSize=wemosD1Mini+2*border*[1,1,1]);
	
    }
    
module wemosHolder(){
    difference(){
        cube(wemosD1Mini+wemosD1ExperimentBoard+border*[2,2,1]);
        translate(border*1*[1,1,1])
            cube(wemosD1Mini+wemosD1ExperimentBoard+[.1,.1,.1]);
        
        // Usb Cutout
        translate([11,31,1])
            cube([11,15,7]);

    }
}
    
module servoHolder(){
    difference(){
        cube(servoSize+2*border*[1,1,1]);
        translate(border*[-1,-1,1])
            cube(servoSize);
        
        // cable cutout
        // translate([-2,25,1])            cube([5,5,25]);
    }
}

// Modules
module UltrasonicHousing(){
	outerBase = innerCutout
               + 2*wallThickness*[1,1,1]
               + topThicknessZ*[0,0,1];

	difference(){
	    cube(outerBase);

        // Inner cutout
	    translate(wallThicknessXYZ){
            translate(-printerWobbleXY+[0,0,-0.01-wallThickness])
                cube(  innerCutout
                       +wallThickness*[0,0,1]
                       +printerWobbleXYZ2);
	
		for (y=[3,17])
	        // IC / Pinrow cutout
	        translate([innerCutout[0],0,0]/2
						+[0,y,2.5+innerCutout[2]]
	                   +[0,0,-0.01])
	            cube([12,6,5]+printerWobbleXYZ,center=true);
	
		// Holes for sonic Receiver and Transmitter
	    translate([innerCutout[0]/2,innerCutout[1]/2,0])
            for ( x=[-holeDistance/2,holeDistance/2] )
                translate([x,0,0])
                    cylinder(d=diameter+2*printerWobble,h=10+12.3);

         // Front Text
	    translate([0,15.5,2+outerBase[2]-wallThickness-3]){
            translate([-1.8,0,0]) linear_extrude(height = 1.5) 
                     text("T", ,size=6,halign="left");
	         translate([41.3,0,0]) linear_extrude(height = 1.5) 
                     text("R", ,size=6,halign="left");
         }
         
         // cutout for Pins
        translate([17.5,-10,-2.1])
            cube([11,11,3.5]); 
	}	
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
