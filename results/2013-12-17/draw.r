#!/usr/bin/env R
dd <- read.table("top_edge_analysis_cmp_hw_500.tsv", header=T)
library(ggplot2)
step = 1:50
step = step * 500
type = rep('null', length(step))
inRegEdge = step/100
regulon = rep(0, length(step))
null.hypo = data.frame(step, type, inRegEdge, regulon)
dd <- rbind(dd, null.hypo)
gg <- ggplot(aes(x=step, y=inRegEdge), data=dd)
gg + geom_line(aes(group = type, color=type), size = 1)


dd <- read.table("top_edge_analysis_cmp_3_score.tsv", header=T)
library(ggplot2)
step = 1:50
step = step * 500
type = rep('null', length(step))
inRegEdge = step/100
regulon = rep(0, length(step))
null.hypo = data.frame(step, type, inRegEdge, regulon)
dd <- rbind(dd, null.hypo)
score_to_keep <- c("hw_socre_opr_avg", "pcs_216", "top_10_similarity", "top_10_zscore", "null")
sub_dd <- dd[ dd$type %in% score_to_keep, ]
gg <- ggplot(aes(x=step, y=inRegEdge), data=sub_dd)
gg + geom_line(aes(group = type, color=type), size = 1)
gg + geom_line(aes(group = type, color=type), size = 1) + theme_bw() + scale_colour_discrete(labels=c("GFR", "PCS", "similarity", "CRS", "random"), name="score type") + xlab("top n edges") + ylab("edges connect operons in regulon") + theme(legend.position=c(.2, .8))
dev.copy2pdf(file="top_edge_analysis_cmp_3_score.pdf")
  

