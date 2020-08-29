ledD=7.8;
ledH=3.9;
led2D=10.9;
led2H=22.1;


//ledCutout();
LedInCube();

module LedInCube(){
    difference(){
        X=20;
        Y=20;
        Z=20;
        translate(-.5*[X,Y,0])
            cube([20,20,20]);
        ledCutout();
    }
}

module ledCutout(){
    $fn=22;
    
    translate([0,0,ledH+ledD/2]){
        cylinder(d=led2D,led2H);
    
        for (winkel=[0:90:360]){
            rotate([0,0,winkel])
                translate([led2D/2-.3,-0.6,0])
                    cube([1.2,2.4,20.6]);
        }
    }
    
    translate([0,0,ledD/2]){
        cylinder(d=ledD,ledH);
        sphere(d=ledD);
    }
}
