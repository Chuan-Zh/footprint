library(Matrix)

files = c("ori/edge_1.tsv", "ori/edge_2.tsv", "ori/edge_3.tsv", "sim_cut/edge_1.tsv",
          "sim_cut/edge_2.tsv", "sim_cut/edge_3.tsv")

#file = args <- commandArgs(trailingOnly = TRUE)

for (file in files) {
    edge1<-read.table(file, header=T)

    out <- nnzero(edge1$in_regulon[order(edge1$zscore, decreasing=T)[1:1000]])

    print("reguolon pair in the top 1000 edge")
    print(file)
    print(out)
}
