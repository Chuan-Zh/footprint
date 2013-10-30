#!/usr/bin/env R

library(ggplot2)

n <- 1000

dd<-read.table("graph_refined.tsv", header=T)

dd<- dd[dd$zscore <= 40, ]

dd$in_regulon <- as.factor(dd$in_regulon)

qplot(in_regulon, common_neighbor/(2*(node1_degree + node2_degree)), data=dd, geom="boxplot")
qplot(in_regulon, zscore, data=dd, geom="boxplot")
qplot(in_regulon, similarity, data=dd, geom="boxplot")

topCrs <- countInRegulonEdge(dd[ order(dd$zscore, decreasing=TRUE)[1:n], ])
#$inRegulonEdge
#[1] 125 
#
#$regulon
#[1] 32

top_similarity <- countInRegulonEdge(dd[ order(dd$similarity, decreasing=TRUE)[1:n], ])
top_similarity
#$inRegulonEdge
#[1] 96
#
#$regulon
#[1] 31


countInRegulonEdge <- function(data) {
    rv = list() 
    d <- data[ data$in_regulon != 0, ]
    rv$inRegulonEdge <- nrow(d)

    rv$regulon <- length(table(strsplit(paste(d$in_regulon_name, collapse=''), '_'))) - 1

    return(rv)
}
