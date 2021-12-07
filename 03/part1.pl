#!/usr/bin/perl

use strict;
use warnings;

my @bit_fields;

while ( <STDIN> ) {
    chomp;
    for my $i ( 0 .. length($_) - 1 ) {
        my $bit = substr($_, $i, 1);
        $bit_fields[$i]{$bit} += 1;
    }
}

my $gamma = '';
my $epsilon = '';

foreach (@bit_fields) {
    if ( $_->{'0'} > $_->{'1'} ) {
        $gamma   .= '0';
        $epsilon .= '1';
    } else {
        $gamma   .= '1';
        $epsilon .= '0';
    }
}

print oct( '0b' . $gamma ) * oct( '0b' . $epsilon ) . "\n";
