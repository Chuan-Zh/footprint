#!/usr/bin/env perl
#
use strict;
use warnings;

my $data_d = "../../data/2013-10-08/result";

my $ccf1 = "top_20_inter_12_20";
my $motif_count_f1 = "top_20_inter_12_20_motif_count.txt";

my $ccf2 = "top_20_inter_12_20_top_10";
my $motif_count_f2 = "top_20_inter_12_20_top_10_motif_count.txt";

my $output_d1 = "top_30_result";
my $output_d2 = "top_10_result";

mkdir $output_d1 unless -e $output_d1;
mkdir $output_d2 unless -e $output_d2;

my $cmd;
print "perl closurecompare2table.pl $data_d/$ccf1 $data_d/$motif_count_f1 > $output_d1/table.tsv\n";
#system "perl closurecompare2table.pl $data_d/$ccf1 $data_d/$motif_count_f1 > $output_d1/table.tsv";
$cmd = "python motif_graph_refine.py $output_d1/table.tsv -1 -1 > $output_d1/graph_refined.tsv\n";
print $cmd;
#system $cmd;
$cmd = "perl closurecompare2operontable.pl $data_d/$ccf1 $data_d/$motif_count_f1 > $output_d1/operon_table.tsv\n";
print $cmd;
#system $cmd;
$cmd = "python operon_graph_refine.py $output_d1/operon_table.tsv -1 -1 > $output_d1/operon_table_refined.tsv\n";
print $cmd;
#system $cmd;
$cmd = "python operon_graph.py $output_d1/operon_table.tsv -1 -1 > $output_d1/operon_table_stat.tsv\n";
print $cmd;
#system $cmd;

$cmd = "python motif_graph.py $output_d1/table.tsv -1 -1 > $output_d1/motif_graph_stat.tsv\n";
print $cmd;
system $cmd;


print "\n-----------------------------------------\n";

print "perl closurecompare2table.pl $data_d/$ccf2 $data_d/$motif_count_f2 > $output_d2/table.tsv\n";
#system "perl closurecompare2table.pl $data_d/$ccf2 $data_d/$motif_count_f2 > $output_d2/table.tsv";
$cmd = "python motif_graph_refine.py $output_d2/table.tsv -1 -1 > $output_d2/graph_refined.tsv\n";
print $cmd;
#system $cmd;
$cmd = "perl closurecompare2operontable.pl $data_d/$ccf2 $data_d/$motif_count_f2 > $output_d2/operon_table.tsv\n";
print $cmd;
#system $cmd;
$cmd = "python operon_graph_refine.py $output_d2/operon_table.tsv -1 -1 > $output_d2/operon_table_refined.tsv\n";
print $cmd;
#system $cmd;
$cmd = "python operon_graph.py $output_d2/operon_table.tsv -1 -1 > $output_d2/operon_table_stat.tsv\n";
print $cmd;
#system $cmd;

$cmd = "python motif_graph.py $output_d2/table.tsv -1 -1 > $output_d2/motif_graph_stat.tsv\n";
print $cmd;
system $cmd;
