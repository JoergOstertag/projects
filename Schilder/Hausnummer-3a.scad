/**
 * Hausnummer 3a
 */

numberHeight=70;
numberWidth=numberHeight*2/3;
letterHeight=numberHeight*3/5;

color("black")
    linear_extrude(height = 3) 
{
    translate([0,0,0]) text("3", ,size=numberHeight,halign="left");
    translate([numberWidth+3,0,0]) text("a", ,size=letterHeight,halign="left");
}