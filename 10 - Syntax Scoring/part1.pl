#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( first sum );

my @lines;

while ( <STDIN> ) {
    chomp;
    push @lines, $_;
}

sub get_index {
    my $arr = shift;
    my $x   = shift;

    return first { $arr->[$_] eq $x } (0 .. scalar @$arr - 1);
}

my @openings = ( '(', '[', '{', '<' );
my @closings = ( ')', ']', '}', '>' );

sub find_error {
    my $line = shift;

    my @s;

    foreach my $index ( 0 .. length($line) - 1 ) {
        my $char = substr($line, $index, 1);

        if ( defined first { $_ eq $char } @openings ) {
            push @s, $char;
        } elsif ( defined first { $_ eq $char } @closings ) {
            my $opening = $openings[get_index(\@closings, $char)];
            return $char if pop @s ne $opening;
        }
    }

    return;
}

my %scoring = (
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
);

print sum( map { $scoring{$_} } grep { defined $_ } map { find_error($_) } @lines ) . "\n";
