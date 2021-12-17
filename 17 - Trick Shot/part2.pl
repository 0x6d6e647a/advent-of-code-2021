#!/usr/bin/perl

use strict;
use warnings;

sub fire_probe {
    my $x_vel = shift;
    my $y_vel = shift;
    my $target_x0 = shift;
    my $target_x1 = shift;
    my $target_y0 = shift;
    my $target_y1 = shift;

    my @positions = ( [0,0] );
    my $hit = 0;

    while () {
        my ($x, $y) = @{$positions[$#positions]};

        $x += $x_vel;
        $y += $y_vel;

        if ( $x_vel > 0 ) {
            --$x_vel;
        } elsif ( $x_vel < 0 ) {
            ++$x_vel;
        }
        --$y_vel;

        push @positions, [ $x,$y ];

        if ( ( $x >= $target_x0 ) &&
             ( $x <= $target_x1 ) &&
             ( $y <= $target_y0 ) &&
             ( $y >= $target_y1 ) ) {
            $hit = 1;
            last;
        }

        if ( ( $x > $target_x1 ) ||
             ( $y < $target_y1 ) ) {
            last;
        }
    }

    return ( $hit, \@positions );
}

my $input = <STDIN>;
chomp $input;
$input =~ s/^target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)$/$1 $2 $3 $4/;
my ($x0, $x1, $y0, $y1) = split / /, $input;
($x0, $x1) = ($x1, $x0) if $x0 > $x1;
($y0, $y1) = ($y1, $y0) if $y0 < $y1;

my $hits;

for my $xv ( -300 .. 300 ) {
    for my $yv ( -300 .. 300 ) {
        my ($hit, $positions) = fire_probe($xv, $yv, $x0, $x1, $y0, $y1);
        ++$hits if $hit;
    }
}

print "$hits\n";
