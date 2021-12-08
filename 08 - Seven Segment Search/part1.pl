#!/usr/bin/perl

use strict;
use warnings;

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

my $found;

foreach my $entry ( @entries ) {
    foreach my $digit ( @{$entry->{'digits'}} ) {
        my $len = length $digit;
        ++$found if (($len == 2) || ($len == 3) || ($len == 4) || ($len == 7));
    }
}

print "$found\n";
