#!/usr/bin/env perl
#
use strict;
use warnings;

my $graph_f = "filtered_graph_top_20_inter_12-20_top_10_motif.tsv";
my $d = "mcl_cluster_z8_s.3";
$d = "mcl_cluster_z8_s.5";

my $cmd;
my @gran = (1.2, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0);
$cmd = "mkdir $d";
print $cmd;
system $cmd unless -e $d;

$cmd = "awk '{if(\$3>0.5 && \$4 > 8) print \$_}' $graph_f | cut -f1,2,4 > $d/table.abc";
print $cmd, "\n";
system $cmd;


foreach my $gr (@gran) {
  $cmd = "mcl $d/table.abc --abc -I $gr -o $d/out_I$gr.mcl";
  print $cmd, "\n";
  system $cmd;

  $cmd = "cat $d/out_I$gr.mcl | perl count_mcl_cluster_size.pl > $d/count_I$gr.txt";
  print $cmd, "\n";
  system $cmd;

  $cmd = "python compare_regulon_cluster.py $d/out_I$gr.mcl > $d/stat_I$gr.tsv";
  print $cmd, "\n";
  system $cmd;

}
exit;

#print "\n-----------------\n";
## clustering with cutoff
#my $sim_cutoff = 0.5;
#for my $d (@dirs) {
#    $cmd = "sed -e '1d' $d/table.tsv | awk '{if(\$3 > 0.5) print \$_}' | cut -f1,2,4  > $d/table_$sim_cutoff.abc";
#    print $cmd, "\n";
#    #system $cmd;
#
#    $cmd = "mkdir $d/cluster_sim_$sim_cutoff";
#    print $cmd, "\n";
#    #system $cmd unless -e "$d/cluster_sim_$sim_cutoff";
#
#    foreach my $gr (@gran) {
#        $cmd = "mcl $d/table_$sim_cutoff.abc --abc -I $gr -o $d/cluster_sim_$sim_cutoff/out_I$gr.mcl";
#        print $cmd, "\n";
#        #system $cmd;
#
#        $cmd = "cat $d/cluster_sim_$sim_cutoff/out_I$gr.mcl | perl count_mcl_cluster_size.pl > $d/cluster_sim_$sim_cutoff/count_I$gr.txt";
#        print $cmd, "\n";
#        #system $cmd;
#
#        $cmd = "python compare_regulon_cluster.py $d/cluster_sim_$sim_cutoff/out_I$gr.mcl > $d/cluster_sim_$sim_cutoff/stat_I$gr.tsv";
#        print $cmd, "\n";
#        #system $cmd;
#
#    }
#}
