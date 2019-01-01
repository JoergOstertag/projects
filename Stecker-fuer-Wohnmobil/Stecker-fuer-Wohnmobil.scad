// Stecker fuer Wohnmobil

use <MCAD/boxes.scad>;

// Hinterer Teil (Griff)
backOuterSize=[24,12.2,5.5];

// Vorderer Teil
frontOuterSize=[23,11.2,13.3];

wandStarke=4;
buchseOuterSide=[24,12.2,13.3+10.4] + wandStarke*[1,1,1];

lochHintenDurchmesser=7.2;
lochHintenLaenge=14.1;

lochVorneDurchmesser=4.1;
//lochVorneDistanz=14.3;
lochVorneDistanz=9.8+lochVorneDurchmesser;
lochVorneHoehe=8.4;

zapfenLaenge=10.4;
zapfenDurchmesser=3.35;
zapfenOffset=[0,-2.1,0];

arretierLasche=[6,backOuterSize[1]/2,2.5];

$fn=18;
debugShow=0;

// ---------------------- Examples ----------------------

if (debugShow){
    translate([0,0,0]) Stecker();
    translate([50,0,0]) SteckerHaelfte(side=0);
    translate([100,0,0]) SteckerHaelfte(side=1);
    translate([0,50,0]) Buchse(side=1);
}

translate([-40,0,backOuterSize[1]/2])  rotate([90,0,0]) SteckerHaelfte(side=0);
translate([-70,0,0]) rotate([90,0,0]) SteckerHaelfte(side=1);


// ---------------------- Main ----------------------

module Buchse(){
    difference(){
        translate([-buchseOuterSide[0]/2,-buchseOuterSide[1]/2,-buchseOuterSide[2]])
            cube(buchseOuterSide);
        Stecker();
        }
}
module Stecker(zapfen=1){
    radiusHinten=2;
    radiusVorne=4.5;
    difference(){
            union(){
                // Hinterer Teil
                translate([0,0,backOuterSize[2]/2]) 
                        roundedBox(backOuterSize,radiusHinten,true);

                // Vorderer Teil
                translate([0,0,-frontOuterSize[2]/2]) 
                       roundedBox(frontOuterSize, radiusVorne, true);

                // Zapfen vorne
                if(zapfen)
                        translate([0,0,-frontOuterSize[2]])
                            translate(zapfenOffset)
                            rotate([0,180,0])
                                cylinder(d=zapfenDurchmesser,h=zapfenLaenge);

            }

            // Loch hinten
//            translate([0,0,backOuterSide[2]-lochHintenLaenge]) 
            translate([0,0,backOuterSize[2]-lochHintenLaenge]) 
                    cylinder(d=lochHintenDurchmesser,h=lochHintenLaenge+.01);

            verkabelungsAussparung1=[7.1,3.7*2,10];
            verkabelungsAussparung1Offset=[9,3,13];
            translate([0,0,verkabelungsAussparung1[2]/2] 
                      -[0,0,frontOuterSize[2]]
                      +[0,0,4.3]) 
                    cube(verkabelungsAussparung1,center=true);

            verkabelungsAussparung2=[16.6,2*1.5,8.9];
            verkabelungsAussparung2Offset=[9,3,13];
            translate([0,0,verkabelungsAussparung2[2]/2] 
                      -[0,0,frontOuterSize[2]]
                      +[0,0,4.3]) 
            cube(verkabelungsAussparung2,center=true);

            verkabelungsAussparung3=[15.0,2.9*2,2.9];
            verkabelungsAussparung3Offset=[9,3,13];
            translate([0,0,verkabelungsAussparung3[2]/2] 
                      -[0,0,frontOuterSize[2]]
                      +[0,0,4.3]) 
            cube(verkabelungsAussparung3,center=true);

            // Löcher vorne
            for (x=[-lochVorneDistanz/2,lochVorneDistanz/2]){
                translate([x,0,-frontOuterSize[2]-.1]) 
                    SteckerAussparung();                                        
            }
    }
}

module SteckerAussparung(){
        cylinder(d=lochVorneDurchmesser,h=lochVorneHoehe+.1);

//        cylinder(d=lochVorneDurchmesser+2*wulstDicke,h=wulstHoehe);
//2.8 
        wulstDurchmesser=2*2.9;
        wulstHoehe=4.2;
        wulstDistanz=2.9;
        translate([0,0,wulstDistanz])
            cylinder(d=wulstDurchmesser,h=wulstHoehe);
}

module SteckerHaelfte(side=0){
    zapfen= side==1?0:1;
    
    difference(){
        Stecker(zapfen=zapfen);

        // Haelfte freischneiden
        {
            cutX=backOuterSize[0] +.1;
            cutY=backOuterSize[1]/2 +.1;
            cutZ=frontOuterSize[2]+backOuterSize[2] +.1;
            cutZd=-frontOuterSize[2]-.01;
            translate([-cutX/2,-side*cutY,cutZd])
                cube([cutX,cutY,cutZ+.02]);
        }
        
        if(side){
            ArretierLaschen();            
        }
    }
    if(!side)
        ArretierLaschen();
}


module ArretierLaschen(){
    arretierLascheY=arretierLasche[1];
    arretierLascheZ=arretierLasche[2];
    for (x=[-lochVorneDistanz/2,lochVorneDistanz/2]){
        translate([x,0,backOuterSize[2]-arretierLascheZ])
            ArretierLasche();
    }
    
    translate([0,0,-frontOuterSize[2]-.01+arretierLasche[2]])
        mirror([0,0,1])
            ArretierLasche(laenge=frontOuterSize[1]/2);
 
}

module ArretierLasche(laenge=arretierLasche[1]){
    miniZusatz=(0.01*[1,1,1]);
    arretierLasche1=[arretierLasche[0],laenge,arretierLasche[2]];
        translate([-arretierLasche1[0]/2,-.001,0])
            cube(arretierLasche1 + miniZusatz);

    arretierLasche2Y=2.1;
    arretierLasche2=[arretierLasche1[0],arretierLasche2Y,arretierLasche1[2]/2];
    translate([-arretierLasche1[0]/2,arretierLasche1[1]-arretierLasche2[1],-arretierLasche2[2]])
        cube(arretierLasche2+miniZusatz);
}