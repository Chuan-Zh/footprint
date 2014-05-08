#!/usr/bin/env perl
#
use strict;
use warnings;

my $mcl_input_d = "./MCL";
my $mcl_output_d = "./mcl_cluster_vs_regulon";

opendir IN, $mcl_input_d or die;
while(my $f = readdir IN) {
  if($f =~ /^edge/) {
    #print "$f\n";
    my $cmd = "python compare_regulon_cluster.py $mcl_input_d/$f > $mcl_output_d/$f.tsv";
    print $cmd;
    system $cmd;
  }
}

closedir IN;
