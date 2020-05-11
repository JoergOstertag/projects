wallThickness=4;

level0r=80;
level0h=4;

level1Z0=level0h;
level1r=40;
level1h=15;
level1h0=15-4;
level1h1=15;

level2Z0=level1Z0+level1h;
level2r=10;
level2h=22;

level3Z0=level2Z0+level2h;
level3r=100;
level3h=25;

$fn=60;

// Main
Level01();
Level2();
Level3();



// Modules
module Level01(){
    difference(){
        union(){
            Level0();
            Level1();
        }
        
        // Angular cut off
        rotate([0,0,55]) translate([-100,level2r,-0.01]) cube([200,100,40]);
        rotate([0,0,-55]) translate([-100,+level2r,-0.01]) cube([200,100,40]);

        // Side cut off
        for(x=[-95,95])
            translate([x,+level2r,-0.01]) cube([100,200,40],center=true);
    }
}
    
// Level 0
module Level0(){
color("green")
    translate([0,0,0]){
        difference(){
            cylinder(r=level0r,h=level0h);
            translate([0,0,-.01])        cylinder(r=level1r-wallThickness,h=level0h+.02);
        }

        // Teeth
        for(count=[-2:2]){
            rotate([0,0,180+count*10])
                translate([0,level0r,0])
                  level0Tooth();
        }
    }
}
module level0Tooth(){
    difference(){
        translate([0,-4,0])
            cube([8,14,level0h]);
    
        for(lr=[1,-1])
            translate([ lr*8,4,-.01]) rotate([0,0,lr*25]) cube([8,22,level0h+.02]);

       translate([-8,9,-.01])    cube([22,12,level0h+.02]);
    }
    translate([4.5,8.5,-.01])    cylinder(d=2.7,h=level0h+.02);
}




// Level 1
module Level1(){
    color("yellow")
    translate([0,0,level1Z0]){
        difference(){
            cylinder(r1=level1r,r2=level1r-2,h=level1h);
            translate([0,0,-.01])    cylinder(r1=level1r-4,r2=level1r-2-4,h=level1h0+0.02);
            cylinder(r=level2r-4,h=level2h);

            translate([0,-level1r+4,4])  cube([5,8,8],center=true);
        }

        // Inner Pin /  hook
        translate([0,-level1r+9,7]){
            cube([2,3,10],center=true);
            translate([0,-2,-4])
                cube([2,3,2],center=true);
        }
        
        // Outer Pins
        for ( x=[-12,12]){
            translate([x,-level1r+6,2])
                Level1Pin();
        }
    }

    module Level1Pin(){
        pinX=8;
        pinY=25;
        pinZ=4;
        rotate([0,0,180]) 
           translate([-pinX/2,0,pinZ/2]){
                difference(){
                    cube([pinX,pinY,pinZ]);
                    translate([-1,-1,pinZ/2])
                        for (m=[0,1])
                            mirror([0,0,m]) 
                                mirror([0,1,0]) 
                                  translate([0,-pinY,])
                                        rotate([20,0,0])
                                            translate([0,-10,0])
                                                cube([pinX+2,pinY+10,2*pinZ]);
            }
        }
    }

}


// Level 2
module Level2(){
    color("blue")
    translate([0,0,level2Z0]){
        difference(){
            cylinder(r=level2r,h=level2h);
            translate([0,0,-.01])    cylinder(r=level2r-4,h=level2h0+0.02);
        }
    }
}




// Level 3
module Level3(){
    color("orange")
    translate([0,-level2r-5,level3Z0]){
        difference(){
            translate([0,level3r,0]) // Make the edge of the circle be at y=0
                difference(){
                    cylinder(r=level3r,h=level3h);
//                    translate([0,0,-.01])    cylinder(r=level3r-4,h=level3h0+0.02);
                }

           // Front holes
           for ( x=[-25,25]){
            translate([x,-5,12])
               rotate([270,0,0]){
                cylinder(r=3,h=50);
                cylinder(r=6,h=10);
               }
           }

            // Small cut off
            translate([-200,25,4])
                cube([400,100,40]);

            // Big cut off
            translate([-200,50,-0.01])
                cube([400,400,40]);
        }
    }
}