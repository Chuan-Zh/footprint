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

system "perl closurecompare2table.pl $data_d/$ccf1 $data_d/$motif_count_f1 > $output_d1/table.tsv";
system "perl closurecompare2table.pl $data_d/$ccf2 $data_d/$motif_count_f2 > $output_d2/table.tsv";
