// LochrasterPlatine

$fn=18;


// FR2 Lochraster-Europlatine einseitig
platinenBohrung=1.0; //  mm 39 x 61,
platinenRaster=2.51*[1,1,0];
platinenAbmessungen=[160,100,1.5];


translate([00,00,0]) LochrasterPlatine(abmessungen=[22,12,1.5]);
translate([0,20,0]) LochrasterPlatine(abmessungen=[40,10,1.5]);
//translate([0,40,0]) LochrasterPlatine();

module LochrasterPlatine(abmessungen=platinenAbmessungen,raster=platinenRaster,bohrung=platinenBohrung){
    difference(){
        union(){
            // Grundplatte
            color("brown")
                cube(abmessungen);
            
                        
            // Lötaugen
            for(x=[raster[0]:raster[0]:abmessungen[0]]){
                for(y=[raster[1]:raster[1]:abmessungen[1]]){
                    translate([x,y,abmessungen[2]-.1+.01]){
                        color("silver")
                            cylinder(d=bohrung*2,h=.1);
                        }
                    }
                }
        }
                
        Bohrungen(raster=raster,abmessungen=abmessungen,bohrung=bohrung);
    }
            
}


module Bohrungen(raster,abmessungen,bohrung){
        for(x=[raster[0]:raster[0]:abmessungen[0]]){
            for(y=[raster[1]:raster[1]:abmessungen[1]]){
                translate([x,y,-.1]){
                    cylinder(d=bohrung,h=abmessungen[2]+.2);
                }
            }
        }
    }
