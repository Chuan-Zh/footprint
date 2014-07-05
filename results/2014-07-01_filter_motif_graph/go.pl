# basic steps
#perl bobro2alignment.pl 49176004.closures > align.txt
#./BBS -i NC_000913_len50.prt -j align.txt -z NC_000913.fna
#cat NC_000913_len50.prt_align.txt.motifinfo | perl parse_bbs_result.pl

#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

my $clos_d = "top_20_inter_12_20_top_10";
my @files = glob "$clos_d/*";
my $bbs_d = "bbs_results";

foreach my $f (@files) {
#  print $f, "\n";
  $f =~/([0-9]+)\.closures/;
  my $gi = $1;
#  print $gi, "\n";
  my $cmd = "perl bobro2alignment.pl $f > $bbs_d/$gi.align";
  #print $cmd, "\n";
  #system $cmd;

  $cmd = "cd $bbs_d; ../BBS -i NC_000913_len50.prt -j $gi.align -z NC_000913.fna; cd ../";
  #print $cmd, "\n";
  #system $cmd;
}

my $cmd = "echo -e \"motif\\tpvalue\\tzscore\\tenrichment\\n\" > bbs_motif_scan.tsv ;\nfor i in $bbs_d/*.motifinfo; do cat \$i | perl parse_bbs_result.pl >> bbs_motif_scan.tsv; done;";
print $cmd;
