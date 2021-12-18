#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( reduce );
use POSIX qw( floor ceil );

sub sfn_parse {
    my $s = shift;

    if ( $s->[0] eq '[' ) {
        shift @$s;

        my %node = (
            left  => sfn_parse( $s ),
            right => sfn_parse( $s )
        );
        $node{left}->{parent}  = \%node;
        $node{right}->{parent} = \%node;

        return \%node;
    } elsif ( ( $s->[0] eq ',' ) ||
              ( $s->[0] eq ']' ) ) {
        shift @$s;
        return sfn_parse( $s );
    } elsif ( $s->[0] =~ qr/\d/ ) {
        my @digits;

        while ( @$s ) {
            my $c = shift @$s;

            if ( $c =~ qr/\d/ ) {
                push @digits, $c;
            } elsif ( ( $c eq ',' ) ||
                      ( $c eq ']' ) ) {
                return { value => int join '', @digits };
            }
        }
    }
}

sub sfn_get_leaves {
    my $sfn = shift;
    my $depth = shift // 0;

    my @ret;

    if ( exists $sfn->{value} ) {
        return [ { depth => $depth,
                   sfn   => $sfn } ];
    } elsif ( ( exists $sfn->{left}  ) &&
              ( exists $sfn->{right} ) ) {
        push @ret, @{sfn_get_leaves($sfn->{left},  $depth + 1)};
        push @ret, @{sfn_get_leaves($sfn->{right}, $depth + 1)};
        return \@ret;
    }
}

sub sfn_get_adj_leaf {
    my $root = shift;
    my $sfn  = shift;
    my $dir  = shift;

    $dir = -1 if $dir eq 'left';
    $dir = 1  if $dir eq 'right';

    my @leaves = @{sfn_get_leaves($root)};

    while ( my ($idx, $leaf) = each @leaves ) {
        if ( $sfn == $leaf->{sfn} ) {
            if ( ( $idx + $dir >= 0 ) &&
                 ( $idx + $dir <= scalar @leaves - 1 ) ){
                return $leaves[ $idx + $dir]->{sfn};
            }
        }
    }
}

sub sfn_explode {
    my $root = shift;
    my $sfn  = shift;

    my $left  = sfn_get_adj_leaf($root, $sfn->{left},  'left');
    my $right = sfn_get_adj_leaf($root, $sfn->{right}, 'right');

    $left->{value}  += $sfn->{left}->{value}  if $left;
    $right->{value} += $sfn->{right}->{value} if $right;

    delete $sfn->{left};
    delete $sfn->{right};
    $sfn->{value} = 0;
}

sub sfn_split {
    my $sfn = shift;

    $sfn->{left} = { value  => floor( $sfn->{value} / 2 ),
                     parent => $sfn };
    $sfn->{right} = { value  => ceil( $sfn->{value} / 2 ),
                      parent => $sfn };

    delete $sfn->{value};
}

sub sfn_reduce {
    no warnings 'recursion';

    my $sfn = shift;

    my $leaves = sfn_get_leaves($sfn);

    foreach my $leaf ( @$leaves ) {
        if ( $leaf->{depth} > 4 ) {
            sfn_explode($sfn, $leaf->{sfn}->{parent});
            return sfn_reduce($sfn);
        }
    }

    foreach my $leaf ( @$leaves ) {
        if ( $leaf->{sfn}->{value} > 9 ) {
            sfn_split($leaf->{sfn});
            return sfn_reduce($sfn);
        }
    }

    return $sfn;
}

sub sfn_add {
    my $sfn0 = shift;
    my $sfn1 = shift;

    my %ret = ( left  => $sfn0,
                right => $sfn1 );
    $ret{left}->{parent}  = \%ret;
    $ret{rigth}->{parent} = \%ret;

    return \%ret;
}

sub sfn_magnitude {
    my $sfn = shift;

    if ( exists $sfn->{value} ) {
        return $sfn->{value};
    } elsif ( ( exists $sfn->{left} ) &&
              ( exists $sfn->{right} ) ) {
        return ( ( 3 * sfn_magnitude($sfn->{left}) ) +
                 ( 2 * sfn_magnitude($sfn->{right}) ) );
    }

    return 0;
}

my @lines;

while ( <STDIN> ) {
    chomp;
    push @lines, [ split //, $_ ];
}

print sfn_magnitude(
    reduce { sfn_reduce(sfn_add($a, $b)) }
        map { sfn_reduce(sfn_parse($_)) } @lines
) . "\n";
