#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( sum );

my %fishes;

foreach ( split /,/, <STDIN> ) {
    ++$fishes{$_};
}

for ( 1 .. 256 ) {
    my %new_fishes;

    foreach ( keys %fishes ) {
        if ( $_ == 0 ) {
            $new_fishes{8} += $fishes{$_};
            $new_fishes{6} += $fishes{$_};

        } else {
            $new_fishes{$_ - 1} += $fishes{$_};
        }
    }

    %fishes = %new_fishes;
}

print sum(values %fishes) . "\n";
