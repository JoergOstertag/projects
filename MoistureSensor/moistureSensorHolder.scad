use <../lib/Esp12.scad>;

moistureSensor=[21.8,97.0,0.9];

MoistureHolder();

// translate([40,0,0])    MoistureSensor();
// translate([70,0,0])    WemosD1Mini();


module MoistureHolder(){
    difference(){
        borderSize=2;
        borderSize2=.5;
        sensorWidth=moistureSensor[0];

        // Outer CUbe border
        cube([sensorWidth+borderSize*2,25,5]);

        // Inner cut Out
        cutOutWidth=sensorWidth-2*borderSize2;
        translate([borderSize+borderSize2,-.01,1.5])
            cube([cutOutWidth,19,8]);

        // Cut out Moisture Sensor
        translate([borderSize,-.01,5-2])
//            scale(1.03*[1,1,1])
                MoistureSensor(hull=1);
    }
}

module MoistureSensor(hull=0){
    hullAdd=hull*.2;
    difference(){
            cube(moistureSensor+hullAdd*[1,1,1]);
        
        // Spitze
        translate([moistureSensor[0]/2,moistureSensor[1],2]){
            for ( i=[45:180+45] )
                rotate([180,0,i])
                    cube([20,20,5]);
        }
        // Dellen an der Seite
        for ( x=[0,1] )
            for (y=[0:.5:2.4-(hull*1)] )
                translate([moistureSensor[0]*x,20.6+y,0])
                    cylinder(h=2,r=1.4-(hull*1),center=true);
        
    }
    
    // Stecker
    translate([5,-4.7,moistureSensor[2]])
        color("white")
            scale((1+hull*.1)*[1,1,1])
                cube([10,9.3,5.6]);
    
    // ICs
    translate([2.4,9,moistureSensor[2]])
        color("silver")
            cube([17.5,12.3,2.4]);
}