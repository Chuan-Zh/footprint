#!/usr/bin/env R
dd.table("hongwei_socre_operon_level.tsv", header=TRUE)

top_operon_cmb_score <- countInRegulonEdge(dd[ order(dd$hw_score, decreasing=TRUE)[1:1000], ])
top_operon_cmb_score
#$inRegulonEdge
#[1] 201
#
#$regulon
#[1] 21


dim(dd)
#[1] 922761      5
 

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


