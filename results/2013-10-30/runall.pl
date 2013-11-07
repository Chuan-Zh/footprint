#!/usr/bin/env perl
#
use strict;
use warnings;

my $d1 = "top_10_cluster";
my $d2 = "top_30_cluster";

my @dirs = ($d1, $d2);

my $cmd;
my @gran = (1.2, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0);

for my $d (@dirs) {
    $cmd = "sed -e '1d' $d/table.tsv | cut -f1,2,4 > $d/table.abc";
    print $cmd, "\n";
    #system $cmd;

    $cmd = "mkdir $d/cluster";
    print $cmd, "\n";
    #system $cmd unless -e "$d/cluster";

    foreach my $gr (@gran) {
        $cmd = "mcl $d/table.abc --abc -I $gr -o $d/cluster/out_I$gr.mcl";
        print $cmd, "\n";
        #system $cmd;

        $cmd = "cat $d/cluster/out_I$gr.mcl | perl count_mcl_cluster_size.pl > $d/cluster/count_I$gr.txt";
        print $cmd, "\n";
        #system $cmd;

        $cmd = "python compare_regulon_cluster.py $d/cluster/out_I$gr.mcl > $d/cluster/stat_I$gr.tsv";
        print $cmd, "\n";
        #system $cmd;

    }
}

print "\n-----------------\n";
# clustering with cutoff
my $sim_cutoff = 0.5;
for my $d (@dirs) {
    $cmd = "sed -e '1d' $d/table.tsv | awk '{if(\$3 > 0.5) print \$_}' | cut -f1,2,4  > $d/table_$sim_cutoff.abc";
    print $cmd, "\n";
    #system $cmd;

    $cmd = "mkdir $d/cluster_sim_$sim_cutoff";
    print $cmd, "\n";
    #system $cmd unless -e "$d/cluster_sim_$sim_cutoff";

    foreach my $gr (@gran) {
        $cmd = "mcl $d/table_$sim_cutoff.abc --abc -I $gr -o $d/cluster_sim_$sim_cutoff/out_I$gr.mcl";
        print $cmd, "\n";
        #system $cmd;

        $cmd = "cat $d/cluster_sim_$sim_cutoff/out_I$gr.mcl | perl count_mcl_cluster_size.pl > $d/cluster_sim_$sim_cutoff/count_I$gr.txt";
        print $cmd, "\n";
        #system $cmd;

        $cmd = "python compare_regulon_cluster.py $d/cluster_sim_$sim_cutoff/out_I$gr.mcl > $d/cluster_sim_$sim_cutoff/stat_I$gr.tsv";
        print $cmd, "\n";
        #system $cmd;

    }
}
