#!/usr/bin/perl
#
#File: bobro2alignment.pl
#Description: Transfer a bobro output closures file to a motif sequence alignment
#

use strict;
use warnings;
use Data::Dumper;
use File::Basename;

sub manual {
    print "Transfer a bobro output closures file to a motif sequence alignment\
    Usage:\
    perl bobro2alignment.pl <bobro_closure_file>...\
    write standard output\n";
    die;
}

manual unless exists $ARGV[0];

my $cutoff = 30;
my $file;
my $motif_id;  # use file_num as the motif id
#my %pos_weight_matrix;
my @aligned_motif;
my $motif_flag = 0;

my @files = @ARGV;
foreach (@files) {
    open IN, "$_" or die "Cannot open $_: $!";
    while(<IN>) {
	chomp;
	if(/Datafile:/) {
	    my ($kk, $filename) = split;
	    $file = basename($filename);
#	print "$file\n";
	} elsif (/Candidate Motif\s*([0-9]+)$/) { # a new motif found
	    my $num = $1;
	    last if ($num > $cutoff); # set $cutoff if we don't need all motif
	    conditional_motif_output();
	    $motif_id = "$file\-$num";
	    #print "$motif_id\n";
	} elsif (/Aligned Motif/) { # turn on the flag for reading a motif
	    $motif_flag = 1;
	} elsif ($motif_flag) {
	    if (/^#Seq/) {
		next;
	    } elsif (/---------------/) {
		$motif_flag = 0; # turn off 
	    } else {
		my $seq = (split)[2];
		push @aligned_motif, $seq;
	    }
	} else {
	    next;
	}
    }
    conditional_motif_output(); # check if there is a unprinted motif 
    close IN;
}

print ">end\n"; # print end when all file are processed

sub conditional_motif_output {
    if($motif_id and @aligned_motif) {
	print ">$motif_id\n";
	print map { "$_\n" } @aligned_motif;
	$motif_id = '';
	@aligned_motif = ();
    }
}


