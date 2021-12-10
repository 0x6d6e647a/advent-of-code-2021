#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( all product );

my $hmap;

while ( <STDIN> ) {
    chomp;
    push @$hmap, [ split //, $_ ];
}

sub get_neighbors {
    my $hmap   = shift;
    my $row    = shift;
    my $col    = shift;
    my $visted = shift;

    my @ret;

    push @ret, { row => $row - 1, col => $col } if $row - 1 >= 0;
    push @ret, { row => $row + 1, col => $col } if $row + 1 < scalar @$hmap;
    push @ret, { row => $row, col => $col - 1 } if $col - 1 >= 0;
    push @ret, { row => $row, col => $col + 1 } if $col + 1 < scalar @{$hmap->[$row]};

    @ret = grep { ! exists $visted->{"$_->{row},$_->{col}"} } @ret;

    map { $_->{val} = $hmap->[$_->{row}]->[$_->{col}] } @ret;

    return \@ret;
}


my @lowpts;

for my $row ( 0 .. scalar @$hmap - 1 ) {
    for my $col ( 0 .. scalar @{$hmap->[$row]} - 1 ) {
        my $curr  = $hmap->[$row]->[$col];
        my @neighbors = @{get_neighbors($hmap, $row, $col)};
        push @lowpts, { row => $row, col => $col, val => $curr }
            if all { $curr < $_->{val} } @neighbors;
    }
}

my @basin_sizes;

foreach my $lowpt ( @lowpts ) {
    my @basin;
    my @todo = ( $lowpt );
    my %visted = ( "$lowpt->{row},$lowpt->{col}" => 1 );

    while ( @todo ) {
        my $curr = shift @todo;
        my $val = $curr->{val};
        my $row = $curr->{row};
        my $col = $curr->{col};

        next if $val == 9;

        my @neighbors = @{get_neighbors($hmap, $row, $col, \%visted)};

        foreach ( @neighbors ) {
            $visted{"$_->{row},$_->{col}"} = 1;
        }

        push @todo, @neighbors;

        push @basin, $curr;
    }

    push @basin_sizes, scalar @basin;
}

print product((reverse sort { $a <=> $b } @basin_sizes)[0 .. 2]) . "\n";
