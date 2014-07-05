#!/usr/bin/env perl
#parse BBS output file to motif characteristic tsv file
#
use strict;
use warnings;
use Data::Dumper;

my $info;
my $motif_now;
while(<>) {
  chomp;
  if(/Zscore:\s+(.*)$/) {
    $info->{$motif_now}{'zscore'} = $1;
  } elsif(/Enrichment:\s+(.*)$/) {
    $info->{$motif_now}{'enrichment'} = $1;
  } elsif (/Pvalue:\s+(.*)$/) {
    $info->{$motif_now}{'pvalue'} = $1;
  } elsif (/Consensus:\s+(.*)$/) {
    $info->{$motif_now}{'consensus'} = $1;
  } elsif (/Motif length:\s+(.*)$/) {
    $info->{$motif_now}{'length'} = $1;
  } elsif (/Binding sites number:\s+(.*)$/) {
    $info->{$motif_now}{'number'} = $1;
  } elsif (/^\s+([0-9]+-[0-9]+)$/) {
    $motif_now = $1;
  } else {
    next;
  }
}
#print Dumper $info;

for my $m (keys %{$info}) {
  my $name = $m;
  $name =~ s/-/_/;
  print $name, "\t";
  print $info->{$m}{'pvalue'}, "\t";
  print $info->{$m}{'zscore'}, "\t";
  print $info->{$m}{'enrichment'}, "\n";
}


