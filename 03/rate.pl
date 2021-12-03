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
    my $num0 = $_->{'0'};
    my $num1 = $_->{'1'};

    if ( $num0 > $num1 ) {
        $gamma   .= '0';
        $epsilon .= '1';
    } else {
        $gamma   .= '1';
        $epsilon .= '0';
    }
}

$gamma = oct( '0b' . $gamma );
$epsilon = oct( '0b' . $epsilon );

print $gamma * $epsilon . "\n";
