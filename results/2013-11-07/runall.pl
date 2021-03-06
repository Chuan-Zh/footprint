#!/usr/bin/env perl
#
use strict;
use warnings;

my $top_10_motif_graph_f = "../2013-10-10/top_10_result/table.tsv";
my $top_10_operon_graph_f = "../2013-10-10/top_10_result/operon_table.tsv";

my $top_30_motif_graph_f = "../2013-10-10/top_30_result/table.tsv";
my $top_30_operon_graph_f = "../2013-10-10/top_30_result/operon_table.tsv";

my $output_d1 = "top_10_result";
my $output_d2 = "top_30_result";

mkdir $output_d1 unless -e $output_d1;
mkdir $output_d2 unless -e $output_d2;

my $cmd;
my @similarity_cut = (0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9);
my $zscore_cut = -1;

for my $sim_cut (@similarity_cut) {

  print "\n-----------------------------------------\n";

  $cmd = "python operon_graph.py $top_10_operon_graph_f $sim_cut $zscore_cut > $output_d1/operon_table_stat_$sim_cut.tsv\n";
  print $cmd;
  system $cmd;

  $cmd = "python motif_graph.py $top_10_motif_graph_f $sim_cut $zscore_cut > $output_d1/motif_graph_stat_$sim_cut.tsv\n";
  print $cmd;
  system $cmd;


  print "\n-----------------------------------------\n";

  $cmd = "python operon_graph.py $top_30_operon_graph_f $sim_cut $zscore_cut > $output_d2/operon_table_stat_$sim_cut.tsv\n";
  print $cmd;
  system $cmd;

  $cmd = "python motif_graph.py $top_30_motif_graph_f $sim_cut $zscore_cut > $output_d2/motif_graph_stat_$sim_cut.tsv\n";
  print $cmd;
  system $cmd;
}
