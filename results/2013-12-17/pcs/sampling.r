#!/usr/bin/env R

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

dd= read.table("pcs.tsv", header=TRUE)

#top_operon_cmb_score <- countInRegulonEdge(dd[ order(dd$hw_score, decreasing=TRUE)[1:1000], ])
#top_operon_cmb_score


dim(dd)
#[1] 922761      5

# after single analysis for top 1000 edges, do same thing for different steps from 100 to 2000
step = 1:50
step = step*500

inRegEdge = array(dim=length(step))
regulon = array(dim=length(step))

order.pcs_216 = order(dd$pcs_216, decreasing=TRUE)
order.pcs_1286 = order(dd$pcs_1286, decreasing=TRUE)

for (i in 1:length(step)) {
  top_operon_cmb_score <- countInRegulonEdge(dd[ order.pcs_216[1:step[i]], ])
  inRegEdge[i] = top_operon_cmb_score$inRegulonEdge
  regulon[i] = top_operon_cmb_score$regulon
}

type = rep("pcs_216", length(step))
result.216 = data.frame(step, type, inRegEdge, regulon)


for (i in 1:length(step)) {
  top_operon_cmb_score <- countInRegulonEdge(dd[ order.pcs_1286[1:step[i]], ])
  inRegEdge[i] = top_operon_cmb_score$inRegulonEdge
  regulon[i] = top_operon_cmb_score$regulon
}

type = rep("pcs_1286", length(step))
result.1286 = data.frame(step, type, inRegEdge, regulon)

result = rbind(result.216, result.1286)
write.table(result, file="pcs_top_analysis_500.tsv", quote=F, row.names=F, sep='\t')





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


