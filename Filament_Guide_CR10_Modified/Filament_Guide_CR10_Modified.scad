// Filament Guide for CR 10

hoehe=25;
ueberstandMotor=12;
hoeheOberePlatte=6;

sensorPlatine=[20,20,2];
sensorPlug=[10,7,6];
sensorSwitch=[12.6,6.1,5.8];

// ============================================================================== 
// Test Code
// curved_pipe(h = 122, curve_angle = 222, curve_radius = 55);
// oldVersion();

//translate([30,20,0])
//    Sensor();
    

// translate([0,40,0])        Sensor(additionForCutout=0);

// translate([30,40,0])        Sensor(additionForCutout=1);
    
translate([90,40,10])    rotate([180,0,180])        SensorCutout();
    
// ============================================================================== 

// FilemantGuideNew();

// ============================================================================== 
module  SensorCutout(additionForCutout=0){
    difference(){
        cube([30,32,7]);
        translate(-.01*[1,1,1]+[5,5,-1.3])
            Sensor(additionForCutout=1);
    }
}

module  Sensor(){
    
    // Sensor PCB with mounding holes
    difference(){
        cube(sensorPlatine);
        $fn=15;
        distRand=2.4;
        for (x=[distRand,sensorPlatine[0]-distRand])
            translate([x,distRand,-.01])
                cylinder(d=2.6,h=4);
    }
    
    // Power Plug
    translate([sensorPlatine[0]/2-sensorPlug[0]/2,-2,sensorPlatine[2]-.01]){
        color("white")
            cube(sensorPlug);

        // Pins below board
        $fn=15;
        for( i=[0:2])
            translate([i*2.5+1.5,5.05,-4])
                cylinder(d=1,h=1.9);
    }
    
    // Sensor switch
    union(){
        translate([ sensorPlatine[0]/2-sensorPlug[0]/2,
                    sensorPlatine[1]-sensorSwitch[1]+2,
                    sensorPlatine[2]-.01]){
            color("black")
                        cube(sensorSwitch);

            // Wires
            wiresHeight=3;
            for(x=[3,6,9])
                translate([x,-3,0])
                    color("silver"){
                        cube([1,1,wiresHeight]);
                        translate([0,0,-3])cube([1,1,3]);
                        translate([0,0,wiresHeight])cube([1,5,1]);
            }

            // Screws
            $fn=15;
            for(x=[0,6.5])
                translate([2.7+x,1,sensorSwitch[2]-.01])
                    color("silver")
                        cylinder(d=2.9,h=1.1);

            // Moving part
            translate([ 0, 6,1])
                    rotate([0,0,12])
                        color("silver")
                            cube([13.5,.3,4.0]);


        }
    }
    

    // For Cutout    
    if (additionForCutout){
        
        // cover middle part
        translate([3.5,5-.1,sensorPlatine[2]-.01])
            cube([15,sensorPlatine[1]-5+.2,sensorSwitch[2]+.2]);
        
        // room for moving part of switch
        translate([4.8,sensorPlatine[1]+2-.01,sensorPlatine[2]+.9])
            cube([sensorSwitch[0]+1.8,3.4,4.2]);
        
    
        // room for Filament
        $fn=20;
        translate([7.3,sensorPlatine[1]+4.1,sensorPlatine[2]+3])
            rotate([0,90,0]){
                cylinder(d=4.5,h=12);
                translate([0,0,11.99])cylinder(d1=4.5,d2=2,h=3);
            }

        // simulated Filament
        translate([3.3,sensorPlatine[1]+4.1,sensorPlatine[2]+3])
            rotate([0,90,0])
                color("orange")
                    cylinder(d=1.75,h=20);

        // space for wires to plug
        translate([sensorPlatine[0]/2-sensorPlug[0]/2+.5,-10,sensorPlatine[2]-.01+.5])
            cube([9,10,5]);

        // Pins below board (Plug)
        translate([5,2,-2])
            cube([8,4,3]);

        // Pins below board (Switch)
        translate([4,10,-2])
            cube([12,5,3]);

    }
    
    adjustmentFrame2=0;
    if (adjustmentFrame2){
        color("blue")
            translate([0,-1.7,0]){
                cube([.1,23.6,10.3]);
                cube([20.1,23.6,.1]);
        }
    }
        
}


// ==============================================================================
module FilemantGuideNew(){
    difference(){
        union(){    
            difference(){
                union(){
                    translate([11+5,-10,0])
                       cube([63,25,hoehe]);
                    // Oberer Platte  durch den die Röhre geht
                    translate([-22,-10,hoehe-hoeheOberePlatte])
                        cube([101,25,hoeheOberePlatte]);
                    // Hintere Stabilierung    
                    translate([-18,-10,0])
                        cube([37,11,hoehe]);
                    translate([-31,-10,0])
                        cube([25,40,hoehe]);

                    // Basis platte für Bohrlöcher
                    translate([5,0,0])
                        cube([85,15,3.5]);
                }
                
                // Montage Bohrloecher
                $fn=15;
                distanceHoles=71.4;
                    translate([11.8,9,0])
                    for (x=[0,distanceHoles]){
                        translate([x,0,-.01])
                            cylinder(d=6,h=5);
                        translate([x,0,2])
                            cylinder(d=8.4,h=5);
                    }
                
                // Inner cutout space
                translate([20,-7,-0.1])
                        cube([55,46,22]);

                myCurvedPipe(filled=1);
           }

           
            myCurvedPipe(filled=0);
        }

        // Sensor Cutout
        translate([-31,10,16])
            rotate([0,0,-90])
                Sensor(additionForCutout=1);


        }   
}
module myCurvedPipe(filled=0){
    color("red") 
    translate([-06,-12,21])
        rotate([0,-45,0])
    translate([-40,0,0])
    curvedPipeHollow(r=40,d1=4,d2=8,angle=90,filled=filled);

}


module curvedPipeHollow(r=40,d1=3,d2=5,angle=90,filled=0){
    $fn=30;

    for (rotAngle=[0:40/r:angle]){
        rotate([0,0,rotAngle])
        translate([r,0,0])
        rotate([90,0,0])
        difference(){
            translate([0,0,0    ]) cylinder(d=d2,h=1); 
            if ( ! filled)   
            translate([0,0,-0.01]) cylinder(d=d1,h=1.02);
        }
    }   
}

/*
module oldVersion(){
    translate([90,112,-31])
        rotate([0,-90,90])
            import("filament_guide_2.STL");
}

*/