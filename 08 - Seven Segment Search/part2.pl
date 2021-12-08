#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( all first sum );

my @entries;

while ( <STDIN> ) {
    chomp;

    my @line = split /\s/, $_;

    my %entry = (
        'signals' => [ @line[ 0 .. 9 ] ],
        'digits'  => [ @line[ 11 .. 14 ] ],
    );

    push @entries, \%entry;
}

sub decode {
    my $entry = shift;

    my @signals = @{$entry->{'signals'}};
    my @digits  = @{$entry->{'digits'}};

    my @d = (undef) x 10;
    $d[1] = (grep { length $_ == 2 } @signals)[0];
    $d[4] = (grep { length $_ == 4 } @signals)[0];
    $d[7] = (grep { length $_ == 3 } @signals)[0];
    $d[8] = (grep { length $_ == 7 } @signals)[0];

    my %s = ( a => (grep { index($d[1], $_) == -1 } split //, $d[7])[0] );

    foreach my $char ( split //, 'abcdefg' ) {
        my $count = grep { index($_, $char) >= 0 } @signals;

        $s{b} = $char if $count == 6;
        $s{e} = $char if $count == 4;
        $s{f} = $char if $count == 9;
        $s{c} = $char if $count == 8 && $char ne $s{a};

        if ( $count == 7 ) {
            if ( index($d[4], $char) == -1 ) {
                $s{g} = $char;
            } else {
                $s{d} = $char;
            }
        }
    }

    foreach my $sig ( @signals ) {
        if ( length $sig == 5 ) {
            if ( all { index($sig, $_) != -1 } ($s{a}, $s{c}, $s{d}, $s{e}, $s{g}) ) {
                $d[2] = $sig;
            } elsif ( all { index($sig, $_) != -1 } ($s{a}, $s{c}, $s{d}, $s{f}, $s{g}) ) {
                $d[3] = $sig;
            } elsif ( all { index($sig, $_) != -1 } ($s{a}, $s{b}, $s{d}, $s{f}, $s{g}) ) {
                $d[5] = $sig;
            }
        } elsif ( length $sig == 6 ) {
            if ( all { index($sig, $_) != -1 } ($s{a}, $s{b}, $s{c}, $s{e}, $s{f}, $s{g}) ) {
                $d[0] = $sig;
            } elsif ( all { index($sig, $_) != -1 } ($s{a}, $s{b}, $s{d}, $s{e}, $s{f}, $s{g}) ) {
                $d[6] = $sig;
            } elsif ( all { index($sig, $_) != -1 } ($s{a}, $s{b}, $s{c}, $s{d}, $s{f}, $s{g}) ) {
                $d[9] = $sig;
            }
        }
    }

    @d = map { join '', sort split //, $_ } @d;

    my $result;

    foreach my $digit ( @digits ) {
        $digit = join '', sort split //, $digit;
        $result .= first { $d[$_] eq $digit } 0 .. $#d;
    }

    return $result;
}

print sum( map { decode($_) } @entries ) . "\n";
