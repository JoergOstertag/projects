#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min max);
use Math::Trig;

my $fov = .5;
my $neigungSensor=45;
sub writeHeader($){
    my $of = shift;
    print $of "
// ===========================================================
// 3D-Scan with Distance Sensor
// ===========================================================
fov= $fov;

// als kugel ==>1 sonst PyramidenSpitz
drawSphere=1;
neigungSensor=$neigungSensor;


// include <walls.scad>

// drawPolar();
drawKarth();

";
}

sub writeModule($){
    my $of = shift;
    
print $of "

module showMarker(x=0,y=0,z=0){
    translate([x,y,z])
	color(\"black\")
	sphere(d=5);

}

module segment(az=0, el=0, dist=20 ) {
    if ( dist > 0 ) {
       tanFactor=tan(fov);
       deltaDist= .1;
       dist1= dist-deltaDist;

       rotate( [neigungSensor,0,0] )
	rotate( [el,0,-az] )
           rotate( [-90,0,0] )
	      translate([0,0,dist1])
		if( drawSphere ){
                   color(\"blue\")
	              sphere(d=5); 
                } else {
                   cylinder( d1= tanFactor*dist1,
	                     d2= tanFactor*dist,
	                     h= deltaDist );
                }
      }
}
    ";
}


my $minZ;


sub readCsvFile($){
    my $fileName = shift;
    
    print "Import $fileName\n";

    open(my $fh, $fileName)
	or warn "Can't open $fileName: $!";

    my $values;

    $minZ   = 100000;
    
    my $count=0;
    my $line = readline $fh; # Header weg
    while ( ! eof($fh) ) {
	$count++;
	$line = readline $fh;
	$line =~ s/\s*$//;
	my ($az,$el,$dist) = split(/;/,$line);
	if ( ! defined($dist) ){
	    print " Error in line '$line'\n";
	}
	$az= $az*1;
	$el= $el*1;
	my $az1 = $az * 1.0; # + 90.0;
	my $el1 = $el * 1.11;
	
	# print "($az1,$el1,$dist)\n";
	my $azRad = $az1 * pi() / 180;
	my $elRad = $el1 * pi() / 180;
	
	my $distFloor= cos($elRad) * $dist;
	my $z = sin($elRad) * $dist;
	my $x = cos($azRad) * $distFloor;
	my $y = sin($azRad) * $distFloor;

	# Rotate 45° down for xyz
	my $d = sqrt($x*$x + $z*$z);
	my $alpha = atan($z / $x );
	$alpha += $neigungSensor;
	$x = $d * cos($alpha);
	$z = $d * sin($alpha);

	# Nachkomma Stellen reduzieren
	$x =sprintf("%6.2f",$x);
	$y =sprintf("%6.2f",$y);
	$z =sprintf("%6.2f",$z);

	# if ( $count < 20 )
	{
	    $values->{$az}->{$el}={
		dist => $dist,
		x    => $x,
		y    => $y,
		z    => $z,
		az   => $az1,
		el   => $el1,
	    };
	};
	$minZ=min($z,$minZ);
    }
    close($fh);
    return $values;
}


foreach my $fileName (@ARGV) {

    my $values = readCsvFile($fileName);

    my $baseFilename= "$fileName";
    $baseFilename =~s/\.csv//;

    # Get all possible az/el Values
    my @azValues = sort { $a <=> $b } keys %{$values};
    my %elValues;
    for my $az ( @azValues ) {
	map { $elValues{$_} = 1 } keys %{$values->{$az}};
    };
    my @elValues = sort { $a <=> $b } keys %elValues;
    #print Dumper ( \@elValues );
    # print Dumper( \@azValues );
    
    # ----------------- write scad
    my $of;

    open($of, '>', "$baseFilename.scad")
	or die "Could not open file '$baseFilename.scad' $!";
    print " Write $baseFilename.scad\n";
    writeHeader($of);

    print $of "\n";
    print $of "minZ=$minZ;\n";
    print $of "\n";
    print $of "translate([0,0,-minZ])\n";
    print $of "// drawPolar();\n";
    print $of "drawKarth();\n";
    print $of "\n";
    
    writeModule($of);

    print $of "\n";
    print $of "module drawPolar(){\n";
    for my $az ( @azValues ) {
	for my $el ( @elValues ){
	    if (! defined( $values->{$az}->{$el})){
		print "   missing $az $el\n";
	    } else {	    
	    my $dist = $values->{$az}->{$el}->{dist};
	    my $az1 = $values->{$az}->{$el}->{az};
	    my $el1 = $values->{$az}->{$el}->{el};
	    my $outLine="   segment(az=$az1,	el=$el1,	dist=$dist);\n";
	    print $of $outLine;
	}
	}
    }
    print $of "}\n";
    print $of "\n";

    
    print $of "module drawKarth(){\n";
    for my $az ( @azValues ) {
	for my $el ( @elValues ){
	    if (! defined( $values->{$az}->{$el})){
		print "   missing $az $el\n";
	    } else {	    
	    my $x = $values->{$az}->{$el}->{x};
	    my $y = $values->{$az}->{$el}->{y};
	    my $z = $values->{$az}->{$el}->{z};
	    my $outLine="   showMarker($x, $y, $z);\n";
	    print $of $outLine;
	}
	}
    }
    print $of "}\n";
    print $of "\n";
    close($of);


    # ------------------- write xyzbase
    open($of, '>', "$baseFilename.xyz")
	or die "Could not open file '$baseFilename.xyz' $!";
    print " Write $baseFilename.xyz\n";

    for my $az ( @azValues ) {
	for my $el ( @elValues ){
	    if (! defined( $values->{$az}->{$el})){
		print "   missing $az $el\n";
	    } else {	    
		my $x = $values->{$az}->{$el}->{x};
		my $y = $values->{$az}->{$el}->{y};
		my $z = $values->{$az}->{$el}->{z} - $minZ;
		my $outLine= sprintf("%12.3f %12.3f %12.3f",$x, $y, $z);
		# print "$outLine\n";
		print $of $outLine;
	    }
	}
    }
    close($of);

    #    print Dumper(\$values);
}


