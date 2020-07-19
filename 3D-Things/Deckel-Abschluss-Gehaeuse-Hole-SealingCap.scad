// Deckel um bei einem Gehaeuse die Kabellöcher zu schliessen


// dInnen=40.3;
// wallThickness=2.8;

// Obi Wasserfester Strom kasten
dInnen=25.2;
dSchraubDurchfuehrung=15.7 + .2;
scheibenOverlap=5.0;
wallThickness=1.7 + .4;

$fn=64;

translate([0,0,0]) Part1(hPlaettchenStaerke=2,dInnen=dInnen);
translate([dInnen+scheibenOverlap+5,0,0]) Part2(hPlaettchenStaerke=3,dInnen=dInnen);


module Part1(
    hPlaettchenStaerke=3,
    bohrung=dSchraubDurchfuehrung,
    dInnen=dKlein,
    ){    
    difference(){
        union(){
            // Deckel
            cylinder(d=dInnen+scheibenOverlap,h=hPlaettchenStaerke);

            // Fuellung Loch
            translate([0,0,hPlaettchenStaerke])
                cylinder(d=dInnen-.1,h=wallThickness);
        }
        
        translate([0,0,-.10])
         cylinder(d=bohrung+.1,h=hPlaettchenStaerke+wallThickness+2);
}
}

module Part2(
    hPlaettchenStaerke=3,
    dInnen=dKlein,
    bohrung=dSchraubDurchfuehrung,
    ){
    difference(){
        // Deckel
        cylinder(d=dInnen+scheibenOverlap,h=hPlaettchenStaerke);

        // Fuellung Loch
        translate([0,0,hPlaettchenStaerke-2])
            cylinder(d=dInnen+.5,h=22);
        
        
        translate([0,0,-.1])
            cylinder(d=dSchraubDurchfuehrung,h=14);
    }
}
