dd <- read.table("", header=T)

#top_edge_top_10_500_hw_first_gene_stand_opr.tsv
#top_edge_top_30_500_hw_first_gene_stand_opr.tsv

library(ggplot2)

step = 1:50
step = step * 500
type = rep('null', length(step))
inRegEdge = step/100

regulon = rep(0, length(step))
null.hypo = data.frame(step, type, inRegEdge, regulon)

dd <- rbind(dd, null.hypo)

gg <- ggplot(dd, aes(step, inRegEdge))
gg + geom_line(aes(group = type, color=type), size = 1)
