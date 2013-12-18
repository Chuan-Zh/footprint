dd <- read.table("top_edge_analysis_cmp_hw_500.tsv", header=T)
head(dd)
library(ggplot2)
gg <- ggplot(dd, aes(step, inRegEdge))
help(geom_line)
gg + geom_line(aes(group=type))
gg + geom_line(aes(group=type, color=type))
dd <- read.table("top_edge_analysis_cmp_hw_500.tsv", header=T)
gg <- ggplot(dd, aes(step, inRegEdge))
gg + geom_line(aes(group=type, color=type))
step = 1:50
step = step * 50
step
step = 1:50
step = step * 500
type = rep('null', len(step))
type = rep('null', length(step))
type
inRegEdge = type/100
inRegEdge = step/100
regulon = rep(0, length(step))
null.hypo = data.frame(step, type, inRegEdge, regulon)
null.hype
dd <- rbind(dd, null.hypo)
dd
gg <- ggplot(dd, aes(step, inRegEdge))
gg <- ggplot(dd, aes(step, inRegEdge))
gg + geon_line(aes(group = type, color=type))
gg + geom_line(aes(group = type, color=type))
gg + geom_line(aes(group = type, color=type), size = 2)
gg + geom_line(aes(group = type, color=type), size = 1)
