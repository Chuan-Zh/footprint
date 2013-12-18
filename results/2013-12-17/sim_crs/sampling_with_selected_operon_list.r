#!/usr/bin/env R
args <- commandArgs(trailingOnly = TRUE)

countInRegulonEdge <- function(data) {
  rv = list() 
  d <- data[ data$in_regulon > 0, ]
  rv$inRegulonEdge <- nrow(d)

  rv$regulon <- length(table(strsplit(paste(d$in_regulon_name, collapse=''), '_'))) - 1

  if (rv$regulon < 0) {
    rv$regulon = 0
  }

  return(rv)
}

dd.ori = read.table(args[1], header=TRUE)

opr.list = read.table("operon_list_in_hw_score.txt")

dd = dd.ori[ dd.ori$opr1 %in% opr.list$V1 & dd.ori$opr2 %in% opr.list$V1, ]

#top_operon_cmb_score <- countInRegulonEdge(dd[ order(dd$hw_score, decreasing=TRUE)[1:1000], ])
#top_operon_cmb_score


dim(dd)
#[1] 922761      5

# after single analysis for top 1000 edges, do same thing for different steps from 100 to 2000
step = 1:50
step = step*500

inRegEdge = array(dim=length(step))
regulon = array(dim=length(step))

order.sim = order(dd$similarity, decreasing=TRUE)
order.crs = order(dd$zscore, decreasing=TRUE)

for (i in 1:length(step)) {
  top_operon_cmb_score <- countInRegulonEdge(dd[ order.sim[1:step[i]], ])
  inRegEdge[i] = top_operon_cmb_score$inRegulonEdge
  regulon[i] = top_operon_cmb_score$regulon
}

tt = paste(args[2], "similarity", sep="_")
type = rep(tt, length(step))
result.sim = data.frame(step, type, inRegEdge, regulon)


for (i in 1:length(step)) {
  top_operon_cmb_score <- countInRegulonEdge(dd[ order.crs[1:step[i]], ])
  inRegEdge[i] = top_operon_cmb_score$inRegulonEdge
  regulon[i] = top_operon_cmb_score$regulon
}

tt = paste(args[2], "zscore", sep="_")
type = rep(tt, length(step))
result.crs = data.frame(step, type, inRegEdge, regulon)

result = rbind(result.sim, result.crs)
write.table(result, file=args[3], quote=F, row.names=F, sep='\t')
