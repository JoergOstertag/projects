liegend=0;

druckerUngenauigkeit = .1;
buchDicke = 26;
buchDicke = 41;
buchTiefe = 106;
buchHoehe = 175;

// Boden
bodenBreite = buchDicke - druckerUngenauigkeit;
bodenLaenge = buchTiefe-0 - druckerUngenauigkeit;
bodenDicke = 4;

// Seitenwände
seitenwandDicke = 1;
seitenwandHoehe = buchHoehe;

befestigungBreite = buchDicke; // 18;
befestigungLaenge = 5;
befestigungDicke = 2;
lochDurchmesser=3;

$fn=50;

if (liegend){
    rotate(a=[0,-90,0]) 
        Buch();
} else {
        Buch();
}

module Buch(){
        union(){
    
        // Grund platte
        color("gray")
            GrundPlatte();
    
        // obere Deck platte
        color("gray")
            translate([0,0,seitenwandHoehe-bodenDicke])
            DeckPlatte();
    
        
        // Seiten Wände
        color("red"){
                translate([0,0,0])                SeitenWand();
                translate([bodenBreite-seitenwandDicke,0,0])
                    difference(){
                         SeitenWand();
                         SeitenWandLoch();
                    }
        }
    
            translate([0,bodenLaenge,0]){
                BuchRuecken();
            }
        
        color("blue"){
        }
    
    // Befestigungsloch
        translate([bodenBreite/2 , 0 , bodenDicke])    {
                Befestigung();
            translate([0,0,seitenwandHoehe-2*bodenDicke-befestigungLaenge])
                Befestigung();
        }
    
    }
}


module BuchRuecken(){
        color("cyan")
            cube([bodenBreite, 2, seitenwandHoehe], center = false);
        translate([bodenBreite/2 , -10 , seitenwandHoehe/5*4])    
//        translate([bodenBreite/2 , 0 , -30])    
                Auge();
    
}
module Auge(){
    union(){
        radius1=32/2;
        radius2=20/2;
        radius3=10/2;
        radius4= 0; // 5/2;
        
        color("white")
            HalbKugel(radius=radius1);
        translate([0 , radius1-radius2*9/10 , 0])    
            color("blue")
                HalbKugel(radius=radius2);
if(1)
    translate([0 , radius1+radius2*1/10-radius3*9/10 , 0])    
            color("black")
                HalbKugel(radius=radius3);
    }
}

 
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




module SeitenWand(){
        cube([seitenwandDicke, bodenLaenge, seitenwandHoehe], center = false);
}

module SeitenWandLoch(){
        randOffsetX = 0; // seitenwandDicke
        randOffsetY1 = -0.1; // bodenLaenge/15;
        randOffsetY2 = 5; // bodenLaenge/15;
        randOffsetZ = 0; // seitenwandHoehe/15;
    translate([-.1+randOffsetX ,  randOffsetY1,randOffsetZ])
    cube([.2 + seitenwandDicke - (2*randOffsetX), bodenLaenge- randOffsetY1 - randOffsetY2, seitenwandHoehe- (2*randOffsetZ)], center = false);
}

module GrundPlatte(){
        cube([bodenBreite, bodenLaenge, bodenDicke ], center = false);
}
    
module DeckPlatte(){
        cube([bodenBreite, bodenLaenge, bodenDicke ], center = false);
}





module Befestigung(){
    rotate(a=[90,0,180]) 
    translate([-befestigungBreite/2,0,0])
    difference(){
    // union(){
        cube([befestigungBreite,befestigungLaenge,befestigungDicke], center = false);
        translate([befestigungBreite/2,befestigungLaenge/2, -.1])
            color("cyan")
            cylinder(h = (befestigungDicke)+.2, r = lochDurchmesser/2, center = false);
    
    }
}