#!/usr/bin/env perl
# summary various properties of a gene in Ecoli
use strict;
use warnings;
use Data::Dumper;

my $orth_f = "ortholog_gene_count_216.tsv";
my $opr_f = "regulonDB/OperonSet.txt";
my $tf_gene_f = "regulonDB/network_tf_gene.txt";

my $ptt_file = "../../data/NC_000913.ptt";
my %id2start;
my %id2strand;
my %id2name;
my %name2id;

open PTT, "$ptt_file" or die "Cannot open $ptt_file: $!";
while(<PTT>) {
  chomp;
  next unless /^([0-9]+)\.\.([0-9]+)\t/;
  my $start = $1;
  my $end = $2;
  my ($start_end, $strand, $length, $PID, $gene, $synonym) = split;

  $id2start{$PID} = $start;
  $id2strand{$PID} = $strand;
  $id2name{$PID} = $gene;
  $name2id{$gene} = $PID;

}
close PTT;

my %id2orth_count;
open ORTH, "$orth_f" or die "Cannot open $orth_f: $!";
while(<ORTH>) {
  chomp;
  s/^\s+//;
  my ($c, $id) = split();
  $id2orth_count{$id} = int($c);
}
close ORTH;


my %id2first_gene_in_operon;
my @operons;

my %is_leading_gene;
open OPR, "$opr_f" or die "Cannot open $opr_f: $!";
while(<OPR>) {
  chomp;
  next if /#/ or /^$/;

  my ($name, $strand, $count, $gs) = split();
  my @genes = split(/,/, $gs);

  my $all_found = 1;
  foreach my $g (@genes) {
    if(!defined $name2id{$g}) {
      $all_found = 0;
    }
  }
  next unless $all_found;

  @genes = map {$name2id{$_}} @genes;

  my $first = first_gene(@genes);
  $is_leading_gene{$first} = 1;
}
close OPR;

my %gene_under_regulon_time;
my $gene_under_regulon_tfs;
open REG, "$tf_gene_f" or die "Cannot open $tf_gene_f: $!";
while(<REG>) {
  chomp;
  next if /#/ or /^$/;
  my ($tf, $g) = split();
  next unless defined $name2id{$g};
  $g = $name2id{$g};
  $gene_under_regulon_time{$g} += 1;
  push @{$gene_under_regulon_tfs->{$g}}, $tf;
}
close REG;

foreach (keys %id2name) {
  $id2orth_count{$_} = 0 unless defined $id2orth_count{$_};
  $is_leading_gene{$_} = 0 unless defined $is_leading_gene{$_};
  $gene_under_regulon_time{$_} = 0 unless defined $gene_under_regulon_time{$_};
}

#print Dumper \%id2orth_count;
#print Dumper \%is_leading_gene;
#print Dumper \%gene_under_regulon_time;

print "gene\tortholog_num\tis_leading_gene\tunder_reg_time\tunder_reg_tfbs\n";
foreach (keys %id2name) {
  print "$_\t";
  print "$id2orth_count{$_}\t";
  print "$is_leading_gene{$_}\t";
  print "$gene_under_regulon_time{$_}\t";

  my $p = '-';
  if($gene_under_regulon_time{$_} > 0) {
     $p = join ",", @{$gene_under_regulon_tfs->{$_}};
  }
  print "$p\n";
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

