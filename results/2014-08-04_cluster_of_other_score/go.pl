#!/usr/bin/env perl
#
use File::Basename;
use strict;
use warnings;

my $score_d = "gfr_pcs_score";

my @cluster_f = glob "$score_d/*.clusters";

foreach my $f (@cluster_f) {
  my $out = $f;
  $out =~ s/abc\.clusters/mcl/;
  my $score = substr(basename($out), 0, 3);

  my $cmd = "cat $f | perl bbc2mcl.pl > $out";
  print $cmd, "\n";
  system $cmd;

  $cmd = "python compare_regulon_cluster.py $out > $score\_cluster_vs_regulon.tsv";
  print $cmd, "\n";
  system $cmd;

}
my $cmd = "python compare_regulon_cluster.py bbs_cluster.mcl > bbs_cluster_vs_regulon.tsv";
print $cmd, "\n";
system $cmd;

$cmd = "python compare_regulon_cluster.py edge_1_300.mcl > crs_cluster_vs_regulon.tsv";
print $cmd, "\n";
system $cmd;

## The result files are moved to stat ###
