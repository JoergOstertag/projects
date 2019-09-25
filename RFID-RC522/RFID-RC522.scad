$fn=90;
pcbBoard=[40,60,1.5];

// RFID_RC522();
// translate([50,0,0]) BasePlate();
translate([-60,0,0]) Aussparung();
//translate([10,90,0]) NfcSymbol();

// NfcSymbol(d=10,height=1);

module BasePlate(){
    color("white"){
        cube(pcbBoard);
        translate([0,0,pcbBoard[2]]) 
            MountingHoles(df=.9);
    }
}

module Aussparung(){
    wallThickness=4;
    baseThickness=2;
    difference(){
        cube(pcbBoard+wallThickness*[2,2,0]+baseThickness*[0,0,1]);

        translate(wallThickness*[1,1,+.01]+baseThickness*[0,0,1])
            PcbBoard(df=.9);

    // NFC Symbol
    translate([pcbBoard[0]/2+wallThickness,20,.3]) 
        rotate([180,0,0])
            NfcSymbol(d=18,height=.31);
    }
}
module PcbBoard(df=1){
    difference(){
        color("blue")
            cube(pcbBoard);
        MountingHoles(df=df);
    }
}

module RFID_RC522(){
    PcbBoard();

    // NFC Symbol
    translate([pcbBoard[0]/2,20,pcbBoard[2]]) 
        color("white")
        NfcSymbol(d=18,height=.2);

    translate(pcbBoard-[5.1,12.1,0])
        Quartz();
  
    translate(pcbBoard-[29.3,2.1,1.5])
        PcbHoles();
  
    translate(pcbBoard-[29.3,25.4,0])
        for( x=[0:3:17.2])
            translate([x,0,0])
                Chip();  
}
module MountingHoles(df=1){
    
    // mounting Holes
    for( x=[-12.6,12.6] ) {
        translate([pcbBoard[0]/2+x,7.3,-.01])
            cylinder(d=2.8*df,h=1.5+.02);
    }

    // mounting Holes
    dist2=34;
    for( x=[-dist2/2,dist2/2] ) {
        translate([pcbBoard[0]/2+x,44.9,-.01])
            cylinder(d=2.8*df,h=1.5+.02);
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


module NfcSymbol(d=10, height=.1){

    cylinder(d=.1*d,h=height);

    difference(){
        for ( di=[0 : d*.2 : d] ) {
            difference(){
                cylinder(d=di+(d*.1),h=height);
                translate([0,0,-.1])
                    cylinder(d=di,h=height+.2);
            }
        }
        
        for ( rot=[45,-135] )
            rotate([0,0,rot])
                translate([0,0,-.1])
                   cube([d*.6,d*.6,height+.2]);
    }

    // Text NFC
    translate([d*-.27,d*0.35,0])
            linear_extrude(height = height,width=0) 
                text("NFC", ,size=d*.2,halign="left"); 

    // Text RFID
    translate([d*-.32,-d*0.55,0])
            linear_extrude(height = height,width=0) 
                text("RFID", ,size=d*.2,halign="left"); 
    }
