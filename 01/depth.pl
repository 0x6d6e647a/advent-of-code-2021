#!/usr/bin/perl

my $prev = undef;
my $count = 0;

while ( <STDIN> ) {
    chomp;
    int;

    if ( ! defined $prev ) {
        $prev = $_;
        next;
    }

    if ( $_ > $prev) {
        ++$count;
    }

    $prev = $_;
}

print "$count\n";
