#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( min max sum );

my %maze;

my $row = 0;

while ( <STDIN> ) {
    chomp;
    my @chars = split //;
    while ( my ($col, $val) = each @chars ) {
        $maze{"$row,$col"} = $val;
    }
    ++$row;
}

undef $row;

my $nrow = max map { ( split /,/ )[0] } keys %maze;
my $ncol = max map { ( split /,/ )[1] } keys %maze;

sub get_neighbors {
    my ($row, $col) = split /,/, shift;

    my @ret;

    push @ret, { row => $row - 1, col => $col } if $row - 1 >= 0;
    push @ret, { row => $row + 1, col => $col } if $row + 1 < $nrow + 1;
    push @ret, { row => $row, col => $col - 1 } if $col - 1 >= 0;
    push @ret, { row => $row, col => $col + 1 } if $col + 1 < $ncol + 1;

    @ret = map { "$_->{row},$_->{col}" } @ret;

    return \@ret;
}

sub h {
    my ($row, $col) = split /,/, shift;
    return sqrt( ( ($nrow - $row) ** 2 ) + ( ($ncol - $col) ** 2 ) );
}

sub lowest {
    my $openset = shift;
    my $fscore = shift;

    my $low_coord;
    my $low_val = 1 * 'inf';

    foreach my $coord ( keys %$openset ) {
        my $val = $fscore->{$coord};

        if ( $val < $low_val ) {
            $low_coord = $coord;
            $low_val = $val;
        }
    }

    return $low_coord;
};

sub reconstruct_path {
    my $camefrom = shift;
    my $end = shift;

    my @path = ( $end );
    my $current = $end;

    while ( exists $camefrom->{$current} ) {
        $current = $camefrom->{$current};
        unshift @path, $current;
    }

    return \@path;
};

sub a_star {
    my %openset = ( '0,0' => undef );
    my %camefrom;
    my %gscore = map { $_ => 1 * 'inf' } keys %maze;
    $gscore{'0,0'} = 0;
    my %fscore = map { $_ => 1 * 'inf' } keys %maze;
    $fscore{'0,0'} = h('0,0');

    while ( %openset ) {
        my $current = lowest(\%openset, \%fscore);

        return reconstruct_path(\%camefrom, $current) if $current eq "$nrow,$ncol";

        delete $openset{$current};

        foreach my $neighbor ( @{get_neighbors($current)} ) {
            my $tenative_gscore = $gscore{$current} + $maze{$neighbor};

            if ( $tenative_gscore < $gscore{$neighbor} ) {
                $camefrom{$neighbor} = $current;
                $gscore{$neighbor} = $tenative_gscore;
                $fscore{$neighbor} = $tenative_gscore + h($neighbor);
                $openset{$neighbor} = undef;
            }
        }
    }

    die('a* search failed');
}

my @path = @{a_star()};
print sum( map {$maze{$_}} @path[ 1 .. $#path ] ) . "\n";
