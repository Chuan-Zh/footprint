#!/usr/bin/env R
dd= read.table("hongwei_socre_operon_level.tsv", header=TRUE)

countInRegulonEdge <- function(data) {
  rv = list() 
  d <- data[ data$in_regulon > 0, ]
  rv$inRegulonEdge <- nrow(d)

  rv$regulon <- length(table(strsplit(paste(d$reg_names, collapse=''), '_'))) - 1

  if (rv$regulon < 0) {
    rv$regulon = 0
  }

  return(rv)
}

top_operon_cmb_score <- countInRegulonEdge(dd[ order(dd$hw_score, decreasing=TRUE)[1:1000], ])
top_operon_cmb_score
#$inRegulonEdge
#[1] 201
#
#$regulon
#[1] 21


dim(dd)
#[1] 922761      5

# after single analysis for top 1000 edges, do same thing for different steps from 100 to 2000
step = 1:50
step = step*500

inRegEdge = array(dim=length(step))
regulon = array(dim=length(step))

for (i in 1:length(step)) {
  top_operon_cmb_score <- countInRegulonEdge(dd[ order(dd$hw_score, decreasing=TRUE)[1:step[i]], ])
  inRegEdge[i] = top_operon_cmb_score$inRegulonEdge
  regulon[i] = top_operon_cmb_score$regulon
}

type = rep("hw_socre_opr_avg", length(step))
result = data.frame(step, type, inRegEdge, regulon)

result
#   step         type inRegEdge regulon
#1   100 hw_socre_opr        25      11
#2   200 hw_socre_opr        41      15
#3   300 hw_socre_opr        62      17
#4   400 hw_socre_opr        78      18
#5   500 hw_socre_opr        97      18
#6   600 hw_socre_opr       121      19
#7   700 hw_socre_opr       149      20
#8   800 hw_socre_opr       173      20
#9   900 hw_socre_opr       190      20
#10 1000 hw_socre_opr       201      21
#11 1100 hw_socre_opr       217      23
#12 1200 hw_socre_opr       223      23
#13 1300 hw_socre_opr       228      23
#14 1400 hw_socre_opr       236      24
#15 1500 hw_socre_opr       241      26
#16 1600 hw_socre_opr       248      27
#17 1700 hw_socre_opr       257      29
#18 1800 hw_socre_opr       262      30
#19 1900 hw_socre_opr       265      30
#20 2000 hw_socre_opr       268      30

write.table(result, file="hw_socre_opr_top_edge_analysis_500.tsv", quote=F, row.names=F, sep='\t')





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


