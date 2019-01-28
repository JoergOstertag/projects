which=0;


numberHeight=30;
height=4;
borderY=8;
signHeight=numberHeight+(2*borderY);
angle=65;


translate([0,0*(signHeight+5),0]) NameSign(displayText="Yorrik");
if ( which == 1) translate([0,1*(signHeight+5),0]) NameSign(displayText="Niala");
if ( which == 2) translate([0,2*(signHeight+5),0]) NameSign(displayText="Mimir");

module NameSign(displayText="Yorrik"){
    signWidthAddition=12;
    signWidth=len(displayText)*numberHeight*2/3+(2*signWidthAddition);
        
    rotate([65,0,0])
        FrontPlate(displayText=displayText,signWidth=signWidth,signWidthAddition=signWidthAddition);

    BackPlate(signWidth=signWidth,signWidthAddition=signWidthAddition);
}

module BackPlate(){
    difference(){
        cube([signWidth,signHeight,height]);
        rotate([65,0,0])
            cube([signWidth,signHeight,height]);
    }
}

module FrontPlate(displayText="Demo"){
    difference(){
        cube([signWidth,signHeight,height]);

        translate([signWidthAddition+6,borderY,-.01]) 
            linear_extrude(height = height+.2) {
                text(displayText, ,size=numberHeight,halign="left");
            }
    }
}