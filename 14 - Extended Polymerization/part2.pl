#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw( max min );

my @template;
my %rules;

while ( <STDIN> ) {
    chomp;

    next if $_ eq '';

    if ( ! @template ) {
        @template = split //;
        next;
    }

    my ($lhs, $rhs) = split / -> /;
    $rules{$lhs} = $rhs;
}

my %counts;

++$counts{join '', @template[$_ .. $_ + 1]} for 0 .. scalar @template - 2;

my $lastc = $template[$#template];

for ( 0 .. 39 ) {
    my %new_counts;

    while ( my ($pair, $count) = each %counts ) {
        my ($a, $b) = split //, $pair;
        my $rhs = $rules{$pair};
        $new_counts{$a . $rhs} += $count;
        $new_counts{$rhs . $b} += $count;
    }

    %counts = %new_counts;
}

my %totals;

foreach ( keys %{{ map { ( split //, $_ )[0] => 0 } keys %counts }} ) {
    while ( my ($key, $value) = each %counts ) {
        if ( ( split //, $key )[0] eq $_ ) {
            $totals{$_} += $value;
        }
    }
}

++$totals{$lastc};

print ''. (  max( values %totals ) -  min( values %totals ) ) . "\n";
