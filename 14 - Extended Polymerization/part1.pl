#!/usr/bin/env perl

use strict;
use warnings;

my $template;
my @rules;

while ( <STDIN> ) {
    chomp;

    next if $_ eq '';

    if ( ! defined $template ) {
        $template = $_;
        next;
    }

    push @rules, [ split / -> / ];
}

my $s = $template;

for ( 0 .. 9 ) {
    my @locations;

    foreach ( @rules ) {
        my ($lhs, $rhs) = @$_;

        my $loc = 0;

        while (1) {
            $loc = index($s, $lhs, $loc);
            last if $loc == -1;
            push @locations, [ $loc, $lhs, $rhs ];
            ++$loc;
        }
    }

    @locations = sort { $a->[0] <=> $b->[0] } @locations;

    for ( 0 .. $#locations ) {
        my ($loc, $lhs, $rhs) = @{$locations[$_]};
        my $left = substr $s, 0, $loc + 1 + $_;
        my $right = substr $s, $loc + $_ + 1;
        $s = $left . $rhs . $right;

    }
}

my %charfreq;

foreach ( split //, $s ) {
    ++$charfreq{$_};
}

my $most_char;
my $most_n = -1 * 'inf';
my $least_char;
my $least_n = 1 * 'inf';

foreach my $char ( keys %charfreq ) {
    my $val = $charfreq{$char};

    if ( $val > $most_n ) {
        $most_n = $val;
        $most_char = $char;
    }

    if ( $val < $least_n ) {
        $least_n = $val;
        $least_char = $char;
    }
}

print '' . ( $most_n - $least_n ) . "\n";
