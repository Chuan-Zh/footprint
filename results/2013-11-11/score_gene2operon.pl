#!/usr/bin/env perl
#
#transfer hongwei's socre to operon level,
#compute the average score between all pairs of genes from two different operons.
#
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);

# read gene #
my $ptt_file = "../../data/NC_000913.ptt";
my %id2start;
my %id2strand;

open PTT, "$ptt_file" or die "Cannot open $ptt_file: $!";
while(<PTT>) {
  chomp;
  next unless /^([0-9]+)\.\.([0-9]+)\t/;
  my $start = $1;
  my $end = $2;
  my ($start_end, $strand, $length, $PID, $gene, $synonym) = split;

  $id2start{$PID} = $start;
  $id2strand{$PID} = $strand;

#  push @genes, {
#    "start" => $start,
#    "end" => $end,
#    "strand" => $strand,
#    "length" => $length,
#    "PID" => $PID,
#    "gene" => $gene,
#    "synonym" => $synonym,
#  };
}
close PTT;

my $operon_f = "../../data/NC_000913.opr";
my %id2first_gene_in_operon;
my @operons;
open OPR, "$operon_f" or die "Cannot open $operon_f: $!";
while(<OPR>) {
  chomp;
  my @opr = split;
  shift @opr;
  @opr = grep {defined $id2start{$_}} @opr; 
  next if(@opr == 0);
  my $first = first_gene(@opr);
  push @operons, $first;
  foreach (@opr) {
    $id2first_gene_in_operon{$_} = $first;
  }
}
close OPR;

#print Dumper \%id2first_gene_in_operon;

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

# hongwei score
my $hw_f = "combined_score.tsv";
#$hw_f = "hw_test.tsv";

my $hongwei_score;
my $line = 0;
open IN, $hw_f or die "Cannot open $hw_f: $!";

<IN>; # leave the head line

while(<IN>) {
  chomp;
  my ($g1, $g2, $s) = split;
  next unless $s ne "";
  #print "$g1\t$g2\n";
  my $snorm = sprintf("%.5f", $s);
  my ($opr1, $opr2);
  next unless defined $id2first_gene_in_operon{$g1};
  next unless defined $id2first_gene_in_operon{$g2};
  $line++;
  $opr1 = $id2first_gene_in_operon{$g1};
  $opr2 = $id2first_gene_in_operon{$g2};
  next if $opr1 eq $opr2;

  ($opr1, $opr2) = sort ($opr1, $opr2);
  push @{$hongwei_score->{$opr1}{$opr2}}, $snorm;

  #if(!defined $score->{$opr1}{$opr2} || $score->{$opr1}{$opr2} < $snorm) {
  #$score->{$opr1}{$opr2} = $snorm;
  #}

  #$all_operon{$opr1} = 1; # remember operon
  #$all_operon{$opr2} = 1;
}
close IN;
print STDERR "$line\n";
#print Dumper $hongwei_score;

print "opr1\topr2\thw_score\tin_regulon\treg_names\n";
foreach my $opr1 (keys %{$hongwei_score}) {
  foreach my $opr2 (keys %{$hongwei_score->{$opr1}}) {
    my @values = @{$hongwei_score->{$opr1}{$opr2}};
    my $average = sum(@values) / (scalar @values);
    print "$opr1\t$opr2\t$average\t";

    if(defined $pairGeneInRegulon->{$opr1}{$opr2}) {
      my $num = $pairGeneInRegulon->{$opr1}{$opr2};
      my $reg = $pairGeneInRegulonName->{$opr1}{$opr2};

      print "$num\t$reg\n";
    } else {
      print "0\t-\n";
    }
  }
}


###################################### sub ##################################
sub first_gene {
  # this sub return the first gene of an operon with the asumation that
  # all genes are on the same chain
  my @genes = @_;

  if(@genes == 1) {
    return $genes[0];
  }

  @genes = sort { $id2start{$a} <=> $id2start{$b} } @genes;
  my $chain = $id2strand{$genes[0]};
  if($chain eq '+') {
    return shift @genes;
  } else {
    return pop @genes;
  }
}

