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

my $no_index_input_d = "./without-index";
my $no_index_output_d = "./without_index_cluster_vs_regulon";

opendir IN, $no_index_input_d or die;
while(my $f = readdir IN) {
  if($f =~ /^edge/) {
    #print "$f\n";
    my $cmd = "cat $no_index_input_d/$f | perl bbc2mcl.pl > $no_index_input_d/$f.mcl";
    print $cmd, "\n";
    system $cmd;

    $cmd = "python compare_regulon_cluster.py $no_index_input_d/$f.mcl > $no_index_output_d/$f.tsv";
    print $cmd;
    system $cmd;
  }
}
closedir IN;

my $with_index_input_d = "./with-index";
my $with_index_output_d = "./with_index_cluster_vs_regulon";

opendir IN, $with_index_input_d or die;
while(my $f = readdir IN) {
  if($f =~ /^edge/) {
    #print "$f\n";
    my $cmd = "cat $with_index_input_d/$f | perl bbc2mcl.pl > $with_index_input_d/$f.mcl";
    print $cmd, "\n";
    system $cmd;

    $cmd = "python compare_regulon_cluster.py $with_index_input_d/$f.mcl > $with_index_output_d/$f.tsv";
    print $cmd;
    system $cmd;
  }
}
closedir IN;
