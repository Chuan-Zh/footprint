#!/usr/bin/env perl
# Get the subgraph of operons in known regulon
use strict;
use warnings;

my $reg_f = "regulon_by_first_gene.txt";

my %nodes;
open IN, $reg_f or die;
while(<IN>) {
  chomp;
  next if />/;
  my @items = split(/ /, $_);
  for my $g (@items) {
    $nodes{$g} = 1;
  }
}
close IN;

my $total = scalar(keys %nodes);
print "Totally $total gi\n";
exit;
my $graph_f = "filtered_graph_top_20_inter_12-20_top_10_motif.tsv";
open IN, $graph_f or die;
while(<IN>) {
  chomp;
  my @items = split(/\t/, $_);
  $items[0] =~ /^([0-9]+)_/;
  next unless defined $nodes{$1};
  $items[1] =~ /^([0-9]+)_/;
  next unless defined $nodes{$1};

  print $_, "\n";
}
close IN;



