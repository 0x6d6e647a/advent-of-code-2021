#!/usr/bin/perl

use strict;
use warnings;

my $prev = undef;
my $count = 0;

while ( <STDIN> ) {
    if ( ! defined $prev ) {
        $prev = $_;
        next;
    }

    ++$count if $_ > $prev;

    $prev = $_;
}

print "$count\n";
