#!/usr/bin/env R

countInRegulonEdge <- function(data) {
  rv = list() 
  d <- data[ data$in_regulon > 0, ]
  rv$inRegulonEdge <- nrow(d)

  rv$regulon <- length(table(strsplit(paste(d$reg_names, collapse=''), '_'))) - 1

  return(rv)
}

dd= read.table("hongwei_socre_operon_level_direct.tsv", header=TRUE)

top_operon_cmb_score <- countInRegulonEdge(dd[ order(dd$hw_score, decreasing=TRUE)[1:1000], ])
top_operon_cmb_score
#$inRegulonEdge
#[1] 66
#
#$regulon
#[1] 16


dim(dd)
#[1] 922761      5

# after single analysis for top 1000 edges, do same thing for different steps from 100 to 2000
step = 1:20
step = step*100

inRegEdge = array(dim=length(step))
regulon = array(dim=length(step))

for (i in 1:length(step)) {
  top_operon_cmb_score <- countInRegulonEdge(dd[ order(dd$hw_score, decreasing=TRUE)[1:step[i]], ])
  inRegEdge[i] = top_operon_cmb_score$inRegulonEdge
  regulon[i] = top_operon_cmb_score$regulon
}

type = rep("hw_socre_opr", length(step))
result = data.frame(step, type, inRegEdge, regulon)

result
#tep         type inRegEdge regulon
#  100 hw_socre_opr         8       6
#  200 hw_socre_opr        12       7
#  300 hw_socre_opr        20       8
#  400 hw_socre_opr        26       9
#  500 hw_socre_opr        30      12
#  600 hw_socre_opr        39      14
#  700 hw_socre_opr        45      14
#  800 hw_socre_opr        58      15
#  900 hw_socre_opr        64      16
# 1000 hw_socre_opr        66      16
# 1100 hw_socre_opr        72      16
# 1200 hw_socre_opr        82      17
# 1300 hw_socre_opr        87      17
# 1400 hw_socre_opr        91      17
# 1500 hw_socre_opr       101      17
# 1600 hw_socre_opr       115      18
# 1700 hw_socre_opr       126      19
# 1800 hw_socre_opr       140      19
# 1900 hw_socre_opr       152      19
# 2000 hw_socre_opr       160      19

write.table(result, file="hw_socre_opr_top_edge_analysis.tsv", quote=F, row.names=F, sep='\t')





#countInRegulonEdge <- function(data) {
#    return(nrow(data[ data$in_regulon > 0, ]))
#}
#
#countRegulon <- function(data) {
#    rv = 0
#    d <- data[ data$in_regulon > 0, ]
#
#    rv <- length(table(strsplit(paste(d$reg_names, collapse=''), '_'))) - 1
#    #rv <- unique(unlist(strsplit(paste(d$reg_names, collapse=''), '_'))) - 1
#
#    return(rv)
#}


