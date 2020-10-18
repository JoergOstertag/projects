#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min,max);
 
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
    open(my $fh, $fileName)
	or warn "Can't open $fileName: $!";


    my $values;
    my $stepAz=2;
    my $stepEl=2;
    my $minAz=180;
    my $minEl=180;
    my $maxAz=-180;
    my $maxEl=-180;

    my $line = readline $fh; # Header weg
    while ( ! eof($fh) ) {
	$line = readline $fh;
	$line =~ s/\s*$//;
	my ($az,$el,$dist) = split(/;/,$line);
	print "($az,$el,$dist)\n";
	$values->{$az}->{$el}={dist=>$dist};
	$minAz=min($az,$minAz);
    }


    my $oFilename= "$fileName-1.scad";
    $oFilename =~s/\.csv//;
    my $of1;
    open($of1, '>', $oFilename)
	or die "Could not open file '$oFilename' $!";
    print "Write $oFilename\n";
    writeHeader($of1);
    writeModule($of1);

    for ( my $az=$minAz ; $az<$maxAz ; $az+=$stepAz ){
	for ( my $el=$minEl ; $el<$maxEl ; $el+=$stepEl ){
	    my $dist = $values->{$az}->{$el}->{dist};
	    my $outLine="segment(az=$az,	el=$el,	dist=$dist);\n";
	    print $of $outLine;
	}
    }
    
    close($of1);
#    print Dumper(\$values);
    close($fh);
}


