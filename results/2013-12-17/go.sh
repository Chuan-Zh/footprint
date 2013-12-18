#!/usr/bin/env bash

# step 100
head -n 1 ./hw_score/hw_socre_opr_top_edge_analysis.tsv > top_edge_analysis.tsv
for i in ./hw_score/hw_socre_opr_top_edge_analysis.tsv ./pcs/pcs_top_analysis.tsv ./sim_crs/top_edge_analysis_top_30_operon.tsv ./sim_crs/top_edge_analysis_top_10_operon.tsv
do
  sed '1d' $i
done >> top_edge_analysis.tsv

# step 500
head -n 1 ./hw_score/hw_socre_opr_top_edge_analysis_500.tsv > top_edge_analysis_500.tsv
for i in ./hw_score/hw_socre_opr_top_edge_analysis_500.tsv ./pcs/pcs_top_analysis_500.tsv ./sim_crs/top_edge_analysis_500_top_30_operon.tsv ./sim_crs/top_edge_analysis_500_top_10_operon.tsv
do
  sed '1d' $i
done >> top_edge_analysis_500.tsv

# step 500 compare with hw score, consider only operons appears with a hw score
head -n 1 ./hw_score/hw_socre_opr_top_edge_analysis_500.tsv > top_edge_analysis_cmp_hw_500.tsv
for i in ./hw_score/hw_socre_opr_top_edge_analysis_500.tsv ./sim_crs/top_edge_analysis_500_in_hw_list_top_10_operon.tsv ./sim_crs/top_edge_analysis_500_in_hw_list_top_30_operon.tsv ./hw_score_avg/hw_socre_opr_top_edge_analysis_500.tsv
do
  sed '1d' $i
done >> top_edge_analysis_cmp_hw_500.tsv

