#!/usr/bin/perl

use strict;
use warnings;

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

    if ( ( ( scalar grep { $vertex eq $_ } @$curr_path[ 0 .. $#$curr_path - 1 ] ) <= 1 )
        || ( $vertex =~ qr/^[A-Z]+$/ )) {
        foreach my $next_vertex ( @{$nodes{$vertex}} ) {
            next if $next_vertex eq 'start';

            my %checker;

            foreach ( @$curr_path ) {
                next if $_ eq 'start';
                next if $_ eq 'end';
                next if $_ =~ qr/^[A-Z]+$/;
                ++$checker{$_};
            }

            ++$checker{$next_vertex};

            my $num_small_over = scalar grep { $checker{$_} > 1 } keys %checker;
            next if $num_small_over > 1;

            push @s, [ @$curr_path, $next_vertex ];
        }
    }
}

print $paths . "\n";
