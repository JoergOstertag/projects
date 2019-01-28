which=0;


numberHeight=30;
height=4;
borderY=8;
signHeight=numberHeight+(2*borderY);
angle=65;
heightBase=14;


translate([0,0*(signHeight+5),0]) NameSign(displayText="Yorrik");
if ( which == 1) translate([0,1*(signHeight+5),0]) NameSign(displayText="Niala");
if ( which == 2) translate([0,2*(signHeight+5),0]) NameSign(displayText="Mimir");

module NameSign(displayText="Yorrik"){
    signWidthAddition=12;
    signWidth=len(displayText)*numberHeight*2/3+(2*signWidthAddition);
        
    translate([0,height,heightBase])
            FrontPlate(displayText=displayText,signWidth=signWidth,signWidthAddition=signWidthAddition);

    BasePlate(signWidth=signWidth,signWidthAddition=signWidthAddition,height=heightBase);
}

module BasePlate(height=height){
    difference(){
        cube([signWidth,signHeight,height]);
//        rotate([65,0,0])            cube([signWidth,signHeight,height]);

        // Holes for candles
        diameterCandle=32;
#        for(x=[10+diameterCandle/2:diameterCandle+15:signWidth-diameterCandle/2]){
            translate([x,10+diameterCandle/2,1])
                cylinder(h=height,d=diameterCandle);
        }
    }
}

module FrontPlate(displayText="Demo"){
    rotate([65,0,0])
        difference(){
            cube([signWidth,signHeight,height]);

            translate([signWidthAddition+6,borderY,-.1]) 
                linear_extrude(height = height) {
                    text(displayText, ,size=numberHeight,halign="left");
                }
        }
#    translate([0,.4-height,0])
     cube([signWidth,height,height/2]);
       
}