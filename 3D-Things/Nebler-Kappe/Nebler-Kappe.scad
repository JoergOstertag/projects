debug=0;

// Das Ergebnis ist gleich liegend
liegend=1;


$fn=50;

durchmesserKappe=117;
hoeheKappe=25.5;
rand=13;
dicke=3;

// ==================================================
HalbKugel(radius=durchmesserKappe/2+dicke,hoehe=hoeheKappe,dicke=dicke);
Ring(radiusInnen=durchmesserKappe/2,dicke=3,rand=rand);

// ==================================================

module HalbKugel(radius=10,hoehe=10,dicke=3){
    radiusKugel=radius;
    radiusKugel= (hoehe*hoehe + radius*radius) / ( 2 * hoehe );
    translate([0,0,-radiusKugel+hoehe])
    difference()
//    union()
    { 
       HohlKugel(radius=radiusKugel,dicke=dicke);
       translate([-radiusKugel-.1,-radiusKugel-.1,-radiusKugel])
            cube([radiusKugel*2+.2,radiusKugel*2+.2,radiusKugel*2-hoehe]);
       }
}
 

module HohlKugel(radius=30,dicke=3){
        difference(){ 
            sphere(r=radius);
            sphere(r=radius-dicke);
        }
}


module Ring(radiusInnen=90,dicke=3,rand=10){
        difference(){ 
            cylinder(r=radiusInnen+rand,h=dicke,center=false);
            translate([0,0,-.1])
                cylinder(r=radiusInnen,h=dicke+.2,center=false);
        }
}