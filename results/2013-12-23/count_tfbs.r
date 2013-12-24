#!/usr/bin/env R

dd <- read.table("summary.tsv", header=T)
attach(dd)

orth.range=seq(0, 220, by=10)

orth.factor = cut(dd$ortholog_num, breaks=orth.range, include.lowest=TRUE)

is_leading_gene == 1 & under_reg_time > 0 -> tfbs

tapply(tfbs, orth.factor, FUN=function(x) sum(x)) -> tfbs.count
table(orth.factor) -> gene.count

a <- data.frame(gene.count, tfbs.count)

write.table(a,file="tfbs_count.tsv", row.names=F, quote=F, sep='\t')
