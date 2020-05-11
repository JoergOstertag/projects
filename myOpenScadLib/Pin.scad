//
$fn=18;    
//Pin(tilted=true,withBase=false);

translate([0,00,0])PinRow(count=1);
translate([0,10,0])PinRow();
translate([0,20,0])PinRow(withBase=true);
translate([0,30,0])PinRow(withBase=false);

translate([0,40,0])PlugRow(count=1);
translate([0,50,0])PlugRow(withBase=false);
 
 
translate([0,60,0])
     PinRow(count=1,tilted=true,withBase=false);
translate([0,70,0])PinRow(count=5,tilted=true);

module PinRow(count=15,height=8.5,withBase=true,tilted=false){
        
    pinBaseThickness=2.4;
    for (i=[0:count-1]){
        translate([i*pinBaseThickness,0,0]){
            Pin(baseThickness=pinBaseThickness,withBase=withBase,tilted=tilted,height=height);
        }
    }
}

module PlugRow(count=15,height=8.5,withBase=true,tilted=false){
    pinBaseThickness=2.4;
    for (i=[0:count-1]){
        translate([i*pinBaseThickness,0,0]){
            Plug(baseThickness=pinBaseThickness,withBase=withBase,tilted=tilted);
        }
    }
}


module Pin(  
    thickness=0.5,
    height=8.5,
    
    heightLower=2.1,
    
    baseThickness=2.4,
    baseHeight=2.6,
    withBase=true,
    
    widthTilted=7,
    tilted=false 
    ){

    color("yellow")
        cylinder(d=thickness,h=height);

    if (tilted){
         //   color("yellow")
            color("red")
                translate([0,0,height])
                    rotate([0,90,90])
                        cylinder(d=thickness,h=widthTilted);
        }

        if (withBase){
            color("black")
                cylinder(d=baseThickness,h=baseHeight);
            color("yellow")
                translate([0,0,-heightLower])
                    cylinder(d=thickness,h=heightLower);
        }
    }
    
  
    
module Plug(
    baseThickness=2.4,
    baseHeight=4.1,
    thickness=0.5,
    heightLower=2.7,
    tilted=false
    ){
    
    difference(){
        union(){
            color("yellow")
                cylinder(d=thickness+.2,h=baseHeight);
            color("black")
                cylinder(d=baseThickness,h=baseHeight-.01);
            }
        cylinder(d=thickness,h=baseHeight+.01);
        }
        
        color("yellow")
            translate([0,0,-heightLower])
                cylinder(d=thickness,h=heightLower);
        
}
  