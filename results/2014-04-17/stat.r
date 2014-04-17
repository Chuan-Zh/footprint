lebrary(ggplot2)

# regulon size #
dd <- read.table("regulon_size.txt", header=F)
dd_rm0size <- dd[ dd$size != 0, ]
qplot(size, data=dd_rm0size, binwidth=1) + theme_bw() + xlab("regulon size")
#dev.copy2pdf(file="reg_size_dist_bin1.pdf")
qplot(size, data=dd_rm0size, ) + theme_bw() + xlab("regulon size")
#dev.copy2pdf(file="reg_size_dist_bin_default.pdf")

orth <- read.table("ortholog_opr_count.txt", header=F)
qplot(V2, data=orth, binwidth=2 ) + theme_bw() + xlab("orthologous operon number")
dev.copy2pdf(file="orth_opr_count_bin2.pdf")
qplot(V2, data=orth, binwidth=1 ) + theme_bw() + xlab("orthologous operon number")

qplot(V2, data=orth[orth$V2<216,], binwidth=1 ) + theme_bw() + xlab("orthologous operon number")
dev.copy2pdf(file="orth_opr_count_less216_bin1.pdf")

qplot(V2, data=orth[orth$V2<216,], binwidth=2 ) + theme_bw() + xlab("orthologous operon number")
dev.copy2pdf(file="orth_opr_count_less216_bin2.pdf")

# operons with more than 10 ortholog
sum(orth$V2 > 10)
#[1] 2076
dim(orth)
#[1] 2462    4
2076/2462
#[1] 0.8432169

