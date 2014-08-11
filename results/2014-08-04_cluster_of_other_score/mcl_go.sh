#!/usr/bin/env bash

### MCL seem doesnot work on gfr and pcs ###
#gfr has a minimum -6.07311
# after add 6.074, gfr has average 5.8443
# 3rd Qu.: 6.28393
#sed '1d' gfr.tsv | cut -f1,2,3  \
#| awk '{print $1, $2, $3+6.074}' \
#| awk '{if($3 > 6.28393) print $0}' \
#| tr ' ' '\t' > gfr.abc
##| awk '{if($3 > 5.8443) print $0}' \
#
#mcl gfr.abc --abc -I 2.0
#mcl gfr.abc --abc -I 4.0
#mcl gfr.abc --abc -I 1.0

#pcs has a minimum of -0.03393
# after add 0.034, pcs has average 0.03432
# 3rd Qu.: 0.03756
#sed '1d' pcs.tsv | cut -f1,2,3  \
#|awk '{print $1, $2, $3+0.034}'  \
#|awk '{if($3 > 0.03756) print $0}'  \
#| tr ' ' '\t' > pcs.abc
##|awk '{if($3 > 0.03432) print $0}'  \

#mcl pcs.abc --abc -I 2.0
#mcl pcs.abc --abc -I 3.5
#mcl pcs.abc --abc -I 4.0
#mcl pcs.abc --abc -I 1.0
