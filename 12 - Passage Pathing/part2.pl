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

my @s = ( [ {}, [ 'start' ] ] );

while ( @s ) {
    my ($checker, $curr_path) = @{pop @s};
    my $vertex = $curr_path->[$#$curr_path];

    if ( $vertex eq 'end' ) {
        ++$paths;
        next;
    }

    if ( ( ( $checker->{$vertex} // 0 ) <= 2 )
        || ( $vertex =~ qr/^[A-Z]+$/ ) ) {
        foreach my $next_vertex ( @{$nodes{$vertex}} ) {
            next if $next_vertex eq 'start';

            my %new_checker = %$checker;
            ++$new_checker{$next_vertex} if ( ( $next_vertex !~ qr/^[A-Z]+$/ ) &&
                                              ( $next_vertex ne 'end' ) );

            next if ( scalar grep { $new_checker{$_} > 1 } keys %new_checker ) > 1;

            push @s, [ \%new_checker, [ @$curr_path, $next_vertex ] ];
        }
    }
}

print $paths . "\n";
