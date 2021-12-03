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

my $bit_width = length $o2[0];

for my $bit_index ( 0 .. $bit_width - 1 ) {
    if ( scalar @o2 > 1 ) {
        my $o2_num0  = 0;
        my $o2_num1  = 0;

        foreach my $o2_val ( @o2 ) {
            my $val = substr($o2_val, $bit_index, 1);

            if ( $val eq '0' ) {
                $o2_num0 += 1;
            } elsif ( $val eq '1' ) {
                $o2_num1 += 1;
            }
        }

        my $o2_target = undef;

        if ( $o2_num0 > $o2_num1 ) {
            $o2_target = 0;
        } elsif ( $o2_num0 < $o2_num1 ) {
            $o2_target = 1;
        } else {
            $o2_target = 1;
        }

        my @o2_new;

        foreach my $o2_val (@o2) {
            if ( substr($o2_val, $bit_index, 1) == $o2_target ) {
                push @o2_new, $o2_val;
            }
        }

        @o2 = @o2_new;
    }

    if ( scalar @co2 > 1 ) {
        my $co2_num0 = 0;
        my $co2_num1 = 0;

        foreach my $co2_val ( @co2 ) {
            my $val = substr($co2_val, $bit_index, 1);

            if ( $val eq '0' ) {
                $co2_num0 += 1;
            } elsif ( $val eq '1' ) {
                $co2_num1 += 1;
            }
        }

        my $co2_target = undef;

        if ( $co2_num0 > $co2_num1 ) {
            $co2_target = 1;
        } elsif ( $co2_num0 < $co2_num1 ) {
            $co2_target = 0;
        } else {
            $co2_target = 0;
        }

        my @co2_new;

        foreach my $co2_val (@co2) {
            if ( substr($co2_val, $bit_index, 1) == $co2_target ) {
                push @co2_new, $co2_val;
            }
        }

        @co2 = @co2_new;
    }

    last if (scalar @o2 == 1 && scalar @co2 == 1);
}

my $o2_fin = oct( '0b' . $o2[0] );
my $co2_fin = oct( '0b' . $co2[0] );

print $o2_fin * $co2_fin . "\n";
