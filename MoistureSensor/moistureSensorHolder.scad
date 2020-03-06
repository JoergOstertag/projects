
moistureSensor=[21.8,97.0,0.8];

// translate([40,0,0])    MoistureSensor();
 
MoistureHolder();

module MoistureHolder(){
    difference(){
        borderSize=2;
        borderSize2=.5;
        sensorWidth=moistureSensor[0];
        
        cube([sensorWidth+borderSize*2,25,5]);

        cutOutWidth=sensorWidth-2*borderSize2;
        translate([borderSize+borderSize2,-.01,2])
            cube([cutOutWidth,19,4]);

        // Cut out Moisture Sensor
        translate([borderSize,0,5-2])
            scale([1.01,1.01,1.01])
                MoistureSensor();
    }
}

module MoistureSensor(){
    difference(){
        cube(moistureSensor);
        
        // Spitze
        translate([moistureSensor[0]/2,moistureSensor[1],2]){
            for ( i=[45:180+45] )
                rotate([180,0,i])
                    cube([20,20,5]);
        }
        // Dellen an der Seite
        for ( x=[0,1] )
            for (y=[0:.5:2.4] )
                translate([moistureSensor[0]*x,20.6+y,0])
                    cylinder(h=2,r=1.4,center=true);
        
    }
    
    // Stecker
    translate([5,-4.7,moistureSensor[2]])
        color("white")
            cube([10,9.3,5.6]);
    
    // ICs
    translate([2.4,9,moistureSensor[2]])
        color("silver")
            cube([17.5,12.3,2.4]);
    
    //difference()        union(){
    // translate(offsetLevel1-printerWobbleXYZ-overlapZ)
}