//
$fn=18;
use <Pin.scad>;
use <Ruler.scad>;

druckerUngenauigkeit=0.5;
matrixPlatineX=32.4;
matrixPlatineY=32.3;
matrixPlatineZ=1.5;

matrixDisplayX=31.7;
matrixDisplayY=31.7;
matrixDisplayZ=5.3;
matrixDisplayZtotal=13.1;
matrixDisplayZd2=7.1-matrixDisplayZ;
pinHeight=1.7;
offsetFirstPinX=6.8;
offsetFirstPinY=2;

// Breite eines 4er Display: 129.6

DotMatrixDisplays();
translate([0,40,0]) DotMatrixDisplay();
translate([0,80,0]) SingleDotMatrixDisplay();
translate([0,-40,-3]) DotMatrixDisplaySpace();
translate([0,-80,-3]) DotMatrixDisplaysMountingHoles();
translate([0,-40,-3]) Rulers();

function getMatrixDisplayExtentions(count=4) = [matrixPlatineX*count,matrixPlatineY,matrixDisplayZtotal];


// A cube representing the Dot Matrix outside
module DotMatrixDisplaySpace(count=4){
    cube(getMatrixDisplayExtentions(count=count)
        +(druckerUngenauigkeit*[1,1,1]) );


    // herrausstehende Stifte
    electricalConnectionPinsDimension=[18,12.5,6.6];
        translate([ -electricalConnectionPinsDimension[0],
                    -electricalConnectionPinsDimension[1]/2+matrixDisplayY/2,
                    0 ])
        cube(electricalConnectionPinsDimension
            +(druckerUngenauigkeit*[1,1,1]) );
}

module DotMatrixDisplaysMountingHoles(count=4){
    for ( i=[0:count-1] ){
        translate([i*matrixPlatineX,0,0])
            MountingHoles();
    }
}

module DotMatrixDisplays(count=4){
    for ( i=[0:count-1] ){
        translate([i*matrixPlatineX,0,0])
            DotMatrixDisplay();
    }
    
    // electrical connection pins
    electricalConnectionPins();
}

module electricalConnectionPins(){
    // electrical connection pins
    translate([2,12,0])
        rotate([0,0,90])
            PinRow(count=5,height=3.7,tilted=true);
}

module DotMatrixDisplay(){
        BasePlatine();
        translate([0,0,pinHeight+1.5])
            SingleDotMatrixDisplay();
}


module BasePlatine(){
    color("green")
        difference(){
            cube([matrixPlatineX,matrixPlatineY,matrixPlatineZ]);
            MountingHoles();
        }

        // two rows of electrical plugs
        for(y=[offsetFirstPinY,matrixDisplayY-offsetFirstPinY]){
            translate([offsetFirstPinX,y,0])
                PlugRow(count=8);
        }
 
        
        // Text:  .-->IN         OUT-->
         color("white"){
            translate([.5, 1,matrixPlatineZ-.15]) 
                text(".-->IN", size=1.5);
            translate([matrixPlatineX-.5, 1,matrixPlatineZ-.15]) 
                text("OUT-->", ,size=1.5,halign="right");   

            // TEXT: VCC, GND, DOUT, CS, CLCK
            translate([4,13,0])
                 rotate([180,0,0])
                 TextMultiLine(){
                        text("VCC", ,size=1.5,halign="left");   
                        text("GND", ,size=1.5,halign="left");   
                        text("DOUT", ,size=1.5,halign="left");   
                        text("CS", ,size=1.5,halign="left");   
                        text("CLK", ,size=1.5,halign="left");   
                 }
             }
} 


module MountingHoles(distX=2.9,distY=5.5){
    diameter=3.0;
    // dist=diameter/2+1;
    // if (dist == undef) dist=5.5;
        
    for(x=[distX,matrixPlatineX-distX]){
        for(y=[distY,matrixPlatineY-distY]){
            translate([x,y,-.001])
                cylinder(d=diameter,h=matrixPlatineZ+.002);
        }
    }
}
        
module TextMultiLine(){
  union(){
    for (i = [0 : $children-1])
      translate([0 , -i * 2.4, 0 ]) children(i);
  }
}


module SingleDotMatrixDisplay(){
    translate([0,0,matrixDisplayZd2]){
        difference(){
            union(){
                color("white"){
                    cube([matrixDisplayX,matrixDisplayY,matrixDisplayZ]);
                    MatrixDisplayFeet();
                }
                translate([0,0,matrixDisplayZ])
                    color("black")
                        cube([matrixDisplayX,matrixDisplayY,0.001]);
                }   
            LedPattern();
        }

        // electrical pins
        for(y=[offsetFirstPinY,matrixDisplayY-offsetFirstPinY]){
            translate([offsetFirstPinX,y,0])
                mirror([0,0,90])
                    PinRow(count=8,height=pinHeight,withBase=false);
        }
    }
    
    // square shaped feet at the corner of the display
    module MatrixDisplayFeet(){
                matrixDisplayFeet=2.2;
                for(x=[0,matrixDisplayX-matrixDisplayFeet]){
                    for(y=[0,matrixDisplayY-matrixDisplayFeet]){
                        translate([x,y,-matrixDisplayZd2])
                            cube([matrixDisplayFeet,matrixDisplayFeet,matrixDisplayZd2]);
                    }
                }
    }
            
    module LedPattern(){
            for (x=[2.3:3.76:30.3]){
                for (y=[2.3:3.76:matrixDisplayX-2]){
                    translate([x,y,matrixDisplayZ])
                        LedImprint();
                }
            }
    }
            
    module LedImprint(){
        $fn=18;
        h1=.1;
        translate([0,0,-h1])
            color("red",.9)
                cylinder(d=3.1,h=h1-.001);
        translate([0,0,-.1])
            color("red",0.3)
                cylinder(d=3.1,h=+.11);
    }
}