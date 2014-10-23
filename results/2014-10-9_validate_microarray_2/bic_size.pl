#!/usr/bin/perl
#pickout the bicluster sizes for qubic results
use strict;
use warnings;


while(<>) {
  chomp;
  if (/Genes\s+\[([0-9]+)\]:/) {
    print $1, "\n";
  }
}

