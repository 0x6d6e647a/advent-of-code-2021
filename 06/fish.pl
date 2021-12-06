#!/usr/bin/perl

use strict;
use warnings;

my @fishes = split /,/, <STDIN>;

for ( 1 .. 80 ) {
    my @new_fishes;

    foreach ( @fishes ) {
        if ( $_ == 0 ) {
            push @new_fishes, 8;
            $_ = 6;
        } else {
            --$_;
        }
    }

    push @fishes, @new_fishes;
}

print scalar @fishes . "\n";
