#!/usr/bin/env perl
#
use strict;
use warnings;

my $run = 1;

my $crs_d = "../../data/2013-09-01/CRS-PCS-score";
my $bin_d = "../../bin";


my @edge_ori = qw/
Ecoli_CRS_original.matrix.edges.1
Ecoli_CRS_original.matrix.edges.2
Ecoli_CRS_original.matrix.edges.3/;

my @edge_cut = qw/
Ecoli_sim_0.39_pcs_1286.tsv.CRS.edges.1
Ecoli_sim_0.39_pcs_1286.tsv.CRS.edges.2
Ecoli_sim_0.39_pcs_1286.tsv.CRS.edges.3/;

mkdir 'ori' unless -e 'ori';
mkdir 'sim_cut' unless -e 'sim_cut';

my $cmd;
for my $i (1..3) {
    $cmd = "perl $bin_d/edges2table.pl $crs_d/$edge_ori[$i-1] > ori/edge_$i.tsv";
    print $cmd, "\n";
    system($cmd) if ($run and !-e "ori/edge_$i.tsv");

    $cmd = "python $bin_d/regulon_subgraph.py ori/edge_$i.tsv > ori/edge_$i.stat";
    print $cmd, "\n";
    system($cmd) if $run;
}

for my $i (1..3) {
    $cmd = "perl $bin_d/edges2table.pl $crs_d/$edge_cut[$i-1] > sim_cut/edge_$i.tsv";
    print $cmd, "\n";
    system($cmd) if ($run and !-e "ori/edge_$i.tsv");

    $cmd = "python $bin_d/regulon_subgraph.py sim_cut/edge_$i.tsv > sim_cut/edge_$i.stat";
    print $cmd, "\n";
    system($cmd) if $run;
}


    



