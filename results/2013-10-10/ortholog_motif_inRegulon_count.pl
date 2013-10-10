#!/usr/bin/env perl
# For each gene, this count the ortholog number in the 216 reference, the motifs found when
# this gene is a leading gene in operon, and how many times this operon apper in regulon
use strict;
use warnings;

my $orth_f = "../../data/ortholog_raw/ortholog_gene_count_216.tsv";
my $motif_count_file_1 = "../../data/2013-10-08/result/top_20_inter_12_20_motif_count.txt";
my $motif_count_file_2 = "../../data/2013-10-08/result/top_20_inter_12_20_top_10_motif_count.txt";
my $opr_ortholog_count_file = "../../data/2013-10-08/result/ortholog_opr_number.txt";

my %orth_opr;
open IN, "$opr_ortholog_count_file" or die "Cannot open $opr_ortholog_count_file: $!";
while(<IN>) {
    chomp;
    s/^\s+//;
    my ($g, $c) = split;
    $orth_opr{$g} = $c;
}
close IN;


my %orth;
open IN, "$orth_f" or die "Cannot open $orth_f: $!";
while(<IN>) {
    chomp;
    s/^\s+//;
    my ($c, $g) = split;
    $orth{$g} = $c;
}
close IN;

my %mc1;
open IN, "$motif_count_file_1" or die "Cannot open $motif_count_file_1: $!";
while(<IN>) {
    chomp;
    my ($gi, $count) = split;
    $gi =~ s/\.closures//;
    $mc1{$gi} = $count;
}
close IN;

my %mc2;
open IN, "$motif_count_file_2" or die "Cannot open $motif_count_file_2: $!";
while(<IN>) {
    chomp;
    my ($gi, $count) = split;
    $gi =~ s/\.closures//;
    $mc2{$gi} = $count;
}
close IN;

# read regulon file
my $regulon_f = "../../data/regulon_by_first_gene.txt";

my $pairGeneInRegulon;
my $pairGeneInRegulonName;

my %inRegTime;
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
        foreach (@gs) {
            $inRegTime{$_}++;
        }

        #while(my $g2 = pop @gs) { # the last one
        #    foreach my $g1 (@gs) {
        #        $pairGeneInRegulon->{$g1}{$g2} += 1;
        #        $pairGeneInRegulonName->{$g1}{$g2} .= "_$reg_now";
        #    }
        #}
    }
}
close REG;

print "gi\tortholog\tortholog_opr\ttop_30_motif\ttop_10_motif\tinRegTime\n";
foreach (keys %mc1) {
    print "$_\t";
    if(defined $orth{$_}) {
        print $orth{$_};
    } else {print 0};
    print "\t";

    if(defined $orth_opr{$_}) {
        print $orth_opr{$_};
    } else {print 0};

    print "\t";
    print $mc1{$_};
    print "\t";
    if(defined $mc2{$_}) {
        print $mc2{$_}; 
    } else { print 0; }
    print "\t";

    if(defined $inRegTime{$_}) {
        print $inRegTime{$_};
    } else { print 0; }

    print "\n";
}
