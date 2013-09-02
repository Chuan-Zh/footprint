#!/usr/bin/env perl
#
use strict;
use warnings;
use FindBin qw($Bin);

die "Transfer a bcluster output edge file to a tsv format\nperl $0 <Bcluster edge file>" unless @ARGV == 1;
my $regulon_f = "$Bin/../data/regulon_by_first_gene.txt";
my $edge_f = pop;

my %pairGeneInRegulon;
my %pairGeneInRegulonName;

my $reg_now;
open REG, "$regulon_f" or die "Cannot open $regulon_f: $!";
while(<REG>) {
    chomp;
    if(s/>//) {
        $reg_now = $_;
    } else {
        s/^ //;
        my @gs = split;
        next if @gs < 2;

        while(my $g1 = pop @gs) {
            foreach my $g2 (@gs) {
                $pairGeneInRegulon{"$g1\_$g2"} += 1;
                $pairGeneInRegulon{"$g2\_$g1"} += 1;

                $pairGeneInRegulonName{"$g1\_$g2"} .= "_$reg_now";
                $pairGeneInRegulonName{"$g2\_$g1"} .= "_$reg_now";
            }
        }

    }
}
close REG;

print "gi1\tgi2\tzscore\tin_regulon\tnames\n";
open EDG, "$edge_f" or die "Cannot open $edge_f: $!";
while(<EDG>) {
    chomp;
    /([0-9\.]+)\s+([0-9]+)_([0-9]+)$/;
    my ($zscore, $g1, $g2) = ($1, $2, $3);

    if(defined $pairGeneInRegulon{"$g1\_$g2"}) {
        my $s = $pairGeneInRegulon{"$g1\_$g2"};
        my $name = $pairGeneInRegulonName{"$g1\_$g2"};

        print "$g1\t$g2\t$zscore\t$s\t$name\n";
    } else {
        print "$g1\t$g2\t$zscore\t0\t-\n";
    }
}
close EDG;

