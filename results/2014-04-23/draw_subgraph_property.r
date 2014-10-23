library(ggplot2)
#######################
#
#Figure 4 transitivity_compare.pdf
#
######################
dd<-read.table("regulon_subgraph_property.tsv", header=T)
p <- ggplot(dd, aes(factor(score), transitivity))
p + geom_boxplot(aes(fill=factor(type)))
# dev.copy2pdf(file='transitivity_boxplot.pdf')

p <- ggplot(dd, aes(factor(score), transitivity/edge_density))
p + geom_boxplot(aes(fill=factor(type)))
dev.copy2pdf(file="transitivity_divide_edge_density.pdf")

# whole graph propertivity
whole <- read.table("score_graph_property.tsv", header=T)
whole$density <- whole$edges * 2/ (whole$nodes * (whole$nodes -1 ))
cc <- merge(dd, whole, by="score")
p <- ggplot(cc, aes(factor(score), transitivity/density))
p + geom_boxplot(aes(fill=factor(type)))
dev.copy2pdf(file="transitivity_divide_whole_graph_edge_density.pdf")

### choosed 3 score to compare ####
score_to_keep <- c("crs_top_10", 'gfr', 'pcs')
sub_cc <- cc[ cc$score %in% score_to_keep, ]
sub_cc$score <- factor(sub_cc$score, levels=score_to_keep,labels=c("CRS", "GFR", "PCS"), ordered=TRUE)
sub_cc$type <- factor(sub_cc$type, levels=c("real", "rand"), ordered=T, labels=c("regulon subgraph", "random subgraph"))

p <- ggplot(sub_cc, aes(factor(score), transitivity/density))
p + geom_boxplot(aes(fill=factor(type)))
p + geom_boxplot(aes(fill=factor(type))) + theme_bw() + theme(legend.title=element_blank(), legend.position=c(.8, .8)) + scale_fill_discrete() + ylab("normalized clustering score") + xlab("score type")

dev.copy2pdf(file="transitivity_compare.pdf")

### compare real and rand transitivity of three scores ###
crs_real <- transitivity[ score=='CRS' & type=='regulon subgraph']
crs_rand <- transitivity[ score=='CRS' & type=='random subgraph']
wilcox.test(crs_real, crs_rand, alternative='g')
#  Wilcoxon rank sum test with continuity correction
#
#data:  crs_real and crs_rand
#W = 23773.5, p-value = 1.729e-09
#alternative hypothesis: true location shift is greater than 0

gfr_real <- transitivity[ score=='GFR' & type=='regulon subgraph']
gfr_rand <- transitivity[ score=='GFR' & type=='random subgraph']
wilcox.test(gfr_real, gfr_rand, alternative='g')
#  Wilcoxon rank sum test with continuity correction
#
#data:  gfr_real and gfr_rand
#W = 18198.5, p-value = 0.001828
#alternative hypothesis: true location shift is greater than 0

pcs_real <- transitivity[ score=='PCS' & type=='regulon subgraph']
pcs_rand <- transitivity[ score=='PCS' & type=='random subgraph']
wilcox.test(pcs_real, pcs_rand, alternative='g')
#  Wilcoxon rank sum test with continuity correction
#
#data:  pcs_real and pcs_rand
#W = 18592, p-value = 0.000909
#alternative hypothesis: true location shift is greater than 0
