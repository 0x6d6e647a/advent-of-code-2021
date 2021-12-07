#!/usr/bin/perl

use strict;
use warnings;

my $aim = 0;
my $hoz = 0;
my $depth = 0;

while ( <STDIN> ) {
    my @input = split ' ';

    my $command = $input[0];
    my $value = $input[1];

    if ( $command =~ qr/forward/ ) {
        $hoz += $value;
        $depth += $aim * $value;
    } elsif ( $command =~ qr/down/ ) {
        $aim += $value;
    } elsif ( $command =~ qr/up/ ) {
        $aim -= $value;
    }
}

print $hoz * $depth . "\n";
