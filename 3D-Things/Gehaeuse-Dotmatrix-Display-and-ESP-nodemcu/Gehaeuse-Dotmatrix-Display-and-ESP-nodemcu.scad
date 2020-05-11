//
$fn=18;
use <../Lib/NodeMcu.scad>;
use <MCAD/boxes.scad>;
use <../Lib/DotMatrix-Display.scad>;
use <../Lib/Ruler.scad>
use <../Lib/TSP05.scad>;

druckerUngenauigkeit=0.6;
wandStaerke=2.1; 
showItemsInsideHousing=0;
cutOutMiddlePartForDebugging=0;
mirrorFuerDruck=1;

dimensionsMatrixDisplay= getMatrixDisplayExtentions();
echo("dimensionsMatrixDisplay: ",dimensionsMatrixDisplay); 
housingDisplaySpace=dimensionsMatrixDisplay
                    +(2*[1,1,1])
                    +(druckerUngenauigkeit*[2,2,2]);
echo ("housingDisplaySpace: ", housingDisplaySpace);

//housingSpace=[8,2,6];
housingSpace=[20,4,6.5];
housingOutSide = housingDisplaySpace 
                + 2*wandStaerke*[1,1,1]
                + 2*housingSpace;
echo ("housingOutSide: ", housingOutSide);

housingInSide = housingOutSide - [2*wandStaerke,2*wandStaerke,2*wandStaerke];
echo ("housingInSide: ", housingInSide);

nodeMcuPosition=[wandStaerke+7+22,wandStaerke+7,housingInSide[2]-dimensionsMatrixDisplay[2]-3.7];

netzteilPosition=[housingOutSide[0]-80,wandStaerke+10,10];



// -------------- Main --------------
// Rueckseite
translate([0,50,0]) Rueckseite(wandStaerke);

difference(){
    // Umdrehen, damit Deckel unten zum Druck
    translate([0,0,mirrorFuerDruck*housingOutSide[2]])
        mirror([0,0,mirrorFuerDruck*1])
            // Housing
            Housing();
    // Zum Debugging halb aufschneiden
    if(cutOutMiddlePartForDebugging)
            translate([70,-100,0])cube([50,400,400]);
}

//translate([40,10,0])            Rulers();


// -------------- Modules --------------
module Housing(){
    difference(){
       union(){
            roundedHollowBox(housingOutSide, 2, false,wandStaerke);
            Stege();
       }
        
        // Front Aussparung
        translate(
                [housingSpace[0],housingSpace[1],0]
                +(1*[1,1,0])
                +(druckerUngenauigkeit*[1,1,0])
                + wandStaerke*[1,1,0]
                + [0,0,housingOutSide[2]-dimensionsMatrixDisplay[2]-0.5+.01]
                )
            DotMatrixDisplaySpace();

         // NodeMCU Space
        translate(nodeMcuPosition)
            mirror([0,0,1])
                NodeMcuSpace(pins=1);
       
         // Rueckseite Space
        Rueckseite(wandStaerke);
        }
        
//      DotMatrixDisplaysMountingHoles();  
        
    // Items to be placed inside Box
    if(showItemsInsideHousing)
        #union(){
//            translate([12.3,5.2,29.0])  Rulers();
//            cube(housingSpace);

            translate([housingSpace[0],housingSpace[1],0]
                     + wandStaerke*[1,1,1]
                     + (housingOutSide[2]-dimensionsMatrixDisplay[2]+.01)*[0,0,1]
                    )
                DotMatrixDisplays();

                translate(nodeMcuPosition)
                    mirror([0,0,1])
                        NodeMcu(pins=0);

                translate(netzteilPosition)
                    TSP05mitPlatine();
        }

    // NodeMcuHalterung
    translate(nodeMcuPosition)
        mirror([0,0,1])NodeMcuMontagePlatte(pins=0,full=0,randAussen=7);
}
     
module Stege(){
    translate([wandStaerke,wandStaerke,wandStaerke]){
        stegDickeX=wandStaerke;
        stegDickeY=8;
        for ( y=[0,housingInSide[1]-stegDickeY]){
            for ( x=[25:25:housingInSide[0]]){
                translate([x,y,0])
                    cube([stegDickeX,stegDickeY,housingInSide[2]]);
            }
        }
    }
}

module roundedHollowBox(size, radius, sidesonly,wallThickness){
    innerSize = size-(2*wallThickness*[1,1,1]);
    translate(size/2){ // Da das Original centered ist
        difference(){
            roundedBox(size, radius, sidesonly);
            roundedBox(innerSize, radius, sidesonly);
        }
    }
}

module Rueckseite(wallThickness){
    
    rueckSeite = [housingOutSide[0],housingOutSide[1],wallThickness+0.2]
         - (2*wallThickness*[1,1,0]);
    translate([wallThickness,wallThickness,-.1])
        cube(rueckSeite);
}