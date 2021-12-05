#!/usr/bin/perl

use strict;
use warnings;

my %grid;
my $points;

while ( <STDIN> ) {
    chomp;

    my ($x1, $y1, $x2, $y2) = split /,| -> /;

    my $dx = -($x1 <=> $x2);
    my $dy = -($y1 <=> $y2);
    next if ($dx != 0) && ($dy != 0);
    my $d = abs($dx != 0 ? $x2 - $x1 : $y2 - $y1);

    for ( 0 .. $d ) {
        my $x = $x1 + ($dx * $_);
        my $y = $y1 + ($dy * $_);
        ++$grid{"$x,$y"};
        ++$points if $grid{"$x,$y"} == 2;
    }
}

print $points . "\n";
