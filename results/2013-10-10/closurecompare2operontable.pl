#!/usr/bin/env perl
#
# convert closure comparing results to table, each line is an edge between two operons,
# which is named operon graph, and records the edge multiplicity (since there maybe 
# several similarity motif pairs between two operon), also the largest zscore and 
# corresponding similarity score.
#

use strict;
use warnings;

die "perl $0 closure_compare_file motif_count_file > output_table_file" unless @ARGV == 2;

my $compare_f = $ARGV[0];
my $motif_count_file = $ARGV[1];

# read regulon file
my $regulon_f = "../../data/regulon_by_first_gene.txt";

my $pairGeneInRegulon;
my $pairGeneInRegulonName;

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

        @gs = sort @gs;

        while(my $g2 = pop @gs) { # the last one
            foreach my $g1 (@gs) {
                $pairGeneInRegulon->{$g1}{$g2} += 1;
                $pairGeneInRegulonName->{$g1}{$g2} .= "_$reg_now";
            }
        }
    }
}
close REG;


my %mc;
open IN, "$motif_count_file" or die "Cannot open $motif_count_file: $!";
while(<IN>) {
    chomp;
    my ($gi, $count) = split;
    $gi =~ s/\.closures//;
    $mc{$gi} = $count;
}
close IN;

my (%pair2zscore, %pair2sim, %pair2multiplicity);

open IN, "$compare_f" or die "Cannot open $compare_f: $!";
while(<IN>) {
    chomp;
    next unless s/^>CombinedClosure-//;
    #">CombinedClosure-18-90111741-16128224-6-29-0.38-15.12-000913--1"
    my ($size, $opr1, $opr2, $m1, $m2, $sim, $zscore) = split(/-/, $_);
    
    next if $opr1 eq $opr2; # some kind of error in closure compare results
    next if $zscore eq '';
    next if $sim eq '';

    $m2 -= $mc{$opr1};
    next if $m2 < 1;


    my ($g1, $g2) = sort ($opr1, $opr2);
    my $pair = "$g1\_$g2";

    if(defined $pair2zscore{$pair} and $pair2zscore{$pair} > $zscore) {
        $pair2multiplicity{$pair}++;
    } else {
        $pair2multiplicity{$pair}++;

        $pair2zscore{$pair} = $zscore;
        $pair2sim{$pair} = $sim;
    }



}
close IN;


print "opr1\topr2\tsimilarity\tzscore\tmultiplicity\tin_regulon\tin_regulon_name\n";

for my $pair (keys %pair2multiplicity) {
    my ($g1, $g2) = split(/_/, $pair);

    my $sim = $pair2sim{$pair};
    my $zscore = $pair2zscore{$pair};
    my $multiplicity = $pair2multiplicity{$pair};

    print "$g1\t$g2\t$sim\t$zscore\t$multiplicity\t";

    if(defined $pairGeneInRegulon->{$g1}{$g2}) { # 
        print "$pairGeneInRegulon->{$g1}{$g2}\t";
    } else {
        print "0\t";
    }

    if(defined $pairGeneInRegulonName->{$g1}{$g2}) {
        print "$pairGeneInRegulonName->{$g1}{$g2}";
    } else {
        print "-";
    }

    print "\n";
}




