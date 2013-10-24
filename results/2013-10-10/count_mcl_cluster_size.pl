#!/usr/bin/env perl
#
use strict;
use warnings;

my $line = 0;
while(<>) {
    chomp;
    $line++;
    my @all = split;
    my $size = $#all + 1;

    my %uniq;
    foreach (@all) {
        my ($opr, $m) = split(/_/, $_);
        $uniq{$opr}++;
    }

    my $opr_num = keys %uniq;
    
    print "$line\t$size\t$opr_num\n";
}
