#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( sum );

my @f = (0) x 9;

foreach ( split /,/, <STDIN> ) {
    ++$f[$_];
}

for ( 1 .. 80 ) {
    push(@f, (shift(@f)));
    $f[6] += $f[8];
}

print sum( @f ) . "\n";
