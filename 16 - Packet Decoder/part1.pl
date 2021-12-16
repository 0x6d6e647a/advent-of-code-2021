#!/usr/bin/perl

use strict;
use warnings;

use bigint;

sub hex2bin {
    return [ map { split //, sprintf('%04b', hex($_)) } split //, shift ];
}

sub parse_literal_value_packet {
    my $bits = shift;

    my @values;
    my $islast = 0;

    while ( ! $islast ) {
        $islast = ! oct( '0b' . join '', splice @$bits, 0, 1 );
        push @values, splice @$bits, 0, 4;
    }

    return oct ( '0b' . join '', @values );
}

sub parse_operator_packet {
    my $bits = shift;

    my $len_id = oct( '0b' . join '', splice @$bits, 0, 1 );
    my $len_val = $len_id == 0 ? 15 : 11;
    my $length = oct( '0b' . join '', splice @$bits, 0, $len_val );

    my @vals;

    if ( $len_id == 0 ) {
        my $subbits = [ splice @$bits, 0, $length ];

        while ( scalar @$subbits != 0 ) {
            parse_packet($subbits);
        }
    } elsif ( $len_id == 1 ) {
        for ( 0 .. $length - 1) {
            parse_packet($bits);
        }
    }
}

my $ver_sum;

sub parse_packet {
    my $bits = shift;

    my $ver = oct( '0b' . join '', splice @$bits, 0, 3 );
    my $typeid = oct( '0b' . join '', splice @$bits, 0, 3 );

    $ver_sum += $ver;

    if ( $typeid == 4 ) {
        # -- Literal value.
        parse_literal_value_packet($bits);
    } else {
        parse_operator_packet($bits);
    }
}

my $input = <STDIN>;
chomp $input;
parse_packet(hex2bin($input));
print "$ver_sum\n";
