#!/usr/bin/env perl
#
use strict;
use warnings;

my $exp_d = "co-expression-validation-09072014";
my @exp_fs = glob "$exp_d/*";
my @clu_fs = glob "*.mcl";

my $cmd;

foreach my $exp_f (@exp_fs) {
  $exp_f =~ /avg_E_coli_v4_Build_6_exps466probes4297\.tab\.blocks\.(.*)/;
  my $exp_type = $1;

  foreach my $clu_f (@clu_fs) {
    $clu_f =~ /(.*)\.mcl/;
    my $clu_type = $1;

    $cmd = "python bicluster_validation.py $exp_f $clu_f $exp_type $clu_type >> validation.tsv";
    print "$cmd\n";
    system $cmd;
  }
}


#foreach my $exp_f (@exp_fs) {
#  $exp_f =~ /avg_E_coli_v4_Build_6_exps466probes4297\.tab\.blocks\.(.*)/;
#  my $exp_type = $1;
#
#  foreach my $clu_f (@clu_fs) {
#    $clu_f =~ /(.*)\.mcl/;
#    my $clu_type = $1;
#
#    $cmd = "python bicluster_validation_opr_level.py $exp_f $clu_f $exp_type $clu_type >> validation_opr_level.tsv";
#    print "$cmd\n";
#    system $cmd;
#  }
#}




