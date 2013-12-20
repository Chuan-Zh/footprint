dd <- read.table("top_edge_analysis_cmp_hw_500.tsv", header=T)
library(ggplot2)
step = 1:50
step = step * 500
type = rep('null', length(step))
inRegEdge = step/100
regulon = rep(0, length(step))
null.hypo = data.frame(step, type, inRegEdge, regulon)
dd <- rbind(dd, null.hypo)
gg + geom_line(aes(group = type, color=type), size = 1)
