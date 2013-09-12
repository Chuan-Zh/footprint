#!/usr/bin/env R

#dd <- read.table("data.tsv", header=TRUE)
#ddCrs <- dd[!is.na(dd$raw_crs), ]

setseed(123)
ddCrs=load("ddCrs")
n = 1000
#ccc <- replicate(n, countInRegulonEdge(ddCrs[sample(1:nrow(ddCrs), n), ]))
#(ccc)

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


