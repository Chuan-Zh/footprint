#!/usr/bin/env R
library(ggplot2)
library(dplyr)

dd <- read.table("validation.tsv", header=F)

names(dd) <- c("cluID", "bicSmall", "bicPosSmall", "bicSum", "bicPosSum", "bicType", "cluType")
scores <- group_by(dd, cluType, bicType)

cutoff = 1e-3
ss <- summarise(scores, len=length(cluID), percent=sum(bicSmall <= cutoff), percent01=sum(bicSmall <= cutoff*10))

as.data.frame(ss) -> dss
filter(dss, cluType != 'edge_1_300') -> dss

gg <- ggplot(data=dss)
> gg + geom_bar(aes(x=cluType, y=percent, fill=bicType), position='dodge', stat="identity")
# dev.copy2pdf(file="percent_of_significant_overlap_p10-3.pdf")

> gg + geom_bar(aes(x=cluType, y=percent01, fill=bicType), position='dodge', stat="identity")
# dev.copy2pdf(file="percent_of_significant_overlap_p10-2.pdf")



gg <- ggplot(data=dd)
gg + geom_boxplot(aes(x=cluType, y=-log(bicSmall), fill=bicType))


### At Operon Level

dd <- read.table("validation_opr_level.tsv", header=F)
names(dd) <- c("cluID", "bicSmall", "bicPosSmall", "bicSum", "bicPosSum", "bicType", "cluType")
gg <- ggplot(data=dd)
gg + geom_boxplot(aes(x=cluType, y=bicSum, fill=bicType)) + ylim(c(1, 100))

ddf <- filter(dd, bicSum > 5)
ggf <- ggplot(data=ddf)
ggf + geom_boxplot(aes(x=cluType, y=bicSum, fill=bicType)) 


ddf2 <- filter(ddf, bicType=='strict')

