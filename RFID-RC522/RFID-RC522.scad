$fn=90;
pcbBoard=[40,60,1.5];

// RFID_RC522();
translate([50,0,0]) BasePlate();


module BasePlate(){
    color("white"){
        cube(pcbBoard);
        translate([0,0,pcbBoard[2]]) MountingHoles();
    }
}

module RFID_RC522(){
    difference(){
        color("blue")
            cube(pcbBoard);
        MountingHoles();
    }
    
    translate(pcbBoard-[5.1,12.1,0])
        Quartz();
  
    translate(pcbBoard-[29.3,2.1,1.5])
        PcbHoles();
  
    translate(pcbBoard-[29.3,25.4,0])
        for( x=[0:3:17.2])
            translate([x,0,0])
                Chip();  
}
module MountingHoles(){
        // mounting Holes
        for( x=[-12.6,12.6] ) {
            translate([pcbBoard[0]/2+x,7.3,-.01])
                cylinder(d=2.8,h=1.5+.02);
        }

        // mounting Holes
        dist2=34;
        for( x=[-dist2/2,dist2/2] ) {
            translate([pcbBoard[0]/2+x,44.9,-.01])
                cylinder(d=2.8,h=1.5+.02);
        }
    }


module Quartz(){
    sizeY=10.7;
//    d=3.4;
    d=4.2;
    h=3.5;
    color("silver")
        hull(){
            translate([d/2,0,0])
            for( y=[d/2,sizeY-d] ) {
                translate([0,y,0])
                    cylinder(d=d,h=3.5);
            }
        }
}

module PcbHoles(){
    sizeX=18.2;
//    d=3.4;
    d=.5;
    h=3.5;
    color("silver")
        translate([d/2,0,0])
            for( x=[d/2:2.3:sizeX] ) {
                translate([x,0,-.01])
                    cylinder(d=d,h=1.5+.02);
            }
 
}

module Chip(){
    cube([1.9,1.2,0.8]);
}