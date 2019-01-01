// Battery holder for Pixoio Robot
outerDimensions=[110,110,70];

outerDimensionsXY=[outerDimensions[0],outerDimensions[1],0];
cutoutLevel0=[92.6,99,36.6];
cutoutLevel1=[91.4,89.2,20.1];
cutoutLevel2=[70.0,74,2.4];
cutoutLevel3=[65.6,54,10.9];
cutoutLevel4=[46,60,5];


function offsetOnTopCentered(lowerDimensions,topDimensions)= 
    [ lowerDimensions[0]/2-topDimensions[0]/2
    , lowerDimensions[1]/2-topDimensions[1]/2
    , lowerDimensions[2]];

function offsetCenteredXY(lowerDimensions,topDimensions)= 
    [ lowerDimensions[0]/2-topDimensions[0]/2
    , lowerDimensions[1]/2-topDimensions[1]/2
    ,0];
        

offsetLevel0=               offsetOnTopCentered(outerDimensionsXY,cutoutLevel0);
offsetLevel1= offsetLevel0+ offsetOnTopCentered(cutoutLevel0,cutoutLevel1);
offsetLevel2= offsetLevel1+ offsetOnTopCentered(cutoutLevel1,cutoutLevel2);
offsetLevel3= offsetLevel2+ offsetOnTopCentered(cutoutLevel2,cutoutLevel3);
offsetLevel4= offsetLevel5+ offsetOnTopCentered(cutoutLevel3,cutoutLevel4);

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

overlapZ=0.1*[0,0,1];
overlapZ2=0.1*[0,0,2];

$fn=20;


//Main
difference(){
    PicioCap();
    translate([55,-10,-10])cube([200,200,200]);
}

// Modules


module PicioCap(){
    difference()
    {
       cube(outerDimensions);

        union(){
            translate(offsetLevel0-printerWobbleXYZ-overlapZ)
                cube(cutoutLevel0+printerWobbleXYZ2+overlapZ2);
            
            translate(offsetLevel1-printerWobbleXYZ-overlapZ)
                cube(cutoutLevel1+printerWobbleXYZ2+overlapZ2);

            translate(offsetLevel2-printerWobbleXYZ-overlapZ)
                cube(cutoutLevel2+printerWobbleXYZ2+overlapZ2);

            translate(offsetLevel3-printerWobbleXYZ-overlapZ){
                cube(cutoutLevel3+printerWobbleXYZ2+overlapZ2);
        
                ScrewCutout();
            }
       
         translate(offsetLevel3-printerWobbleXYZ-overlapZ)
                cube(cutoutLevel3+printerWobbleXYZ2+overlapZ2);
     
        }
    }
}

module  ScrewCutout(){
    screwCutoutDimension=[20,16,25];
    offsetLevelScrew=  offsetCenteredXY([cutoutLevel3[0],0,0],screwCutoutDimension)
        +[0,cutoutLevel3[1]+screwCutoutDimension[1]/2,-screwCutoutDimension[2]/2];
//    cutoutLevel3
    translate(offsetLevelScrew)
       cube(screwCutoutDimension);
}