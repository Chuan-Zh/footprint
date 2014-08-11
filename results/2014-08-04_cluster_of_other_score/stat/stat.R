#/usr/bin/env R
library(ggplot2)
library(plyr)

# steps:
# 1. For each of the score, for the top 100 clusters, pick a smallest p-value to stand for it
# 2. combine the picked rows into a table with a factor to mark each score
# 3. Draw p-value distribution with boxplot 

pickMinEASE <- function (data) {
  return ( data [ which.min(data$EASE), ] )
}

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

#> dim(crs)
#[1] 80 10
#> dim(gfr)
#[1] 83 10

bbs[order(bbs$EASE, decreasing=F), ] -> bbs
crs[order(bbs$EASE, decreasing=F), ] -> crs
bbs <- bbs[1:83, ]
crs <- crs[1:83, ]

dd <- rbind(bbs, crs, gfr, pcs) 

gg <- ggplot(data=dd)
gg + geom_boxplot(aes(x=type, y=-log(EASE)))

dev.copy2pdf(file="Dist_of_EASE_p-value.pdf")

#dd <- read.table("bbs_cluster_vs_regulon.tsv", header=TRUE)
#dd <- dd[dd$cluster <= 100, ]

names(dd)
#[1] "cluster"            "regulon"            "clu_size"          
#[4] "reg_size"           "overlap"            "overlap_coe.wiki." 
#[7] "coe2"               "p.value.hypergeom." "EASE" "type"



pickMaxCoe <- function (data) {
  return ( data[ which.max(data$overlap_coe.wiki.), ] )
}

pickMaxCoe2 <- function (data) {
  return ( data[ which.max(data$coe2), ] )
}


pickMinPvalue <- function (data) {
  return ( data [ which.min(data$p.value.hypergeom.), ] )
}
