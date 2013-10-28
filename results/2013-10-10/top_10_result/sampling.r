#!/usr/bin/env R

dd <- read.table("data.tsv", header=TRUE)
ddCrs <- dd[!is.na(dd$raw_crs), ]
#> dim(ddCrs)
#[1] 2486865 7

cmb_score <- read.table("hongwei_combined_score.tsv", header=TRUE)

set.seed(123)
#ddCrs=load("ddCrs")
n = 1000 # top n edges
m = 1000 # sample times
ccc <- replicate(m, countInRegulonEdge(ddCrs[sample(1:nrow(ddCrs), n), ]))
(ccc)
data.frame(x = unlist(ccc[1,]), y = unlist(ccc[2,])) -> random_sample_count
library(ggplot2)
p + geom_density() + xlab("Regulon pairs") + labs(title = "Regulon pairs in 1000 random pairs")

#den<-density(unlist(ccc[1,]))
#hist(unlist(ccc[1,]), main="Regulon pairs in 1000 random pairs", xlab="Regulon pairs")

topCrs <- countInRegulonEdge(ddCrs[ order(ddCrs$raw_crs, decreasing=TRUE)[1:n], ])
#$inRegulonEdge
#[1] 119
#
#$regulon
#[1] 32

top_similarity <- countInRegulonEdge(ddCrs[ order(ddCrs$similarity, decreasing=TRUE)[1:n], ])
top_similarity
#$inRegulonEdge
#[1] 95
#
#$regulon
#[1] 31

# pcs does not make a change, same as in top 30 motif
#ddpcs <- ddCrs[ !is.na(ddCrs$pcs_216) & !is.na(ddCrs$pcs_1286), ]
#topPcs_216 <- countInRegulonEdge(ddpcs[ order(ddpcs$pcs_216, decreasing=TRUE)[1:n], ])
##$inRegulonEdge
##[1] 22
##
##$regulon
##[1] 13
##
#topPcs_1286 <- countInRegulonEdge(ddpcs[ order(ddpcs$pcs_1286, decreasing=TRUE)[1:n], ])
##$inRegulonEdge
##[1] 36
##
##$regulon
##[1] 21

ddCrs_merge_cmb_score <- merge(ddCrs, cmb_score, by=c("opr1", "opr2"))
dim(ddCrs_merge_cmb_score)
#[1] 638731     12
top_cmb_score <- countInRegulonEdge(ddCrs_merge_cmb_score[ order(ddCrs_merge_cmb_score$combined_score, decreasing=TRUE)[1:n], ])
#> top_cmb_score
#$inRegulonEdge
#[1] 190
#
#$regulon
#[1] 23
# above result is right after validation with updated data with perl

top_crs_with_cmb <- countInRegulonEdge(ddCrs_merge_cmb_score[ order(ddCrs_merge_cmb_score$raw_crs, decreasing=TRUE)[1:n], ])
#> top_crs_with_cmb
#$inRegulonEdge
#[1] 144
#
#$regulon
#[1] 33

top_similarity_with_cmb <- countInRegulonEdge(ddCrs_merge_cmb_score[ order(ddCrs_merge_cmb_score$similarity, decreasing=TRUE)[1:n], ])
top_similarity_with_cmb
#$inRegulonEdge
#[1] 104
#
#$regulon
#[1] 26


 

countInRegulonEdge <- function(data) {
    rv = list() 
    d <- data[ data$in_regulon > 0, ]
    rv$inRegulonEdge <- nrow(d)

    rv$regulon <- length(table(strsplit(paste(d$in_regulon_name, collapse=''), '_'))) - 1

    return(rv)
}


#countInRegulonEdge <- function(data) {
#    return(nrow(data[ data$in_regulon > 0, ]))
#}
#
#countRegulon <- function(data) {
#    rv = 0
#    d <- data[ data$in_regulon > 0, ]
#
#    rv <- length(table(strsplit(paste(d$reg_names, collapse=''), '_'))) - 1
#    #rv <- unique(unlist(strsplit(paste(d$reg_names, collapse=''), '_'))) - 1
#
#    return(rv)
#}


