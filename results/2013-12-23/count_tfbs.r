#!/usr/bin/env R

dd <- read.table("summary.tsv", header=T)
#attach(dd)

# only consider operon leading gene, put to operon level
dd <- dd[dd$is_leading_gene == 1, ]

#orth.range=seq(0, 220, by=10)
small.range = c(0, 2, 5, 10)
orth.range=seq(20, 220, by=10)
orth.range= c(small.range, orth.range)

orth.factor = cut(dd$ortholog_num, breaks=orth.range, include.lowest=TRUE)

dd$is_leading_gene == 1 & dd$under_reg_time > 0 -> tfbs

tapply(tfbs, orth.factor, FUN=function(x) sum(x)) -> tfbs.count
#table(orth.factor) -> gene.count
table(orth.factor) -> operon.count

#a <- data.frame(gene.count, tfbs.count)
a <- data.frame(operon.count, tfbs.count)
a$tfbs.count[is.na(a$tfbs.count ) ] = 0

write.table(a,file="tfbs_count.tsv", row.names=F, quote=F, sep='\t')
