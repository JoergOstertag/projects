// RUler

translate([10,10,10]){
Ruler();
}

module Rulers(length=200){
    RulerX();
    RulerY();
    RulerZ();
}
module RulerX(length=200){
    Ruler(length=length);
}

module RulerY(length=200){
    rotate([0,0,90])
        Ruler(length=length);
}

module RulerZ(length=200){
    rotate([0,-90,0])
        Ruler(length=length);
}

module Ruler(length=200){
    for (cm=[0:1:length/10]){
        translate([10*cm,0,0]){
            color("black")
                translate([.1,.4,0])
                    scale([1,1,.05])
                        text(text = str(cm),size=1);

        // Striche
        color("blue"){
            // cm Balken
            cube([.1,2,.1]);

            // untere Linie
            cube([10,.2,.1]);
            
            // mm Balken
            for (mm=[1:1:9]){
                translate([mm,0,0])
                    cube([.1,.6,.1]);
            }

            // 5mm Balken
            translate([5,0,0])
                    cube([.1,1,.1]);
            }
        }
    }
    
}
