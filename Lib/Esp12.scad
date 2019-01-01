//
grundPlatineX=24;
grundPlatineY=15.9;
grundPlatineZ=0.7;

ESP12();

module ESP12(){
    ESP12GrundPlatte();
    translate([1.4,(grundPlatineY-12)/2,grundPlatineZ])
        EspCap();
    translate([grundPlatineX-6.8,2.1,1])
        Antenne();
}
module pinRow(numberPins=15){
    pinBaseThickness=2.4;
    for (i=[1:numberPins]){
        translate([i*pinBaseThickness,0,0]){
            mirror([0,0,90])Pin(    pinBaseThickness=    pinBaseThickness);
    }
}

module Pin( pinBaseThickness=2.4,
            pinBaseHeight=2.6,
            pinHeight=8.5,
            pinThickness=0.5 ){
            color("black")
                cylinder(d=pinBaseThickness,h=pinBaseHeight);
            color("yellow")
                cylinder(d=pinThickness,h=pinHeight);
        }
    }
    
module Antenne(){
    color("gold"){
        b=0.5;
        d=.1;
        translate([0,4.4,0]) cube([b  ,7.9,d]);
        translate([0,12.3,0]) cube([6.2,b ,d]);

        for(i=[0:3]){ // wagerechte
            translate([1.7,4.3+i*2,0]) {
                translate([4.0,  1,   0]) cube([b  ,b+1,d]); // rechts
                translate([0,    1,   0]) cube([4.0  ,b,d]); // wagerecht
                translate([0,    0,   0]) cube([b  ,b+1,d]); // links
                translate([0,    0,   0]) cube([4.0  ,b,d]); // wagerecht
                }
        }
        translate([5.7,  1.8,   0]) cube([b  ,3,d]); // rechts
    }
}

module ESP12GrundPlatte(){
    difference(){
        color("green")
            cube([grundPlatineX,grundPlatineY,grundPlatineZ]);

    randAbstand=1.0;
    translate([1.4,randAbstand,0])
        HoleRow();
    translate([1.4,grundPlatineY-randAbstand,0])
        HoleRow();
    }
}

module EspCap(){
    color("silver")
            cube([15,12,2.2]);
}

module HoleRow(count=8){
    lochAbstand=2.5;
    for (i=[0:count]){
        translate([i*lochAbstand,0,0])
            Hole();
     }
}

module Hole(){
    cylinder(d=0.5,h=2);
}