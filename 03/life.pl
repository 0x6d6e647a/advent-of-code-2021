#!/usr/bin/perl

use strict;
use warnings;

my @o2;
my @co2;

while ( <STDIN> ) {
    chomp;
    push @o2, $_;
    push @co2, $_;
}

for my $bit_index ( 0 .. length $o2[0] - 1 ) {
    if ( scalar @o2 > 1 ) {
        my $o2_num0 = 0;
        my $o2_num1 = 0;

        foreach ( @o2 ) {
            my $val = substr($_, $bit_index, 1);
            $val == 0 ? ++$o2_num0 : ++$o2_num1;
        }

        my $o2_target = $o2_num0 > $o2_num1 ? 0 : 1;

        my @o2_new;

        foreach (@o2) {
            if ( substr($_, $bit_index, 1) == $o2_target ) {
                push @o2_new, $_;
            }
        }

        @o2 = @o2_new;
    }

    if ( scalar @co2 > 1 ) {
        my $co2_num0 = 0;
        my $co2_num1 = 0;

        foreach ( @co2 ) {
            my $val = substr($_, $bit_index, 1);
            $val == 0 ? ++$co2_num0 : ++$co2_num1;
        }

        my $co2_target =  $co2_num0 > $co2_num1 ? 1 : 0;

        my @co2_new;

        foreach (@co2) {
            if ( substr($_, $bit_index, 1) == $co2_target ) {
                push @co2_new, $_;
            }
        }

        @co2 = @co2_new;
    }

    last if (scalar @o2 == 1 && scalar @co2 == 1);
}

print oct( '0b' . $o2[0] ) * oct( '0b' . $co2[0] ) . "\n";
