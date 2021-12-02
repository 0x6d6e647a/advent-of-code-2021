#!/usr/bin/perl
use List::Util qw( sum );

my @prev;
my $count = 0;

while ( <STDIN> ) {
    chomp;
    int;

    if ( scalar @prev < 3 ) {
        push @prev, $_;
        next;
    }

    push @prev, $_;

    my $sum_0 = sum( @prev[0..2] );
    my $sum_1 = sum( @prev[1..3] );

    if ( $sum_1 > $sum_0) {
        ++$count;
    }

    shift @prev;
}

print "$count\n";
