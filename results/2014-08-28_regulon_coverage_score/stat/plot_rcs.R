#!/usr/bin/env R
library(ggplot2)
library(dplyr)


d1 <- read.table("rcs_bbs_cluster.tsv", header=T)
d1$score <- "BBS"

d2 <- read.table("rcs_edge_1_300.tsv", header=T)
d2$score <- "CRS"

d3 <- read.table("rcs_gfr.tsv", header=T)
d3$score <- "GFR"

d4 <- read.table("rcs_pcs.tsv", header=T)
d4$score <- "PCS"

dd <- rbind(d1, d2, d3, d4)
dd$score <- as.factor(dd$score)
#dd$top_n <- as.factor(dd$top_n)

gg <- ggplot(dd)
gg + geom_boxplot(aes(x=as.factor(top_n), y=RCS, fill=score))

filter(dd, top_n %% 10 == 0 , score != "BBS") -> fdd
gg <- ggplot(fdd)
gg + geom_boxplot(aes(x=as.factor(top_n), y=RCS, fill=score))
dev.copy2pdf(file="RCS_boxplot.pdf")

gg + geom_boxplot(aes(x=as.factor(top_n), y=RCS, fill=score)) + theme_bw() + xlab("top n clusters")
dev.copy2pdf(file="RCS_boxplot_0904.pdf")

gg + geom_boxplot(aes(x=as.factor(top_n), y=overlap_coe, fill=score)) + theme_bw() + xlab("top n clusters") + ylab("overlap coefficient")
#(overlap_coe = |intersection(X, Y)| / min(|X|, |Y|) )
dev.copy2pdf(file="overlap_coe_boxplot_0904.pdf")

