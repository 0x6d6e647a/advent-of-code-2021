#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( sum );
use POSIX qw( ceil );

my @pos = split /,/, <STDIN>;
my $median = sum( ( sort { $a <=> $b } @pos )[ int( $#pos/2 ), ceil( $#pos/2 ) ] )/2;
print sum( map { abs( $_ - $median ) } @pos ) . "\n";
