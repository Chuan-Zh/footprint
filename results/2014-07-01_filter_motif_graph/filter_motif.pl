#!/usr/bin/env perl
# filter out motifs don't contains sites from E.coli
use strict;
use warnings;
use Data::Dumper;

my $clos_d = "top_20_inter_12_20_top_10";
my @files = glob "$clos_d/*";
#@files = ("49176004.closures");

my $graph_f = "top_20_inter_12-20_top_10_motif.tsv";

# motif id is gi_order, like 96139161_2
# record the motifs that contain a site in Ecoli
my %keeped_motif;

foreach my $f (@files) {
#  print $f, "\n";
  $f =~/([0-9]+)\.closures/;
  my $gi = $1;
#  print $gi, "\n";
  my $now = 0;
  open IN, $f or die "Cannot open $f: $!";
  while(<IN>) {
    chomp;
    if(/Candidate Motif\s+([0-9]+)$/) {
      $now = $1;
    } elsif(/^1\t/) {
      if($now != 0) {
        $keeped_motif{"$gi\_$now"} = 1;
      }
    } else {
      next;
    }
  }
  close IN;
}
#print Dumper \%keeped_motif;

my $bbs_result_f = "bbs_motif_scan.tsv";
my %motif_zscore;
my %motif_pvalue;
my %motif_enrich;
open IN, $bbs_result_f or die "Cannot open $bbs_result_f: $!";
my $fl = <IN>;

while(<IN>) {
  chomp;
  my @it = split(/\t/, $_);
  $motif_pvalue{$it[0]} = $it[1];
  $motif_zscore{$it[0]} = $it[2];
  $motif_enrich{$it[0]} = $it[3];
}
close IN;


open IN, $graph_f or die "Cannot open $graph_f: $!";
my $fisrt_line = <IN>;
while(<IN>) {
  chomp;
  my @items = split(/\t/, $_);
  #print $items[0], "\n";
  # require both motif contains sites from E.coli
  if(defined $keeped_motif{$items[0]} and defined $keeped_motif{$items[1]}
      and $motif_pvalue{$items[0]} < 1e-5 and $motif_pvalue{$items[1]} < 1e-5) {
    print $_, "\n";
  }
}
close IN;

