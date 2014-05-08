#!/usr/bin/env perl
# Transfer a BBC cluster file to mcl format

while(<>) {
  chomp;
  if (/Cluster.*:\t(.*)/) {
    print $1, "\n";
  }
}






