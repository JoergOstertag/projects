druckerUngenauigkeit=.5;
servoBreite=29.1 + druckerUngenauigkeit;
servoTiefe=14.0 + 1+ druckerUngenauigkeit;
servoHoeheBisAufnahme=18.1;
servoAufnahmeBreite=5.2;
lochDurchmesser=2.5;
aufnahmeDicke=2.0;
seitenwandDicke=2.0;
grundPlattenHoehe=2.0;
AnschlussUeberBodenHoehe=4.2 ;
AnschlussHoehe=4.1 +2+ druckerUngenauigkeit;
AnschlussBreite=6.7 +1+ druckerUngenauigkeit;
RueckwandDicke=3;
RueckwandUeberHoehe=25;

servoBHalterungBefestigungBreite=9;
servoBHalterungBefestigungDicke=4;

$fn=20;

union(){
    translate([0,0,servoHoeheBisAufnahme]) {
        color("red"){
            translate([0,-servoAufnahmeBreite,0])
                servo_aufnahme();
            translate([0,servoBreite,0])
                servo_aufnahme();
        }
    }
    
    { // Seitenwaende
        translate([0,-seitenwandDicke,-grundPlattenHoehe])
            servoSeitenwand();
        translate([0,servoBreite,-grundPlattenHoehe])
            servoSeitenwand(mitAussparung=0);
    }
    
    color("cyan")
        servoGrundplatte();

    color("blue")
        translate([-RueckwandDicke,0,-grundPlattenHoehe]){
//                servoHalterungBefestigung();
        translate([0,-seitenwandDicke,-0])
                servoHalterungBefestigung();
        translate([0,servoBreite+seitenwandDicke+servoBHalterungBefestigungBreite,0])
//            mirror([0,0,0]) 
            servoHalterungBefestigung();
    }
    translate([-RueckwandDicke,-seitenwandDicke,-grundPlattenHoehe]){
        servoRueckwand();        
        servoRueckwandLang();
}
//    color("gray")        servoAussparung();

}


module        servoHalterungBefestigung(){
rotate(a=[180,-90,0]) { 
    difference(){
//    union(){
        cube([servoHoeheBisAufnahme+grundPlattenHoehe+aufnahmeDicke,servoBHalterungBefestigungBreite,  servoBHalterungBefestigungDicke], center = false);
        translate([servoHoeheBisAufnahme/2,servoBHalterungBefestigungBreite/2, servoBHalterungBefestigungDicke])
            color("cyan")
            cylinder(h = (servoBHalterungBefestigungDicke)*3, r = lochDurchmesser/2, center = true);
    }}
}

module    servoAussparung(){
        cube([servoTiefe, servoBreite, servoHoeheBisAufnahme], center = false);
    }

module    servoRueckwand(){
        cube([RueckwandDicke, servoBreite+2*seitenwandDicke, servoHoeheBisAufnahme+grundPlattenHoehe+aufnahmeDicke], center = false);
    }

module    servoRueckwandLang(){
    LangeRueckwandHoehe=RueckwandUeberHoehe+servoHoeheBisAufnahme+grundPlattenHoehe+aufnahmeDicke;
        cube([RueckwandDicke, servoBreite+2*seitenwandDicke, LangeRueckwandHoehe], center = false);

        translate([0,0,LangeRueckwandHoehe]){
        cube([RueckwandDicke+servoTiefe, servoBreite+2*seitenwandDicke, seitenwandDicke], center = false);
            //RueckwandUeberHoehe+servoHoeheBisAufnahme+grundPlattenHoehe+aufnahmeDicke
        }

    }

module    servoSeitenwand(mitAussparung=1){
        difference(){
            cube([servoTiefe, seitenwandDicke, grundPlattenHoehe+servoHoeheBisAufnahme], center = false);

    if (mitAussparung){
            schlitzBreite=1.5;
            // Aussparung Anschluss
            translate([(servoTiefe/2)-(AnschlussBreite/2),-1,AnschlussUeberBodenHoehe-druckerUngenauigkeit])
                cube([AnschlussBreite, seitenwandDicke+2, AnschlussHoehe+2*druckerUngenauigkeit], center = false);
            // Aussparung Kabel Einfädelung
            translate([(servoTiefe/2),-1,AnschlussUeberBodenHoehe])
                cube([(servoTiefe/2), seitenwandDicke+2, schlitzBreite+druckerUngenauigkeit], center = false);
            }   
        }
   }
    
module    servoGrundplatte(){
            translate([0,0,-2])  
      cube([servoTiefe,servoBreite, grundPlattenHoehe], center = false);
    }
    
module servo_aufnahme(){
    difference(){
//    union(){
        cube([servoTiefe,servoAufnahmeBreite,  aufnahmeDicke], center = false);
        translate([servoTiefe/2,servoAufnahmeBreite/2, (aufnahmeDicke/2)-1])
            color("cyan")
            cylinder(h = (aufnahmeDicke+3), r = lochDurchmesser/2, center = true);
    }
}
