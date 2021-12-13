#!/usr/bin/perl

use strict;
use warnings;

my %points;

my $row_max = -1 * 'inf';
my $col_max = -1 * 'inf';

while ( <STDIN> ) {
    chomp;
    last if $_ eq '';

    my ($col, $row) = split /,/, $_;

    $row_max = $row if $row > $row_max;
    $col_max = $col if $col > $col_max;

    $points{"$row,$col"} = '#';
}

sub print_points {
    for my $row ( 0 .. $row_max ) {
        for my $col ( 0 .. $col_max ) {
            if ( exists $points{"$row,$col"} ) {
                print '#';
            } else {
                print ' ';
            }
        }
        print "\n";
    }
}

sub fold_horz {
    my $val = shift;

    for my $col ( 0 .. $col_max ) {
        delete $points{$val,$col};
    }

    my $max_row = -1 * 'inf';
    my $max_col = -1 * 'inf';

    for my $src_row ( $val + 1 .. $row_max ) {
        my $row_adj = abs($src_row - $val);
        my $dst_row = $val - $row_adj;

        for my $src_col ( 0 .. $col_max ) {
            my $dst_col = $src_col;

            if ( exists $points{"$src_row,$src_col"} ) {
                $points{"$dst_row,$dst_col"} = $points{"$src_row,$src_col"};
                delete $points{"$src_row,$src_col"};
            }

            $max_row = $dst_row if $dst_row > $max_row;
            $max_col = $dst_col if $dst_col > $max_col;
        }
    }

    $row_max = $max_row;
    $col_max = $max_col;
}

sub fold_vert {
    my $val = shift;

    for my $row ( 0 .. $row_max ) {
        delete $points{$row,$val};
    }

    my $max_row = -1 * 'inf';
    my $max_col = -1 * 'inf';

    for my $src_row ( 0 .. $row_max ) {
        my $dst_row = $src_row;

        for my $src_col ( $val + 1 .. $col_max ) {
            my $col_adj = abs($src_col - $val);
            my $dst_col = $val - $col_adj;

            if ( exists $points{"$src_row,$src_col"} ) {
                $points{"$dst_row,$dst_col"} = $points{"$src_row,$src_col"};
                delete $points{"$src_row,$src_col"};
            }

            $max_row = $dst_row if $dst_row > $max_row;
            $max_col = $dst_col if $dst_col > $max_col;
        }
    }

    $row_max = $max_row;
    $col_max = $max_col;
}

while ( <STDIN> ) {
    chomp;
    s/^fold along //;
    my ($axis, $val) = split /=/;

    if ( $axis eq 'x' ) {
        fold_vert($val);
    } elsif ( $axis eq 'y' ) {
        fold_horz($val);
    }
}

print_points();
