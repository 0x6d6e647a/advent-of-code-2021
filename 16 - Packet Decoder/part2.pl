#!/usr/bin/perl

use strict;
use warnings;

use bigint;

use List::Util qw( sum product min max  );

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
            push @vals, parse_packet($subbits);
        }
    } elsif ( $len_id == 1 ) {
        for ( 0 .. $length - 1) {
            push @vals, parse_packet($bits);
        }
    }

    return \@vals;
}

sub parse_packet {
    my $bits = shift;

    my $ver = oct( '0b' . join '', splice @$bits, 0, 3 );
    my $typeid = oct( '0b' . join '', splice @$bits, 0, 3 );

    return parse_literal_value_packet($bits)    if $typeid == 4;

    my $vals = parse_operator_packet($bits);

    return sum    ( @$vals )                    if $typeid == 0;
    return product( @$vals )                    if $typeid == 1;
    return min    ( @$vals )                    if $typeid == 2;
    return max    ( @$vals )                    if $typeid == 3;
    return ( $vals->[0] >  $vals->[1] ) ? 1 : 0 if $typeid == 5;
    return ( $vals->[0] <  $vals->[1] ) ? 1 : 0 if $typeid == 6;
    return ( $vals->[0] == $vals->[1] ) ? 1 : 0 if $typeid == 7
}


my $input = <STDIN>;
chomp $input;
print parse_packet(hex2bin($input)) . "\n";
