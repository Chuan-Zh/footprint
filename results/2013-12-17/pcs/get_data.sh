#cut -f1,2,8,9,11,12 ../../2013-09-10/data_update.tsv | awk '{if($3 != "NA" && $4 != "NA") print $_}' > pcs.tsv

awk '{if($3 != "NA" && $8 != "NA" && $9 != "NA") print $_}' ../../2013-09-10/data_update.tsv| cut -f1,2,8,9,11,12 > pcs.tsv
