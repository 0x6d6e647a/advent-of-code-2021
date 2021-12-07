#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( max min );

my @pos = split /,/, <STDIN>;
my $least = 0 + 'inf';

for my $target ( min( @pos ) .. max( @pos ) ) {
    my $cost = 0;

    foreach ( @pos ) {
        my $steps = abs( $_ - $target );
        $cost += ($steps * $steps + $steps) / 2;
    }

    $least = $cost if $cost < $least;
}

print $least . "\n";

