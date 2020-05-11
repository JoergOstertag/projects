// Batterie Library

$fn=25;
a=exp(2,2);
PRINT(a);

translate([20,20,0]) ContactFeather();
translate([20,0,0]) Batery_AAA();
translate([40,0,0]) Batery_18650();

module Batery_18650(){
    Battery(dOuter=18.2,dPlusCap=6.1,dMinusCap=12.2,hOuter=68,hWithPlusCap=68.7);
}

module Batery_AAA(){
    Battery(dOuter=13.8,dPlusCap=4.8,dMinusCap=9.2,hOuter=49,hWithPlusCap=50.4);
}


/* 
 *                  x      +-----------------------+
 *         x        |     ++                       |
 *         |        |     |                        +--+     x
 *     dMinusCap   dOuter |                           |     | hInner
 *         |        |     |                        +--+     x
 *         x        |     ++                       |
 *                  x      +-----------------------+ 
 *                                                     
 *                         x------ hOuter ---------x
 *                         x------ hWithPlusCap ------x
 */
module Battery(dOuter=13.8,dPlusCap=4.8,dMinusCap=9.2,hOuter=49,hWithPlusCap=50.4){
    color("red")
        cylinder(d=dOuter,h=hOuter);
    color("silver")
        cylinder(d=dPlusCap,h=hWithPlusCap);
    color("silver")
        cylinder(d=dMinusCap,h=1);
}

module BatteryHolder(){

}


/**
 h= height of Feather
 d1= diameter at lower end (larger one)
 d2= diameter at top end (smaller one)
 wireDiameter=0.4 diameter of the copper wire
 turns=4 Number of torns (Windungen)
*/
module ContactFeather(h=11.8,d1=8.8,d2=6.9,wireDiameter=0.4,turns=4){
    featherScale=[1,1]*(d2/d1);
    
    color("silver"){
        linear_extrude(height=h, 
                        slices=turns*32,
                        twist=turns*360,
                        scale=featherScale)
                            translate([d1,0,0])
                                circle(d=wireDiameter);

        linear_extrude(height=.1, 
                        slices=turns*32,
                        twist=1*360)
                            translate([d1,0,0])
                                circle(d=wireDiameter);


        translate([0,0,h])
        linear_extrude(height=.1, 
                        slices=turns*32,
                        twist=1*360)
                            translate([d2,0,0])
                                circle(d=wireDiameter);

    
  }
}