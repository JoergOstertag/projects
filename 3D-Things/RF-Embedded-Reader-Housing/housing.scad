
innerSize=[17.3,55.4,5.3];

/* [Others] */
wallThickness = 2.0;

// show some Examples
showExamples=true;

// ---------------------------------------------------------------------------------------------------------
// do not need to modify anything below here
// ---------------------------------------------------------------------------------------------------------
/* [Hidden] */

extraGap=0.1;
printerWobble=0.501;
//printerWobble=0.01;

printerWobbleXY   = printerWobble * [1,1,0];
printerWobbleXYZ  = printerWobble * [1,1,1];
printerWobbleXYZ2 = printerWobble * [2,2,2];

wallThicknessXY   = wallThickness * [1,1,0];
wallThicknessXYZ  = wallThickness * [1,1,1];
wallThicknessXYZ2 = wallThickness * [2,2,2];

$fn=20;



housing();



module housing(){
	outerSize=innerSize + wallThicknessXYZ2 ;
	
	difference(){
		cube(outerSize);
		translate(wallThicknessXY  - printerWobbleXYZ ) cube(innerSize + printerWobbleXYZ2);
		translate(wallThicknessXYZ - printerWobbleXYZ ) cube(innerSize + printerWobbleXYZ2);

		// Cable outlet
		cableSize=[10,2*wallThickness,7];
		translate([outerSize[0]/2-cableSize[0]/2,-0.01,0]- printerWobbleXYZ )            cube(cableSize+printerWobbleXYZ);

		translate(wallThicknessXYZ){
			// Antenna outlet
			antennaSize=[11,5,1];
			translate(	innerSize
						+ printerWobbleXYZ
						+ [-antennaSize[0]-3.8,-antennaSize[1],-0.01]- printerWobbleXYZ
)
			            cube(antennaSize+printerWobbleXYZ);
		}
		
		translate(wallThicknessXYZ
					+printerWobbleXYZ
					+[0,0,innerSize[2]-3.2]
		){
			h=1.7;
			h2=3.2;
			// Spulen vom Anschlus richtung Antenne
			translate([12,7,0]) 		cube( printerWobbleXYZ2 + [4,3,h]);

			//Chip
			translate([2.1,16,0]) 		cube( printerWobbleXYZ2 + [9,9,h]);

			translate([1,30.7,0]) 		cube( printerWobbleXYZ2 + [1.5,3.2,h]);
			translate([11.2,30.7,0]) 	cube( printerWobbleXYZ2 + [1.5,3.2,h]);

			translate([4.9,35.6,0]) 	cube( printerWobbleXYZ2 + [3.7,2.4,h2]);

			translate([9.9,39.9,0]) 	cube( printerWobbleXYZ2 + [3.1,1.4,h2]);

		}
	}
}