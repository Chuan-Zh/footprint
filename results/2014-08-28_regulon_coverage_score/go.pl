#!/usr/bin/env perl
#
use strict;
use warnings;
use File::Basename;

my @scores = glob("*.mcl");

my $cmd;
foreach my $s (@scores) {
  my $name = basename($s, ".mcl");
  $cmd = "python regulon_coverage_score.py $s > rcs_$name.tsv\n";
  print $cmd;
  system $cmd;
}




