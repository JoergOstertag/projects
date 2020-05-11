// 200V ==> 5V Power supply module 
use <Ruler.scad>;
use <Pin.scad>;
use <LochrasterPlatine.scad>;

cubeDimension=[34.3,19.9,14.9];

// ------------- Main -------------
Rulers();
translate() TSP05();
 translate([0,50,0]) TSP05mitPlatine();

// ------------- Modules -------------
 
module TSP05mitPlatine(){
        platinenAbmessung=[cubeDimension[0],cubeDimension[1],0]
                         +[0,0,1.5]
                         +[20,2,0];
        translate([10,0,platinenAbmessung[2]])
            TSP05();
        translate([-1,-2,0])
            LochrasterPlatine(abmessungen=platinenAbmessung);
}


module TSP05(){
    cube(cubeDimension);

    // Pins
    mirror([0,0,-9]){
        translate()
        translate([3.1,2.6,0]) Pin(height=6.0,withBase=false);
        translate([3.1,17.9,0]) Pin(height=6.0,withBase=false);
        translate([31.4,7.5,0]) Pin(height=6.0,withBase=false);
        translate([31.4,12.7,0]) Pin(height=6.0,withBase=false);
    }
    
    color("white")
        translate([5.8,0.4,cubeDimension[2]+.1]){
            translate([0,13.5,0]) text(text="TENSTAR ROBOT",size=2.1);
            translate([0,11.7,0]) text(text="-------------------------",size=2.1);
            translate([0,9.7,0]) text(text="INPUT 110-24V",size=2.1);
            translate([0,6.7,0]) text(text="50-60Hz",size=2.1);
            translate([0,3.7,0]) text(text="PUTPUT: 5VDC/3W",size=2.1);
            translate([0,0.7,0]) text(text="P/N TSP-05",size=2.1);

        }
}