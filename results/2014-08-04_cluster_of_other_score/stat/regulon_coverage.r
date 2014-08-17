#/usr/bin/env R
library(ggplot2)
library(plyr)

# Coverage of top 100 cluster with regulon
# steps:
# 1. For each of the score, for the top 100 clusters, pick a smallest overlap p-value to stand for it
# 2. combine the picked rows into a table with a factor to mark each score
# 3. Sum up the overlap with different regulon and draw a histogram 

pickMinEASE <- function (data) {
  return ( data [ which.min(data$EASE), ] )
}

#cleanScoreData: pick the top 100 cluster, each cluster keep the best matched regulon
cleanScoreData <- function( file, type ) {
  bbs <- read.table(file, header=TRUE)
  bbs <- bbs[bbs$cluster <= 100, ]
  bbs$cluster = as.factor(bbs$cluster)
  bbs <- ddply(.data=bbs, .(cluster), .fun=pickMinEASE)
  bbs$type = type
  return( bbs )
}

bbs <- cleanScoreData("bbs_cluster_vs_regulon.tsv", type='bbs')
crs <- cleanScoreData("crs_cluster_vs_regulon.tsv", type='crs')
gfr <- cleanScoreData("gfr_cluster_vs_regulon.tsv", type='gfr')
pcs <- cleanScoreData("pcs_cluster_vs_regulon.tsv", type='pcs')

dd <- rbind(bbs, crs, gfr, pcs) 
write.table(dd, file="cluster_vs_regulon.tsv", sep="\t", row.names=F, quote=F)

reg_size = read.table("regulon_size.txt", header=TRUE)
reg_size = reg_size[order(reg_size$size, decreasing=TRUE), ]
reg_large = reg_size[reg_size$size > 20, ]
reg_small = reg_size[reg_size$size <= 20 & reg_size$size > 1, ]

dd$regulon <- factor(dd$regulon, levels=as.character(reg_size$regulon), ordered=T)
dd_large <- dd[dd$regulon %in% reg_large$regulon, ]
dd_small <- dd[dd$regulon %in% reg_small$regulon, ]

gg <- ggplot(data=dd_large)
gg + geom_histogram(aes(x=regulon,y=overlap, fill=type), stat="identity", position='dodge')
dev.copy2pdf(file="overlap_with_large_regulon.pdf")


gg <- ggplot(data=dd_small)
gg + geom_histogram(aes(x=regulon,y=overlap, fill=type), stat="identity", position='dodge') + theme(axis.text.x=element_text(angle=45))
dev.copy2pdf(file="overlap_with_small_regulon.pdf")


q()
###################################################3
subreguon = c("CRP", "Fis", "Fur")
dd$regulon in subreguon

gg <- ggplot(data=dd)
dd[dd$regulon %in% subreguon, ] -> dd_pick_reg

gg_pick_reg <- ggplot(dd_pick_reg)
gg_pick_reg + geom_histogram(aes(x=regulon,y=overlap, fill=type), stat="identity", position='dodge')
names(dd)
gg_pick_reg + geom_histogram(aes(x=regulon,y=clu_size, fill=type), stat="identity", position='dodge')
gg_pick_reg + geom_histogram(aes(x=regulon,y=overlap, fill=type), stat="identity", position='dodge')
attach(dd_pick_reg)
names(dd)
fake <- data.frame(cluster,regulon, overlap, type)


cluster = c()
regulon = c()
overlap = c()
type = c()
for(i in subreguon) {
  for( j in unique(fake$type)) {
    cluster = c(cluster, 100)
    regulon = c(regulon, i)
    overlap = c(overlap, 0)
    type = c(type, j)
  }
}
cluster
regulon
fake = rbind(fake, data.frame(cluster, regulon, overlap, type))
ggfake = ggplot(data=fake)
ggfake + geom_histogram(aes(x=regulon,y=overlap, fill=type), stat="identity", position='dodge') 
head(dd)
gg + geom_histogram(aes(x=regulon,y=overlap, fill=type), stat="identity", position='dodge') 
gg + geom_histogram(aes(x=regulon,y=overlap, fill=type), stat="identity", position='stack')
