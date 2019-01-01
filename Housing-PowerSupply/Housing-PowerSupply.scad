//
$fn=18;
use <MCAD/boxes.scad>;
use <../Lib/Ruler.scad>

druckerUngenauigkeit=0.6;
wandStaerke=2.1; 
showItemsInsideHousing=0;
cutOutMiddlePartForDebugging=0;
mirrorFuerDruck=0;

dimensionsContent= [80,130,60];
echo("dimensionsContent: ",dimensionsContent); 
housingDisplaySpace=dimensionsContent
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




// -------------- Main --------------
color("green"){
    // Rueckseite
    translate([150,0,0]) Rueckseite(wandStaerke);

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

}

// -------------- Modules --------------
module Housing(){
    difference(){
       union(){
            roundedHollowBox(housingOutSide, 2, false,wandStaerke);
            ScrewHolders();
       }
        
        // Front Aussparung
        translate([10,-10,25])  voltageDisplay();
      
       // Poti Aussparung
        translate([20,0,10]){
            translate([0,0,0]) HolePoti();
            translate([10,0,0]) HolePoti();
        }
       // Buchsen Aussparung
        translate([70,0,10])
            for(x=[0:15:50]){
                translate([x,0,0]){
                    translate([0,0,0]) HolePoti();
                    translate([0,0,10]) HolePoti();
                }
            }
       
         // Rueckseite Space
        RueckseitePlatte(wandStaerke);
        }
        
//      DotMatrixDisplaysMountingHoles();  
        
    // Items to be placed inside Box
    if(showItemsInsideHousing)
        #union(){

            translate([housingSpace[0],housingSpace[1],0]
                     + wandStaerke*[1,1,1]
                     + (housingOutSide[2]-dimensionsContent[2]+.01)*[0,0,1]
                    )
                DotMatrixDisplays();


        }

    
}
   
module HolePoti(){
    translate([0,-10,0])
        rotate([0,0,180])
            rotate([90,0,0])
                cylinder(d=6,h=40);
}

module HoleBuchse(){
    translate([0,-10,0])
        rotate([0,0,180])
            rotate([90,0,0])
                cylinder(d=8,h=40);
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

module voltageDisplay(){
    translate([0,-10,0])
        cube([50,30,20]);
}



module SrewHolder(innerSize=2,    height=12){
    outerSize=innerSize+2;

    difference(){
        cylinder(d=outerSize,h=height);
        cylinder(d=innerSize,h=height-2);
    }
}

 module ScrewHolders(){
     sizeD=(3+2)/2;
    for(x=[wandStaerke+sizeD,housingOutSide[0]-wandStaerke-sizeD]){
        for(y=[wandStaerke+sizeD,housingOutSide[1]-wandStaerke-sizeD]){
            translate([x,y,0])
                SrewHolder(innerSize=3);
        }
    }
}

module SrewHole(innerSize=2,    height=12){
    cylinder(d=innerSize,h=height-2);
}

 module ScrewHoles(){
     sizeD=(3+2)/2;
    for(x=[wandStaerke+sizeD,housingOutSide[0]-wandStaerke-sizeD]){
        for(y=[wandStaerke+sizeD,housingOutSide[1]-wandStaerke-sizeD]){
            translate([x,y,-5])
                SrewHole(innerSize=3);
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
    difference(){
        RueckseitePlatte(wallThickness);    
        ScrewHoles();
    }
}

module RueckseitePlatte(wallThickness){
    rueckSeite = [housingOutSide[0],housingOutSide[1],wallThickness+0.2]
         - (2*wallThickness*[1,1,0]);
        translate([wallThickness,wallThickness,-.1])
            cube(rueckSeite);
}