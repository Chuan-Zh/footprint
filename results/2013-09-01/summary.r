library(Matrix)

edge1<-read.table("ori/edge_1.tsv", header=T)

out <- nnzero(edge1$in_regulon[order(edge1$zscore, decreasing=T)[1:1000]])

print("reguolon pair in the top 1000 edge")
print(out)
