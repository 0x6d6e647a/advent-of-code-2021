#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( first );

my %nodes;

while ( <STDIN> ) {
    chomp;

    my ($point_a, $point_b) = split /-/, $_;

    push @{$nodes{$point_a}}, $point_b;
    push @{$nodes{$point_b}}, $point_a;
}

my $paths;

my @s = ( [ 'start' ] );

while ( @s ) {
    my $curr_path = pop @s;
    my $vertex = $curr_path->[$#$curr_path];

    if ( $vertex eq 'end' ) {
        ++$paths;
        next;
    }

    if (( ! defined first { $vertex eq $_ } @$curr_path[ 0 .. $#$curr_path - 1 ] )
        || ( $vertex =~ qr/^[A-Z]+$/ )) {
        foreach my $next_vertex ( @{$nodes{$vertex}} ) {
            push @s, [ @$curr_path, $next_vertex ];
        }
    }
}

print $paths . "\n";
