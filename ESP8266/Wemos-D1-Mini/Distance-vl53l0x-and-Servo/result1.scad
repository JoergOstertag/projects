

// ===========================================================
// Distance Sensor
// ===========================================================
segment(az=10,	el=10,	dist=591);// el=80, az= 80
segment(az=0,	el=10,	dist=596);// el=80, az= 90
segment(az=-10,	el=10,	dist=600);// el=80, az= 100
segment(az=-20,	el=10,	dist=586);// el=80, az= 110
segment(az=-30,	el=10,	dist=423);// el=80, az= 120
segment(az=-40,	el=10,	dist=314);// el=80, az= 130
segment(az=-50,	el=10,	dist=254);// el=80, az= 140
segment(az=-60,	el=10,	dist=230);// el=80, az= 150
segment(az=-70,	el=10,	dist=216);// el=80, az= 160
segment(az=-80,	el=10,	dist=206);// el=80, az= 170
segment(az=-90,	el=10,	dist=204);// el=80, az= 180
segment(az=-100,	el=10,	dist=204);// el=80, az= 190
segment(az=10,	el=0,	dist=586);// el=90, az= 80
segment(az=0,	el=0,	dist=423);// el=90, az= 90
segment(az=-10,	el=0,	dist=314);// el=90, az= 100
segment(az=-20,	el=0,	dist=254);// el=90, az= 110
segment(az=-30,	el=0,	dist=230);// el=90, az= 120
segment(az=-40,	el=0,	dist=216);// el=90, az= 130
segment(az=-50,	el=0,	dist=206);// el=90, az= 140
segment(az=-60,	el=0,	dist=204);// el=90, az= 150
segment(az=-70,	el=0,	dist=204);// el=90, az= 160
segment(az=-80,	el=0,	dist=195);// el=90, az= 170
segment(az=-90,	el=0,	dist=190);// el=90, az= 180
segment(az=-100,	el=0,	dist=188);// el=90, az= 190
segment(az=10,	el=-10,	dist=254);// el=100, az= 80
segment(az=0,	el=-10,	dist=230);// el=100, az= 90
segment(az=-10,	el=-10,	dist=216);// el=100, az= 100
segment(az=-20,	el=-10,	dist=206);// el=100, az= 110
segment(az=-30,	el=-10,	dist=204);// el=100, az= 120
segment(az=-40,	el=-10,	dist=204);// el=100, az= 130
segment(az=-50,	el=-10,	dist=195);// el=100, az= 140
segment(az=-60,	el=-10,	dist=190);// el=100, az= 150
segment(az=-70,	el=-10,	dist=188);// el=100, az= 160
segment(az=-80,	el=-10,	dist=196);// el=100, az= 170
segment(az=-90,	el=-10,	dist=187);// el=100, az= 180
segment(az=-100,	el=-10,	dist=185);// el=100, az= 190
segment(az=10,	el=-20,	dist=206);// el=110, az= 80
segment(az=0,	el=-20,	dist=204);// el=110, az= 90
segment(az=-10,	el=-20,	dist=204);// el=110, az= 100
segment(az=-20,	el=-20,	dist=195);// el=110, az= 110
segment(az=-30,	el=-20,	dist=190);// el=110, az= 120
segment(az=-40,	el=-20,	dist=188);// el=110, az= 130
segment(az=-50,	el=-20,	dist=196);// el=110, az= 140
segment(az=-60,	el=-20,	dist=187);// el=110, az= 150
segment(az=-70,	el=-20,	dist=185);// el=110, az= 160
segment(az=-80,	el=-20,	dist=197);// el=110, az= 170
segment(az=-90,	el=-20,	dist=191);// el=110, az= 180
segment(az=-100,	el=-20,	dist=191);// el=110, az= 190



module segment(az=0,el=0,dist=20){
  if ( dist > 0 && dist < 800 ) {
    fov=20;
    tanFactor=tan(fov);
    deltaDist= .1;
    dist1= dist-deltaDist;

      rotate( [0,el,az] )
        rotate( [0,-90,0] )
          translate([0,0,dist1])
            cylinder( d1= tanFactor*dist1,
                      d2= tanFactor*dist,
                       h= deltaDist );
    }
}


