#!/usr/bin/perl

use strict;
use warnings;

my $hoz = 0;
my $depth = 0;

while ( <STDIN> ) {
    my @input = split ' ';

    my $command = $input[0];
    my $value = $input[1];

    if ( $command =~ qr/forward/ ) {
        $hoz += $value;
    } elsif ( $command =~ qr/down/ ) {
        $depth += $value;
    } elsif ( $command =~ qr/up/ ) {
        $depth -= $value;
    }
}

my $result = $hoz * $depth;
print "$result\n";
