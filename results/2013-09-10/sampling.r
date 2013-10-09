#!/usr/bin/env R

dd <- read.table("data.tsv", header=TRUE)
ddCrs <- dd[!is.na(dd$raw_crs), ]
#> dim(ddCrs)
#[1] 2550345      11

set.seed(123)
#ddCrs=load("ddCrs")
n = 1000 # top n edges
m = 1000 # sample times
ccc <- replicate(m, countInRegulonEdge(ddCrs[sample(1:nrow(ddCrs), n), ]))
(ccc)
den<-density(unlist(ccc[1,]))
hist(unlist(ccc[1,]), main="Regulon pairs in 1000 random pairs", xlab="Regulon pairs")

topCrs <- countInRegulonEdge(ddCrs[ order(ddCrs$raw_crs, decreasing=TRUE)[1:n], ])
#$inRegulonEdge
#[1] 114
#
#$regulon
#[1] 35

ddpcs <- ddCrs[ !is.na(ddCrs$pcs_216) & !is.na(ddCrs$pcs_1286), ]
topPcs_216 <- countInRegulonEdge(ddpcs[ order(ddpcs$pcs_216, decreasing=TRUE)[1:n], ])
#$inRegulonEdge
#[1] 22
#
#$regulon
#[1] 13
#
topPcs_1286 <- countInRegulonEdge(ddpcs[ order(ddpcs$pcs_1286, decreasing=TRUE)[1:n], ])
#$inRegulonEdge
#[1] 36
#
#$regulon
#[1] 21

ddCrs_merge_cmb_score <- merge(ddCrs, cmb_score, by=c("opr1", "opr2"))
#> dim(ddCrs_merge_cmb_score)
#[1] 638731     12
top_cmb_score <- countInRegulonEdge(ddCrs_merge_cmb_score[ order(ddCrs_merge_cmb_score$combined_score, decreasing=TRUE)[1:n], ])
#> top_cmb_score
#$inRegulonEdge
#[1] 190
#
#$regulon
#[1] 23
 

countInRegulonEdge <- function(data) {
    rv = list() 
    d <- data[ data$in_regulon > 0, ]
    rv$inRegulonEdge <- nrow(d)

    rv$regulon <- length(table(strsplit(paste(d$reg_names, collapse=''), '_'))) - 1

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


