#!/usr/bin/env perl
#
use strict;
use warnings;
use Data::Dumper;

my $line = 0;
while(<>) {
    chomp;
    $line++;
    my $size = split;

    my @motifs = split;

    my %oprs = map { (split(/_/, $_))[0] => 1 } @motifs;
    #print Dumper \%oprs;
    my $opr_size = scalar keys %oprs;
    print "$line\t$size\t$opr_size\n";
}
