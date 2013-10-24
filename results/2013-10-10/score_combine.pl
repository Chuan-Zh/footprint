#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

# combine various scores between two operon, e.g. crs, pcs, in_regulon...

my %all_operon;
my @operons; # keys of %all_operon

my ($raw_zscore, $raw_similarity);

# raw CRS file
my $raw_crs_f = "../../data/2013-09-01/CRS-PCS-score/Ecoli_CRS_original";
($raw_zscore, $raw_similarity) = read_raw_crs($raw_crs_f);

# edge tsv files for zscore and clustering edges score
my $edge_tsv_f_1 = "../2013-09-01/ori/edge_1.tsv";
my $edge_tsv_f_2 = "../2013-09-01/ori/edge_2.tsv";
my $edge_tsv_f_3 = "../2013-09-01/ori/edge_3.tsv";

my ($edge_1, $edge_2, $edge_3);
$edge_1 = read_edge_tsv($edge_tsv_f_1);
#print Dumper $edge_1;
$edge_2 = read_edge_tsv($edge_tsv_f_2);
$edge_3 = read_edge_tsv($edge_tsv_f_3);

# pcs scores
my $pcs_216_f = "../../data/2013-09-10/Ecoli_gene_PCS_216";
my $pcs_all_f = "../../data/2013-09-10/Ecoli_gene_PCS_1286";

my ($pcs_216, $pcs_all);
$pcs_216 = read_pcs($pcs_216_f);
$pcs_all = read_pcs($pcs_all_f);

# hongwei score
my $hw_f = "hongwei_combined_score.tsv";
my $hw_score;
$hw_score = read_hongwei_score($hw_f);


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

## output ##
@operons = sort keys %all_operon;

print "opr1\topr2\traw_crs\tsimilarity\tedge_1\tedge_2\tedge_3\tpcs_216\tpcs_1286\thw_score\tin_regulon\treg_names\n";  # 12 fields
while(my $g2 = pop @operons) { # the last one
    foreach my $g1 (@operons) {
        print "$g1\t$g2\t"; # 1, 2

        if(defined $raw_zscore->{$g1}{$g2}) { # 3, 4
            print "$raw_zscore->{$g1}{$g2}\t$raw_similarity->{$g1}{$g2}\t";
        } else {
            print "NA\tNA\t";
        }

        if(defined $edge_1->{$g1}{$g2}) { # 5
            print "$edge_1->{$g1}{$g2}\t";
        } else {
            print "NA\t";
        }

        if(defined $edge_2->{$g1}{$g2}) { # 6
            print "$edge_2->{$g1}{$g2}\t";
        } else {
            print "NA\t";
        }

        if(defined $edge_3->{$g1}{$g2}) { # 
            print "$edge_3->{$g1}{$g2}\t";
        } else {
            print "NA\t";
        }

        if(defined $pcs_216->{$g1}{$g2}) { # 
            print "$pcs_216->{$g1}{$g2}\t";
        } else {
            print "NA\t";
        }

        if(defined $pcs_all->{$g1}{$g2}) { # 
            print "$pcs_all->{$g1}{$g2}\t";
        } else {
            print "NA\t";
        }

        if(defined $hw_score->{$g1}{$g2}) { # 
            print "$hw_score->{$g1}{$g2}\t";
        } else {
            print "NA\t";
        }

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
}
########### sub ###################
sub read_pcs {
    my $f = pop;
    my $pcs;

    open IN, $f or die "Cannot open $f: $!";

    while(<IN>) {
        chomp;
        my ($opr1, $opr2, $crs) = split;
        next unless $crs ne "";
        my $cnorm = sprintf("%.5f", $crs);

        ($opr1, $opr2) = sort ($opr1, $opr2);

        if(!defined $pcs->{$opr1}{$opr2} || $pcs->{$opr1}{$opr2} < $cnorm) {
            $pcs->{$opr1}{$opr2} = $cnorm;
        }

        $all_operon{$opr1} = 1; # remember operon
        $all_operon{$opr2} = 1;
    }
    close IN;

    return $pcs;
}


sub read_edge_tsv {
    my $f = pop;
    my $raw_zscore;

    open IN, $f or die "Cannot open $f: $!";

    <IN>; # leave the head line

    while(<IN>) {
        chomp;
        my ($opr1, $opr2, $crs, $in, $names) = split;
        next unless $crs ne "";
        my $cnorm = sprintf("%.5f", $crs);

        ($opr1, $opr2) = sort ($opr1, $opr2);

        if(!defined $raw_zscore->{$opr1}{$opr2} || $raw_zscore->{$opr1}{$opr2} < $cnorm) {
            $raw_zscore->{$opr1}{$opr2} = $cnorm;
        }

        $all_operon{$opr1} = 1; # remember operon
        $all_operon{$opr2} = 1;
    }
    close IN;

    return $raw_zscore;
}


sub read_raw_crs {
    my $f = pop;
    my ($raw_zscore, $raw_similarity);
    open IN, $f or die "Cannot open $f: $!";

    <IN>; # leave the head line


    while(<IN>) {
        chomp;
        my ($opr1, $opr2, $in, $size, $sim, $crs) = split;
        next unless $crs ne "";
        my $cnorm = sprintf("%.5f", $crs);

        ($opr1, $opr2) = sort ($opr1, $opr2);

        if(!defined $raw_zscore->{$opr1}{$opr2} || $raw_zscore->{$opr1}{$opr2} < $cnorm) {
            $raw_zscore->{$opr1}{$opr2} = $cnorm;
            $raw_similarity->{$opr1}{$opr2} = $sim;
        }

        $all_operon{$opr1} = 1; # remember operon
        $all_operon{$opr2} = 1;
    }
    close IN;

    return ($raw_zscore, $raw_similarity);
}

sub read_hongwei_score {
    my $f = pop;
    my $score;
    open IN, $f or die "Cannot open $f: $!";

    <IN>; # leave the head line


    while(<IN>) {
        chomp;
        my ($opr1, $opr2, $s) = split;
        next unless $s ne "";
        my $snorm = sprintf("%.5f", $s);

        ($opr1, $opr2) = sort ($opr1, $opr2);

        if(!defined $score->{$opr1}{$opr2} || $score->{$opr1}{$opr2} < $snorm) {
            $score->{$opr1}{$opr2} = $snorm;
        }

        #$all_operon{$opr1} = 1; # remember operon
        #$all_operon{$opr2} = 1;
    }
    close IN;

    return $score;
}

