#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( first );

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

sub do_autocomplete {
    my $line = shift;

    my @s;

    foreach my $index ( 0 .. length($line) - 1 ) {
        my $char = substr($line, $index, 1);

        if ( defined first { $_ eq $char } @openings ) {
            push @s, $char;
        } elsif ( defined first { $_ eq $char } @closings ) {
            pop @s;
        }
    }

    return join '', reverse map { $closings[get_index(\@openings, $_)] } @s;
}

sub score_line {
    my $line = shift;

    my $score = 0;

    my %scoring = (
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4,
    );

    foreach ( split //, $line ) {
        $score *= 5;
        $score += $scoring{$_};
    }

    return $score;
}

@lines = grep { ! defined find_error($_) } @lines;
@lines = sort { $a <=> $b } map { score_line(do_autocomplete($_)) } @lines;
print $lines[int(scalar @lines / 2)] . "\n";
