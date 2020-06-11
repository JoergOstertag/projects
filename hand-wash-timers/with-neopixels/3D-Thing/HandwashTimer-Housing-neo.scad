use <../LibExternal/Triangles.scad>;
use <MCAD/shapes/triangles.scad>;
use <MCAD/triangles.scad>;

debug=1; 

debugFrames=1*debug;

part=13; // [ 0:All, 1:Hand Wash Timer Housing, 2:Bottom Lid ,3:Bottom Lid with Mounting holes,4:Hand Wash Timer Housing No SR04, 5:Neopixel Holder plain]

// Border for walls 
border=1.3;
// Border thinner walls 
border1=1;

// Add Space to fit
addSpace=.3;

// Dimensions Wemos D1 Mini
wemosD1Mini=[26,35,7]+addSpace*[2,2,2];
wemosD1ExperimentBoard=[26,28,12]+addSpace*[2,2,2];


// -----------------------------------------------------------------
// do not need to modify anything below here
// -----------------------------------------------------------------
/* [Hidden] */

$fn=125;

difference(){
    showPart(part=part);
 
    //for Debugging 
    // to see inside Objects
    // cube to cut object apart 
    if ( 1 * debug ) 
        translate([59,2,-11.1]) 
        // translate([-14,2,-31.1]) 
            cube([120,190,55]);
    
} 

module showPart(part=0){
    if ( part == 0) showAllParts();
    
	if ( part == 1) HandWashTimerHousing(placeForPrint=1,withUltrasonic=1);
	if ( part == 2) bottomLid(placeForPrint=1,numberOfBaseMountingClips=0);
    if ( part == 3) bottomLid(placeForPrint=1,numberOfBaseMountingClips=4);
	if ( part == 4) HandWashTimerHousing(placeForPrint=1,withUltrasonic=0);
    if ( part == 5) neoPixelHolder(placeForPrint=1);
            
	if ( part == 11) HandWashTimerHousing(placeForPrint=0);
	if ( part == 12) {
		translate([0,0,0.1])	HandWashTimerHousing(placeForPrint=0);
		translate([41,43,0])	bottomLid(placeForPrint=0,numberOfBaseMountingClips=0,cutOut=0);
	}
	if ( part == 13) {
		translate([0,0,0.3])	HandWashTimerHousing(placeForPrint=0);
		translate([41.5,42.5,0])	bottomLid(placeForPrint=0,numberOfBaseMountingClips=4,cutOut=0);
	}			
    
    if ( debug ) {
        if ( part == 21 ) wemoscutOut();
		if ( part == 22 ) UltrasonicCutout();        
        if ( part == 23 ) UltrasonicHousing(placeForPrint=1);
        if ( part == 24 ) bottomLid(placeForPrint=1,cutOut=1);
        if ( part == 25 ) neoPixelcutOut(placeForPrint=1);
       
    }
}

module showAllParts(){
    distX=100;  maxX=5;
    distY=100; maxY=5;

    for ( i = [1:maxX] )
            for ( j = [0:maxY] )
                translate([ (i-1)*distX, j*distY, 0]){
                    showPart(part= i + j*10);
                	if ( debugFrames ) 
                    	debugFrame(size=[distX-3,distY-3,1]);
            		}
        
}
        

neoPixelRingH=3.2;
neoPixelRingDInner=72;
neoPixelRingDOuter=86.5;


module HandWashTimerHousing(numberOfBaseMountingClips=0,placeForPrint=0,withUltrasonic=1){

    connectionHeight=10;
	offsetX=0;
    borderX=4;
    
    outerSize=[ 1*wemosD1Mini[0] + 2*border,
                1*wemosD1Mini[1] + 2*border,
                1*wemosD1Mini[2] + 2*border
                    +wemosD1ExperimentBoard[2]
                ]
               +[2*borderX,0,0];
    
     translate(
     			placeForPrint*([0,0,outerSize[2]]+[28,1,5])
     			+[outerSize[0],outerSize[1],0])
		rotate(placeForPrint*[0,180,0]) {
		    difference(){
				 union(){
				        cube(outerSize);
				
					    // Neo Pixel Holder
					    translate([borderX+15, 8.5, outerSize[2]-border+1.3])
					        rotate([0,0,180]) 
					        	neoPixelHolder(placeForPrint=0);
					    
						// Cube around SR04
					    outerBase = [45.5,21,outerSize[2]]
					                + border*[2,2,1];
						color("blue")
						        translate(1*[-outerBase[0]/2,-outerBase[1],-outerBase[2]]
						        		+ 1*[outerSize[0]/2,0,outerSize[2]] 
						        		+ 1*border*[0,0,2]
						        		+ [0,7,-2.6])
						            cube(outerBase
						            	+ [0,outerSize[1],0] 
						        		); 


				}
		        
		        // Cut out SR04
				if (withUltrasonic)
		            translate(border*[1,0,1]
			                    + [4+wemosD1Mini[0]/2,border-.5+7 ,4.5+2.6 ]
			                )
			                rotate([0,0,180]) 
				                UltrasonicCutout();
		        
		        // Wemos cutOut
		        translate( border * [1,1,2] 
		                  + borderX*[1,0,0]) 
		            wemoscutOut();
		
		        // cutOut for Neopixel Cable
		        hCableCutout=12;
		        translate( border*[1,0,0]
		                    + [ offsetX + wemosD1Mini[0]/2-4,
		                    	wemosD1Mini[1] ,
		                    	9-hCableCutout-.01 ]
		                ) 
		            cube([16,border+2,hCableCutout]);
		
		        // remove border bottom
		        translate([borderX,1,0]
		                    +border*[0,1,0]
		                    +addSpace*[-1,-1,-1])
		            bottomLid(cutOut=1);
		
		        // remove border back
		        translate([borderX+border,wemosD1Mini[1]+border,-.1])   
		            cube([wemosD1Mini[0],2,border
		                    + wemosD1Mini[2]+0.5*wemosD1ExperimentBoard[2]]
		                +.2*[0,1,1]);

			    // Cut outs for inserting Neo Pixel Ring
	    	    translate([borderX+15, 8.5, outerSize[2]+4])
//		            rotate([0,0,180])
        		        neoPixelcutOut();

	        }
    }
	
	
}


module backLid(cutOut=0){
    cube([  wemosD1Mini[0] + 2*border,
            1,
            wemosD1Mini[2]+ wemosD1ExperimentBoard[2] ]
        +cutOut*[1,1,2]
    );
    
}

module wemoscutOut(){
        hBase=wemosD1Mini[2];
        height=hBase
            +wemosD1ExperimentBoard[2];
 
       cube(wemosD1Mini + [.1,.1,.1]);
       
        deltaY=wemosD1Mini[1]-wemosD1ExperimentBoard[1];
        translate([0,deltaY,hBase])
            cube(wemosD1ExperimentBoard
                +[.1,.1,.1]);
        
        // Usb cutOut
        translate([6,31,-3])
            cube([14,15,9+4]); 

        // SC04 4-Pin Plug cutOut
        // y direction is larger so we can slide in the SR04
        translate([7,0,0])
            cube([12,16,height]);


}

module neoPixelHolder(placeForPrint=0){
    dOuter=neoPixelRingDOuter +addSpace +border +6;
    dInner=0;
    // dInner=neoPixelRingDInner -addSpace -border -14;
    hTotal=neoPixelRingH                +border;
    
    translate(placeForPrint*[dOuter/2,dOuter/2,0])
    rotate(placeForPrint*[180,0,0])
    difference(){
        cylinder(h=hTotal,d=dOuter);
        translate([0,0,-.01])
            cylinder(h=hTotal+.02,d=dInner);
        
        translate([0,0,hTotal-.4])
            rotate([0,0,180])
                neoPixelcutOut();
        
     }
}

module neoPixelcutOut(placeForPrint=0){
    dOuter=neoPixelRingDOuter+addSpace;
    dInner=neoPixelRingDInner-addSpace;
    hTotal=neoPixelRingH + 4;

    numLeds=24;
    hLed=1.6;
    
    
    translate(placeForPrint*[dOuter/2,dOuter/2,0]+[0,0,-hTotal-hLed]){
	    difference(){
	        cylinder(h=hTotal,d1=dOuter+1,d2=dOuter);
	        translate([0,0,-.01])
	            cylinder(h=hTotal+.02,d1=dInner-1,d2=dInner);
	    }
	
		// Nibble at the side (probably for orientation)
	    translate([-3,dOuter/2 -3.2 , 0])    cube([6,6,hTotal]);
	
	    // for cables
	    translate([-10,dInner/2,-3])        cube([20,7,3.1]);
	
	    
	    for ( i=[0:360/numLeds:360] ){
	        rotate([0,0,i])
	            translate( [-3 , dInner/2, hTotal-.01 ] )
	                cube([6.5,7,hLed]);
	    }
    }
}



// Modules
module UltrasonicHousing(placeForPrint=0){
    innercutOut=[45.5,3.4,20]+border1*[1,0,1];

    tubeLen=12;

    holeDistance=26;
    diameter= 16.0    // diameter Speaker/Microphone 
    		+ 2*0.15; // Additional Space

	outerBase = innercutOut
                + [0,tubeLen,0]
                + 2*border*[1,0,1];

	//color("blue")
	translate(placeForPrint*[outerBase[0]/2,0,0])
	    difference(){
	    // union(){
	        translate([-outerBase[0]/2,0,0])
	            cube(outerBase);

            UltrasonicCutout();
		}
}
	
module UltrasonicCutout(){
    innercutOut=[45.5,21,3.4]+border1*[1,1,0];

    tubeLen=12;

    holeDistance=26;
    diameter= 16.0    // diameter Speaker/Microphone 
    		+ 2*0.15; // Additional Space

    // Inner cutOut
    translate(  [ -innercutOut[0]/2 ,border,-.01])
        cube(  innercutOut
               +border*[0,0,1]
               );

	// Cut out for inserting
	hInsertCutout=17;
    color("cyan")
    	translate(  [ -innercutOut[0]/2 ,border,+.1-innercutOut[2]-hInsertCutout-border])
        cube(  innercutOut
               +border*[0,0,1]
               +[0,0,hInsertCutout]
               );

    // IC / Pinrow cutOut
    translate( [ -6 , 0 , 2] )
        cube([12,4,6]);

    // Quartz cutOut
    translate( [ -6 , innercutOut[1]-6, 4 ] )
        cube([12,6,6]);

   	
    // cutOut for Pins
    translate([-6,-1,-5])
        cube([12,3.5,9+5]); 	

	// Holes for sonic Receiver and Transmitter
    translate([0,innercutOut[1]/2,border+innercutOut[2]-.1])
        for ( x=[-holeDistance/2,holeDistance/2] )
            translate([x,0,0]) {
                    cylinder(d1=diameter+1,d2=diameter,h=tubeLen);
        	
        			// Cut out Beam too to be sure
                    color("cyan") translate([0,0,tubeLen-.05]) 
    	                    cylinder(d1=diameter,d2=diameter+2,h=50);
                    }
	                        
	                        
}



module bottomLid(cutOut=0,placeForPrint=0,numberOfBaseMountingClips=0){
    bottomHeight=2.5;
    addY=0;
    addYcutOut=.0*cutOut;
    
    
    X= wemosD1Mini[0] + 2*border + cutOut*addSpace*2;
    Y= wemosD1Mini[1] + 1*border + cutOut*addSpace*2 
        + addY +addYcutOut;
                
    translate(placeForPrint*[14,19,bottomHeight]){
        difference(){
            union(){
                // large bottom plate
                bottomBorderX=4.5;
                bottomBorderY=3;
                //JOS
                
                basePlate=[X+2*bottomBorderX,Y+2*bottomBorderY,bottomHeight];
                translate([-bottomBorderX,-bottomBorderY,
                            -bottomHeight+cutOut*addSpace]) {
                    cube(basePlate);
		        
		        	// Base Mount Clips
			    	translate([0,0,0]) 
			        	BaseMountingClips(
			            	numberOfBaseMountingClips=numberOfBaseMountingClips,
			            	outerSize=basePlate);
	            	}
                
                // fit size of wemos
                cube(
                        [X,Y, 2*border  +cutOut*addSpace*2]);

                // small fitting brim to allow sliding Housing into Bottom plate
                sizeFitting=1.1;
                translate(sizeFitting*[-1,-1,0]+[0,0,1.2])
                    cube(
                        [X,Y, cutOut*addSpace]
                        +sizeFitting*[2,2,1]);
                
                
                // small fitting brim snap Housing into fixed position against Bottom plate
                sizeSnap=.7;
                translate(sizeSnap*[0,-1,0]
                        +[0,Y-5, 2*border  +cutOut*addSpace*2-.1])
                    cube(
                        [X,0, 0]
                        +sizeSnap*[0,2,1]);

            }
                 
            // Cut out for USB Plug
            if(! cutOut)
                translate([8,-1,0])
                    cube([14,Y+2,15]);
        }


    }
}


module BaseMountingClips(numberOfBaseMountingClips=4,outerSize=10){

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

module debugFrame( size=[60,60,2], border=.3) {
    translate([0,0,-size[2]])
	    color("white") 
		    difference(){
		        cube(size);
		        translate( [0, 0, .01]
		        		 + border*[1, 1, 0])
		            cube(size - 2*border*[1,1,0]+[0,0,size[2]]);
		    }
}
