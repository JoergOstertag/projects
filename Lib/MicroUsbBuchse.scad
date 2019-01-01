//

use <Ruler.scad>;

buchseX=5.5;
buchseAussenY1=7.7;
buchseAussenY2=5.9;
buchseAussenYd=(buchseAussenY1-buchseAussenY2)/2;
buchseInnenY1=6.7;
buchseInnenY2=5.1;
buchseInnenYd=(buchseInnenY1-buchseInnenY2)/2;
buchseZ=2.8;
wandStarke=0.4;

dimensionsMicroUsbStecker=[11,20,6];

// -------------------  Examples ------------------- 

MicroUsbBuchse();
MicroUsbSteckerSpace();
translate([0,-4,0]) Rulers();

// ------------------- Modules ------------------- 
module MicroUsbSteckerSpace(){
    translate([buchseX/2-dimensionsMicroUsbStecker[0]/2,0,-buchseZ/2])
        cube(dimensionsMicroUsbStecker);
}

module MicroUsbBuchse(){

    color("silver")
        rotate([90,0,0])
           linear_extrude(height = buchseX, center = false, convexity = 10, twist = 0)
            difference(){
                polygon(points=[
                         [buchseAussenYd,0],
                         [buchseAussenY2+buchseAussenYd,0],
                         [buchseAussenY1,buchseZ],
                         [0,buchseZ],
                        ],
                        paths=[[0,1,2,3],[4,5,6,7]],
                        convexity=10
                        );
                 translate([wandStarke,wandStarke,0])
                    polygon(points=[
                         [buchseAussenYd,0],
                         [buchseAussenY2+buchseAussenYd-2*wandStarke,0],
                         [buchseAussenY1-2*wandStarke,buchseZ-2*wandStarke],
                         [0,buchseZ-2*wandStarke],
                        ],
                        paths=[[0,1,2,3],[4,5,6,7]],
                        convexity=10
                        );
        }
 
}

