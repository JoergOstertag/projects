DEBUG=0;

// displayText="Yorrik"; // Weiss
//displayText="Niala"; // Schwarz
//displayText="Mimir"; // Türkis
//displayText=""; //  Bianca Grün 🥝
displayText="Domedes"; //  Rolo Feuerrot



// Candle
diameterCandle=39;
heightCandle=32;
heightCandle=21;

thicknessFront=4;
borderY=5;
angle=65;
heightBase=heightCandle+2;

numberHeight=30;
signWidthAddition=5;
signHeight=numberHeight+(2*borderY);

textWidthAddition=-6; // Niala
textWidthAddition=-14; // Yorrik
textWidthAddition=36; // Diomendes
textWidth=len(displayText)*numberHeight*2/3+textWidthAddition;

signWidth=textWidth+(2*signWidthAddition);
signDepth=diameterCandle+4+4;


if ( ! DEBUG ){
    NameSign(displayText=displayText);
} else {

    difference(){
            NameSign(displayText=displayText);
            translate([-19,-10,0]) cube([100,100,100]);
        }
}

module NameSign(displayText="Yorrik"){
        
    translate([0,0,heightBase])
                                                 FrontPlate(displayText=displayText,signWidth=signWidth,signWidthAddition=signWidthAddition);

    BasePlate(signWidth=signWidth,signWidthAddition=signWidthAddition,
                heightCandle=heightCandle,heightBase=heightBase);

    SidePlates(signWidth=signWidth);

    BackPlate(thicknessFront=thicknessFront,signWidth=signWidth);
    
    translate([0,0,heightBase+signHeight*cos(90-angle)])
        TopPlate(signWidth=signWidth);
}

module TopPlate(thicknessFront=thicknessFront,displayText=displayText){
   
    thickness=6;
    translate([0,signHeight*sin(90-angle),-thickness])
        cube([signWidth,signDepth-signHeight*(sin(90-angle)),thickness]);
}

module BackPlate(thicknessFront=thicknessFront){
    thickness=2;
    backHeight=10;
    translate([0,signDepth-thickness,heightBase+signHeight*cos(90-angle)-backHeight])
        cube([signWidth,thickness,backHeight]);
}

module SidePlates(thicknessFront=thicknessFront){
    thickness=signWidthAddition;
//#    for(x=[0,signWidth-thickness]){
    for(x=[0,signWidth-thickness]){
            translate([x,0,heightBase])
                difference(){
                    cube([thickness,signDepth,signHeight*cos(90-angle)]);
                translate([-1,0,0])
                    rotate([angle,0,0])
                            cube([22,62,50]);
            //                cube([signWidth,signHeight,thicknessFront]);
                }
        
    }
}
  
module BasePlate(heightCandle=heightCandle){
    difference(){
        cube([signWidth,signDepth,heightBase]);
//        rotate([65,0,0])            cube([signWidth,signHeight,thicknessFront]);

        // Holes for candles
        spaceBetweenCandles=13; // Niala
        spaceBetweenCandles=20; // Yorrik
        spaceBetweenCandles=4; // Diomedes
        leftSPaceBeforeCandles=4;
        
        for(x=[signWidthAddition+diameterCandle/2+leftSPaceBeforeCandles:diameterCandle+spaceBetweenCandles:signWidth-diameterCandle/2]){
            translate([x,thicknessFront+2+diameterCandle/2,2]){
                cylinder(h=heightCandle+1,d=diameterCandle);
                translate([-diameterCandle/2,0,heightBase-heightCandle])    
                    cube([diameterCandle,diameterCandle,heightCandle]);
            }
        translate([signWidthAddition,thicknessFront+diameterCandle/2,heightBase-heightCandle+4])    
            cube([signWidth-2*signWidthAddition,diameterCandle,heightCandle]);
        }
    }
}

module FrontPlate(displayText="Please enter Text"){
translate([0,thicknessFront-.52,-2])
    difference(){
        rotate([angle,0,0])
            difference(){
                cube([signWidth,signHeight,thicknessFront]);
                translate([0,0,-.6]) get3DText(displayText=displayText);    
                translate([0,0,thicknessFront-.3]) get3DText(displayText=displayText);    

                }
        translate([-1,-thicknessFront,0])
            cube([signWidth+2,thicknessFront*2,thicknessFront/2]);
        }
       
}

module get3DText(displayText=displayText){
    translate([signWidthAddition,borderY,0]) 
        linear_extrude(height=thicknessFront) {
            text(displayText, ,size=numberHeight,halign="left");
    }
}