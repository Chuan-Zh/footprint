#!/usr/bin/perl
#
use strict;
use warnings;

my $f = $ARGV[0];
open IN, $f or die "Cannot open $f: $!";
while(<IN>) {
  chomp;
  next unless s/^>//;
  s/NC_/NC/;
  s/_/\t/g;
  s/NC/NC_/;
  
  print $f, "\t", $_, "\n";
}
close IN;

  
