#!/usr/bin/perl

use strict;
use warnings;

my %map;

my $row_sz = 0;
my $col_sz = 0;

while ( <STDIN> ) {
    chomp;

    my $col = 0;

    foreach ( split //, $_) {
        $map{"$row_sz,$col"} = {
            row => $row_sz,
            col => $col,
            lvl => int($_),
        };

        ++$col;
    }

    ++$row_sz;
    $col_sz = $col;
}

sub get_neighbors {
    my $entry = shift;

    my $row = $entry->{row};
    my $col = $entry->{col};

    my @ret;

    push @ret, $map{($row - 1) . ',' . ($col)}     if $row - 1 >= 0;                               # N
    push @ret, $map{($row - 1) . ',' . ($col + 1)} if ($row - 1 >= 0) && ($col + 1 < $col_sz);     # NE
    push @ret, $map{($row)     . ',' . ($col + 1)} if $col + 1 < $col_sz;                          # E
    push @ret, $map{($row + 1) . ',' . ($col + 1)} if ($row + 1 < $row_sz) && ($col +1 < $col_sz); # SE
    push @ret, $map{($row + 1) . ',' . ($col)}     if $row + 1 < $row_sz;                          # S
    push @ret, $map{($row + 1) . ',' . ($col - 1)} if ($row + 1 < $row_sz) && ($col - 1 >= 0);     # SW
    push @ret, $map{($row)     . ',' . ($col - 1)} if $col - 1 >= 0;                               # W
    push @ret, $map{($row - 1) . ',' . ($col - 1)} if ($row - 1 >= 0) && ($col - 1 >= 0);          # NW

    return \@ret;
}

sub do_step {
    my @do_flash;

    for my $row ( 0 .. $row_sz - 1 ) {
        for my $col ( 0 .. $col_sz - 1 ) {
            my $entry = $map{"$row,$col"};

            ++$entry->{lvl};

            push @do_flash, $entry if $entry->{lvl} > 9;
        }
    }

    my @did_flashes;

    while ( @do_flash ) {
        my $entry = shift @do_flash;

        next if $entry->{lvl} == (-1 * 'inf');

        foreach ( @{get_neighbors($entry)} ) {
            ++$_->{lvl};
            push @do_flash, $_ if $_->{lvl} > 9;
        }

        $entry->{lvl} = -1 * 'inf';
        push @did_flashes, $entry;
    }

    foreach ( @did_flashes ) {
        $_->{lvl} = 0;
    }
}

for ( 1 .. 9999 ) {
    do_step();

    my $all_explode = 1;

    for my $row ( 0 .. $row_sz - 1) {
        for my $col ( 0 .. $col_sz - 1 ) {
            my $lvl = $map{"$row,$col"}->{lvl};
            $all_explode = 0 if $lvl != 0;
            last if $all_explode == 0;
        }
        last if $all_explode == 0;
    }

    if ( $all_explode ) {
        print "$_\n";
        last;
    }
}

