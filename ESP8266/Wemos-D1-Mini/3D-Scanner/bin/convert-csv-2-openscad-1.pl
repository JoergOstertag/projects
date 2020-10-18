#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min max);
use Math::Trig;

sub writeHeader($){
    my $of = shift;
    print $of "
// ===========================================================
// 3D-Scan with Distance Sensor
// ===========================================================
fov= 2;
\n";
}

sub writeModule($){
    my $of = shift;
    
print $of "\n";
print $of "\n";
print $of "\n";
print $of "\n";
print $of "module segment(az=0,el=0,dist=20){
if ( dist > 0 ) {
    tanFactor=tan(fov);
    deltaDist= .1;
    dist1= dist-deltaDist;

      rotate( [el,0,-az] )
        rotate( [-90,0,0] )
          translate([0,0,dist1])
            cylinder( d1= tanFactor*dist1,
                      d2= tanFactor*dist,
                       h= deltaDist );
    }
}


    ";
}



my $filenameAll = 'all.scad';
my $of;
open($of, '>', $filenameAll)
    or die "Could not open file '$filenameAll' $!";

writeHeader($of);
writeModule($of);

foreach my $fileName (@ARGV) {
    print "Import $fileName\n";
    open(my $fh, $fileName)
	or warn "Can't open $fileName: $!";

    my $oFilename= "$fileName.scad";
    $oFilename =~s/\.csv//;
    my $of1;
    open($of1, '>', $oFilename)
	or die "Could not open file '$oFilename' $!";
    print "Write $oFilename\n";
    writeHeader($of1);
    writeModule($of1);

    my $line = readline $fh;
    while ( ! eof($fh) ) {
	$line = readline $fh;
	$line =~ s/\s*$//;
	my ($az,$el,$dist) = split(/;/,$line);
	my $outLine="segment(az=$az,	el=$el,	dist=$dist);\n";
	print $of $outLine;
	print $of1 $outLine;
	
    }
    
    close($fh);
    close($of1);
}




foreach my $fileName (@ARGV) {
    print "Import $fileName\n";

    my $baseFilename= "$fileName";
    $baseFilename =~s/\.csv//;


    open(my $fh, $fileName)
	or warn "Can't open $fileName: $!";


    my $values;
    my $stepAz=2;
    my $stepEl=2;
    my $minAz=180;
    my $minEl=180;
    my $maxAz=-180;
    my $maxEl=-180;
    my $minZ=100000;
    
    my $line = readline $fh; # Header weg
    while ( ! eof($fh) ) {
	$line = readline $fh;
	$line =~ s/\s*$//;
	my ($az,$el,$dist) = split(/;/,$line);
	$az= $az*1;
	$el=$el*1;
	print "($az,$el,$dist)\n";
	my $azRad = $az * pi() / 180;
	my $elRad = $el * pi() / 180;
	
	my $distFloor= cos($elRad)*$dist;
	my $z = sin($elRad) * $dist;
	my $x = cos($azRad) * $distFloor;
	my $y = sin($azRad) * $distFloor;
	$values->{$az}->{$el}={
	    dist=>$dist,
	    x => $x,
	    y => $y,
	    z => $z
	};
	$minAz=min($az,$minAz);
	$maxAz=max($az,$maxAz);
	$minEl=min($el,$minEl);
	$maxEl=max($el,$maxEl);
	$minZ=min($z,$minZ);
    }
    close($fh);


    # ----------------- write scad
    my $of;
    if ( 0 ){
	open($of, '>', "$baseFilename-1.scad")
	    or die "Could not open file '$baseFilename-1.scad' $!";
	print "Write $baseFilename-1.scad\n";
	writeHeader($of);
	writeModule($of);

    for ( my $az=$minAz ; $az<=$maxAz ; $az+=$stepAz ){
	for ( my $el=$minEl ; $el<=$maxEl ; $el+=$stepEl ){
	    my $dist = $values->{$az}->{$el}->{dist};
	    my $outLine="segment(az=$az,	el=$el,	dist=$dist);\n";
	    print $of $outLine;
	}
    }
    close($of);
}

    # ------------------- write xyzbase
    open($of, '>', "$baseFilename.xyz")
	or die "Could not open file '$baseFilename.xyz' $!";
    print "Write $baseFilename.xyz\n";

    print "Az: $minAz $maxAz += $stepAz\n";
    print "El: $minEl $maxEl += $stepEl\n";
    for ( my $az=$minAz ; $az<=$maxAz ; $az += $stepAz ){
	for ( my $el=$minEl ; $el<=$maxEl ; $el += $stepEl ){
	    print " values: $az $el: ";
	    if (! defined( $values->{$az}->{$el})){
		print "missing\n";
	    } else {	    
		my $x = $values->{$az}->{$el}->{x};
		my $y = $values->{$az}->{$el}->{y};
		my $z = $values->{$az}->{$el}->{z} - $minZ;
		my $outLine= sprintf("%12.8f %12.8f %12.8f\n",$x, $y, $z);
		print "$outLine\n";
		print $of $outLine;
	    }
	}
    }
    close($of);
    
#    print Dumper(\$values);
}


