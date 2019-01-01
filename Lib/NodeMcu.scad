//

use <Esp12.scad>;
use <MicroUsbBuchse.scad>;
use <Pin.scad>
use <Ruler.scad>


// NodeMCU Version 0.1
nodeMcuX=57.1; // Outside
nodeMcuX1=4.8; // Without Pins
nodeMcuY=30.7;
nodeMcuZ=13.1; // With Pins
nodeMcuZ1=1.5; // Dicke Platine
nodeMcuZ2=4.7; // With Pins

// -------------- Examples --------------
translate([0,-80,0]) NodeMcuMontagePlatte(pins=0,full=0);
translate([0,-40,0]) { 
            // Rulers(); 
            NodeMcuMontagePlatte(pins=0,full=0);
            NodeMcu(pins=1);};

translate([0,0,0]) NodeMcuMontagePlatte(pins=0);
translate([0,40,0]) NodeMcu();
translate([0,80,8]) NodeMcu();
translate([0,120,0]) NodeMcuSpace();

translate([100,40,0]) NodeMcu(pins=0);
translate([100,80,0]) NodeMcuSpace(pins=0);
translate([100,40,nodeMcuZ2]) Rulers();
translate([100,0,0]) NodeMcuMontagePlatte(pins=0);
translate([100,-40,0]) { 
            // Rulers(); 
            NodeMcuMontagePlatte(pins=0,full=0);
            NodeMcu(pins=0);};

// --------------------- Modules --------------------- 
function NodeMcuDimensions(pins=1) = (pins) ? [nodeMcuX,nodeMcuY,nodeMcuZ] 
                                            : [nodeMcuX,nodeMcuY,nodeMcuZ2] ;

module NodeMcuSpace(pins=1){
    difference(){
        cube(NodeMcuDimensions(pins=pins));
                    PlatinenBohrungen();  
    }

    translate([0,nodeMcuY/2-4,nodeMcuZ1])
        rotate([0,0,90])
            MicroUsbSteckerSpace();


}

module NodeMcuMontagePlatte(pins=1,full=1,randAussen=4){
    dickeBodenPlatte=1.7;
    bodenPlatteDimensions=[NodeMcuDimensions(pins=pins)[0],
                           NodeMcuDimensions(pins=pins)[1],
                            dickeBodenPlatte]
                          +2*+randAussen*[1,1,0];
    translate([0,0,-dickeBodenPlatte])
    difference(){
        union(){
            translate(-randAussen*[1,1,0]) cube(bodenPlatteDimensions);
            translate([0,0,dickeBodenPlatte])
                PlatinenBohrungen(pins=pins);
        }

        if( !full){
            randBreite=4;
            bodenPlatteDimensionsAusschnitt1= bodenPlatteDimensions
                                            - 2*randBreite*[0,1,0]
                                            - 2*randAussen*[1,1,0]
                                            + [0,0,1];
            translate([0,randBreite,-.1])
                cube(bodenPlatteDimensionsAusschnitt1);
            
            bodenPlatteDimensionsAusschnitt2= bodenPlatteDimensions
                                            - 2*randBreite*[1,0,0]
                                            - 2*randAussen*[1,1,0]
                                            + [0,0,1];
            translate([randBreite,0,-.1])
                cube(bodenPlatteDimensionsAusschnitt2);
        }
    }
}

module NodeMcu(pins=1){
    Platine();
    
    if (pins){
        pinOffsetX=10.8;
        pinOffsetY1=1.5;
        pinOffsetY2=nodeMcuY-    pinOffsetY1;
        translate([pinOffsetX,pinOffsetY1,0])
            rotate([180,0,0])PinRow(numberPins=15);
        translate([pinOffsetX,pinOffsetY2,0])
            rotate([180,0,0])PinRow(numberPins=15);
    }        
    translate([0,nodeMcuY/2-4,nodeMcuZ1])
        rotate([0,0,90])
            MicroUsbBuchse();

    
    translate([nodeMcuX-24,nodeMcuY/2-8,nodeMcuZ1])
        ESP12();
}


module pinRow(numberPins=15){
    pinBaseThickness=2.4;
    for (i=[1:numberPins]){
        translate([i*pinBaseThickness,0,0]){
            mirror([0,0,90])Pin(    pinBaseThickness=    pinBaseThickness);
    }
}

module Pin(    pinBaseThickness=2.4,
    pinBaseHeight=2.6,
    pinHeight=8.5,
    pinThickness=0.5
    ){
            color("black")
                cylinder(d=pinBaseThickness,h=pinBaseHeight);
            color("yellow")
                cylinder(d=pinThickness,h=pinHeight);
        }
    }
    
module Platine(){
    difference(){
            color("lightgreen")
                cube([nodeMcuX,nodeMcuY,nodeMcuZ1]);
            PlatinenBohrungen();  
            
            }
}    


module PlatinenBohrungen(){
            d=(3.0/2)+.5;
            $fn=18;
            for(x=[d,nodeMcuX-d]){
                for(y=[d,nodeMcuY-d]){
                    translate([x,y,-0.01])
                        cylinder(d=3.0,h=nodeMcuZ1+.3);
                }
            }
        }
