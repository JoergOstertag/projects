durchmesserAussen=7.5;
hoehe=4;

durchmesserInnen=2;
hoeheInnen=3.0;

// das ist derjenige, der den zusätzlichen Abstand bestimmt
durchmesserOben=5.0;
hoeheOben=3.5;
druckerToleranz=0.6;

$fn=20;

// 
translate([0,0,hoehe+hoeheOben])
    mirror([0,0,90]) // Damit das loch nach oben geht
        HeizungsStiftVerlaengerungsAdapter();



// ------------------------------------------    
module HeizungsStiftVerlaengerungsAdapter(){
    difference(){
        cylinder(d=durchmesserAussen,h=hoehe);
        translate([0,0,-1])
        cylinder(d=durchmesserInnen+2*druckerToleranz,h=hoeheInnen+1);
    }

    // Oberer cylinder
    translate([0,0,hoehe])
        cylinder(d=durchmesserOben,h=hoeheOben);
}