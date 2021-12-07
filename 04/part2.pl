#!/usr/bin/perl

use strict;
use warnings;

my @draws = split /,/, <STDIN>;

<STDIN>;

my $cards = [];
my $curr_card = [];

while ( <STDIN> ) {
    chomp;

    if ( $_ eq '') {
        push @$cards, $curr_card;
        $curr_card = [];
        next;
    }

    my $line = [];

    foreach my $num (split / /, $_) {
        next if $num eq '';
        push @$line, int($num);
    }

    push @$curr_card, $line;
}

sub mark_card {
    my $card = shift;
    my $val  = shift;

    my $height = scalar @$card;
    my $width = scalar @{$card->[0]};

    foreach my $row ( 0 .. $height - 1 ) {
        foreach my $col ( 0 .. $width - 1 ) {
            if ( $card->[$row]->[$col] == $val ) {
                $card->[$row]->[$col] *= -1;
            }
        }
    }
}

sub check_card {
    my $card = shift;

    my $height = scalar @$card;
    my $width = scalar @{$card->[0]};

    my @col_score;

    foreach my $row ( 0 .. $height - 1 ) {
        my $row_score = 0;

        foreach my $col ( 0 .. $width - 1 ) {
            my $val = $card->[$row]->[$col];

            if ($card->[$row]->[$col] < 0) {
                ++$row_score;
                ++$col_score[$col];
            }
        }

        return 1 if $row_score == $width;
    }

    foreach (@col_score) {
        next if ! defined $_;
        return 1 if $_ == $height;
    }

    return 0;
}

sub score_card {
    my $card = shift;
    my $draw = shift;

    my $height = scalar @$card;
    my $width = scalar @{$card->[0]};

    my $score = 0;

    foreach my $row ( 0 .. $height - 1 ) {
        foreach my $col ( 0 .. $width - 1 ) {
            my $val = $card->[$row]->[$col];
            $score += $val if $val > 0;
        }
    }

    return $score * $draw;
}

my $win_card = undef;
my $win_draw = undef;

foreach my $draw (@draws) {
    my $new_cards = [];

    foreach my $card (@$cards) {
        mark_card($card, $draw);

        if ( check_card($card) ) {
            $win_card = $card;
            $win_draw = $draw;
        } else {
            push @$new_cards, $card;
        }
    }

    $cards = $new_cards;

    last if scalar @$cards == 1;
}

print score_card($win_card, $win_draw) . "\n";
