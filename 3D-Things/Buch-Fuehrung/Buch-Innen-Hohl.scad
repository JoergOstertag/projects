debug=0;

// Das Ergebnis ist gleich liegend
liegend=1;

// Nur der Seitenwand Deckel
doSeitenwandOnly=0;

// Der Buchrücken bekommt eine zusätzliche Rundung
mitRueckenBogen=1;

// STatt eines AUges ein abgerundetes Loch
doAugenHoehle=1;
doShowAuge=1;

druckerUngenauigkeit = .1;
buchDicke = 41;
buchTiefe = 106;
buchHoehe = 175;

// Boden
bodenBreite = buchDicke - druckerUngenauigkeit;
bodenLaenge = buchTiefe-0 - druckerUngenauigkeit;
bodenDicke = 3;

// Seitenwände
seitenwandDicke = 2;
seitenwandHoehe = buchHoehe;

// Buchrücken
rueckenDicke=8;

// Befestigungen
befestigungBreite = buchDicke; // 18;
befestigungLaenge = 12;
befestigungDicke = 2.5;
lochDurchmesser=3;


// Servo Definitionen
servoBreite=29.1 + druckerUngenauigkeit;
servoTiefe=14.0 + 3+ druckerUngenauigkeit;
servoHoehe=25.8 + druckerUngenauigkeit;
//servoHoeheBisAufnahme=18.1;
servoAufnahmeBreite=10;
lochDurchmesser=2.7;
lochDistanz=3.0;
aufnahmeDicke=3.0;


dist=0;
$fn=50;


if (debug){
//    AugeSegment();
//      BuchRuecken();
    SeitenWandLoch();
}else {
        rotate(a=[0,-90*liegend,0]) 
        if (doSeitenwandOnly){
            SeitenWandLoch();
        } else {
            Buch();
        }

}

module Buch(){
        union(){
    
        // Grundplatte
        color("gray")
            GrundPlatte();
    
        // Obere Deckplatte
        color("gray")
            translate([0,0,seitenwandHoehe-bodenDicke])
            DeckPlatte();
    
        
        // Seiten Wände
        color("red"){
                translate([0,0,0])
                    SeitenWand();
                translate([bodenBreite-seitenwandDicke,0,0])
                    SeitenWand(loch=1);
        }
    
        // Buch Rücken
        translate([0,bodenLaenge,0]){
                BuchRuecken();
        }
        
        
        // Befestigungsloch
        for (dist=[0:15:1*15]){
            translate([0, dist , bodenDicke]) 
                    Befestigung();
            translate([0,dist,seitenwandHoehe-bodenDicke-befestigungLaenge])
                Befestigung();
        }

    // Rudermaschinen Befestigung
    translate([seitenwandDicke , bodenLaenge-servoBreite-25 , bodenDicke+15]) 
                    ServoHalterung();

    // Rudermaschinen Befestigung am Rücken
    translate([seitenwandDicke , bodenLaenge-servoBreite-aufnahmeDicke-rueckenDicke , bodenDicke+75]) 
//        rotate([90,0,0])
            ServoHalterung();
    
    }
}


module Befestigung(){
    rotate(a=[90,0,180]) 
    translate([-befestigungBreite,0,0])
    difference(){
    // union(){
        cube([befestigungBreite,befestigungLaenge,befestigungDicke], center = false);
        translate([befestigungBreite/2,befestigungLaenge/2, -.1])
            color("cyan")
            cylinder(h = (befestigungDicke)+.2, r = lochDurchmesser/2, center = false);
    
    }
}

module BuchRuecken(){
    difference(){
        if (mitRueckenBogen){
            color("cyan")
                BuchRueckenBogen();
        } else {
            color("cyan")
                BuchRueckenFlach();
        }
    
        if ( doAugenHoehle){
        translate([bodenBreite/2 , mitRueckenBogen*6 -11, seitenwandHoehe/5*4])    
            AugenHoehle();
        }
    }
    
    // Auge
    translate([bodenBreite/2 , mitRueckenBogen*6 , seitenwandHoehe/5*4])    
        if ( doShowAuge){
            scale(.96)
              AugeSegment();
        }
}


// TODO: wenn dicke kleiner als Radius ist
// dann ist die Breite nicht komplett, da ja das Kreissegment abgeschnitten ist
module BuchRueckenBogen(dicke=5,breite=bodenBreite){

    radius = ((dicke*dicke)+(breite/2*breite/2))/(2*dicke);


       translate([breite/2,0,0])
       difference(){
            translate([0,-radius+dicke,0])
                cylinder(r=radius,h=seitenwandHoehe,center=false);
            translate([-radius-1,-2*radius+dicke,0-1])
                cube([2*radius+2, 2*radius-dicke, seitenwandHoehe+2], center = false);
            
    }
}

module BuchRueckenFlach(dicke=rueckenDicke){
    translate([0,-dicke,0])
        cube([bodenBreite, dicke, seitenwandHoehe], center = false);
}

// Size ist der überstand, der zu sehen ist
module AugeSegment(radius=16,size=5){
    translate([0,-radius+size,0])
   difference()
    //union()
    { 
        Auge(radius=radius);
        translate([-radius,-radius-10,-radius])
           cube([2*radius+0,(2*radius)-size, 2*radius]);
       }
 }

module AugenHoehle(radius=16){
        color("white")
            sphere(r=radius);
    }

module Auge(radius=16){
    union(){
        radius1=radius;
        radius2=20/2;
        radius3=10/2;
        radius4= 0; // 5/2;
        
        color("white")
            HohlKugel(radius=radius1);
        translate([0 , radius1-radius2*9/10 , 0])    
            color("blue")
                HohlKugel(radius=radius2);
if(1)
    translate([0 , radius1+radius2*1/10-radius3*9/10 , 0])    
            color("black")
                HohlKugel(radius=radius3);
    }
 }

 
module SeitenWand(loch=0){
    difference(){
        cube([seitenwandDicke, bodenLaenge, seitenwandHoehe], center = false);

        if (loch)
             SeitenWandLoch();
    }
}

module SeitenWandLoch(){
        randOffsetX = 0; // seitenwandDicke
        randOffsetY1 = -0.1; // bodenLaenge/15;
        randOffsetY2 = 5; // bodenLaenge/15;
        randOffsetZ = 0; // seitenwandHoehe/15;
    translate([-.1+randOffsetX ,  randOffsetY1,randOffsetZ])
        cube([.2 + seitenwandDicke - (2*randOffsetX), bodenLaenge- randOffsetY1 - randOffsetY2, seitenwandHoehe- (2*randOffsetZ)], center = false);

    // Nasen f. Befestigung
    {
        SeitenwandNase();
        translate([0,0,seitenwandHoehe]) 
            mirror([0,0,1])
                SeitenwandNase();
    }
}

module SeitenwandNase(){
    nasenLaenge=5;
    translate([seitenwandDicke/2,  seitenwandDicke/2,-nasenLaenge])
        cylinder(d=seitenwandDicke,h=nasenLaenge);
}

module GrundPlatte(){
        cube([bodenBreite, bodenLaenge, bodenDicke ], center = false);
}
    
module DeckPlatte(){
        cube([bodenBreite, bodenLaenge, bodenDicke ], center = false);
}




/**
  *      Servo
  */
module ServoHalterung(){
//     translate([0,0,servoHoeheBisAufnahme]) 
    {
        color("red"){
//            translate([0,-servoAufnahmeBreite,0])
                mirror([0,1,0])
                servo_aufnahme();
            translate([0,servoBreite,0])
                servo_aufnahme();
        }

//    Servo();

    }
}

module Servo(){
    // Simulierter Servo
    cube([servoTiefe,servoBreite,servoHoehe], center = false);
}

module servo_aufnahme(){
    difference(){
//    union(){
        cube([servoTiefe,servoAufnahmeBreite,  aufnahmeDicke], center = false);
        translate([servoTiefe/2,lochDistanz, (aufnahmeDicke/2)-1])
            color("cyan")
            cylinder(h = (aufnahmeDicke+3), r = lochDurchmesser/2, center = true);
    }
}



/**
Diverse
*/
module HalbKugel(radius=30){
    difference(){ 
       HohlKugel(radius=radius);
       translate([-radius,-2*radius,-radius])
        cube(2*radius+2,radius+2,2*radius+2);
       }
}
 
module HohlKugel(radius=30){
        difference(){ 
            sphere(r=radius);
            sphere(r=radius-1);
        }
}
