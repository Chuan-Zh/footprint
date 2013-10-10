#!/usr/bin/env perl
#
# convert closure comparing results to table
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

print "opr1_motif\topr2_motif\tsimilarity\tzscore\tin_regulon\tin_regulon_name\n";
open IN, "$compare_f" or die "Cannot open $compare_f: $!";
while(<IN>) {
    chomp;
    next unless s/^>CombinedClosure-//;
    #">CombinedClosure-18-90111741-16128224-6-29-0.38-15.12-000913--1"
    my ($size, $opr1, $opr2, $m1, $m2, $sim, $zscore) = split(/-/, $_);
    
    next if $opr1 eq $opr2; # some kind of error in closure compare results
    next if !defined $zscore;

    $m2 -= $mc{$opr1};

    print "$opr1\_$m1\t$opr2\_$m2\t$sim\t$zscore\t";

    my ($g1, $g2) = sort ($opr1, $opr2);

    if(defined $pairGeneInRegulon->{$g1}{$g2}) { # 
        print "$pairGeneInRegulon->{$g1}{$g2}\t";
    } else {
        print "0\t";
    }

    if(defined $pairGeneInRegulonName->{$g1}{$g2}) {
        print "$pairGeneInRegulonName->{$g1}{$g2}\t";
    } else {
        print "-\t";
    }

    print "\n";
}
close IN;






