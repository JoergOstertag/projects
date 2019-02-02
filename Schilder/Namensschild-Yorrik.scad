which=0;
DEBUG=0;


numberHeight=34;
height=4;
borderY=8;
signHeight=numberHeight+(2*borderY);
angle=65;
heightBase=22;
diameterCandle=38;
signWidthAddition=12;


if ( ! DEBUG ){
    translate([0,0*(signHeight+5),0]) NameSign(displayText="Yorrik");
    if ( which == 1) translate([0,1*(signHeight+5),0]) NameSign(displayText="Niala");
    if ( which == 2) translate([0,2*(signHeight+5),0]) NameSign(displayText="Mimir");
}
    
if ( DEBUG ){

        difference(){
            NameSign(displayText="Yorrik");
            translate([-10,-10,0]) cube([100,100,100]);
        }
}

module NameSign(displayText="Yorrik"){
    signWidthAddition=12;
    signWidth=len(displayText)*numberHeight*2/3+(2*signWidthAddition);
        
    translate([0,0,heightBase])
            FrontPlate(displayText=displayText,signWidth=signWidth,signWidthAddition=signWidthAddition);

    BasePlate(signWidth=signWidth,signWidthAddition=signWidthAddition,height=heightBase);

   for(x=[2,signWidth]){
        translate([x,0,heightBase])
            SidePlate();
    }
    
    translate([0,0,heightBase+signHeight*cos(90-angle)])
        TopPlate();
}

module TopPlate(height=height,displayText="Yorrik"){
    signWidth=len(displayText)*numberHeight*2/3+(2*signWidthAddition);
   
    thickness=2;
    translate([0,signHeight*sin(90-angle),-thickness])
        cube([signWidth,signHeight*(1-sin(90-angle)),thickness]);
}

module SidePlate(height=height){
    thickness=2;
    translate([-thickness,0,0])
    difference(){
        cube([thickness,50,signHeight*cos(90-angle)]);
    translate([-1,0,0])
        rotate([angle,0,0])
                cube([22,62,50]);
//                cube([signWidth,signHeight,height]);

    }
}
  
module BasePlate(height=height){
    difference(){
        cube([signWidth,signHeight,height]);
//        rotate([65,0,0])            cube([signWidth,signHeight,height]);

        // Holes for candles
        for(x=[15+diameterCandle/2:diameterCandle+9:signWidth-diameterCandle/2]){
            translate([x,8+diameterCandle/2,1]){
                cylinder(h=height,d=diameterCandle);
               translate([-diameterCandle/2,0,10])    
                    cube([diameterCandle,diameterCandle,height]);
            }
        }
    }
}

module FrontPlate(displayText="Demo"){
translate([0,height-.52,-2])
    difference(){
        rotate([angle,0,0])
            difference(){
                cube([signWidth,signHeight,height]);

                translate([signWidthAddition+6,borderY,-.4]) 
                    linear_extrude(height = height) {
                        text(displayText, ,size=numberHeight,halign="left");
                    }
                }
        translate([-1,-height,0])     cube([signWidth+2,height*2,height/2]);
        }
// #    translate([0,.4-height,0])     cube([signWidth,height,height/2]);
       
}