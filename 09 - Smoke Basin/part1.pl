#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( all sum );

my $hmap;

while ( <STDIN> ) {
    chomp;
    push @$hmap, [ split //, $_ ];
}

sub get_neighbors {
    my $hmap = shift;
    my $row  = shift;
    my $col  = shift;

    my @ret;

    push @ret, { row => $row - 1, col => $col } if $row - 1 >= 0;
    push @ret, { row => $row + 1, col => $col } if $row + 1 < scalar @$hmap;
    push @ret, { row => $row, col => $col - 1 } if $col - 1 >= 0;
    push @ret, { row => $row, col => $col + 1 } if $col + 1 < scalar @{$hmap->[$row]};

    map { $_->{val} = $hmap->[$_->{row}]->[$_->{col}] } @ret;

    return \@ret;
}

my @risks;

for my $row ( 0 .. scalar @$hmap - 1 ) {
    for my $col ( 0 .. scalar @{$hmap->[$row]} - 1 ) {
        my $curr  = $hmap->[$row]->[$col];
        my @neighbors = @{get_neighbors($hmap, $row, $col)};
        push @risks, $curr + 1 if all { $curr < $_->{val} } @neighbors;
    }
}

print sum(@risks) . "\n";
