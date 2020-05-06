// Rain-Barrel cap for side Hole

h1=8;
d1=43;
wallThickness=2.8;
$fn=84;

translate([70,0,0]) Part1();
translate([0,0,0]) Part2();


module Part1(){    
    difference(){
        union(){
            // Deckel
            cylinder(d=d1+10,h=h1);

            // Fuellung Loch
            translate([0,0,h1])
                cylinder(d=d1,h=wallThickness);
        }
        
        translate([0,0,4])
            cylinder(d=5.8,h=14);
}
}

module Part2(){    
    difference(){
        // Deckel
        cylinder(d=d1+10,h=h1);

        // Fuellung Loch
        translate([0,0,h1-2])
            cylinder(d=d1+.5,h=22);
        
        
        translate([0,0,-.1])
            cylinder(d=6.2,h=14);
    }
}
