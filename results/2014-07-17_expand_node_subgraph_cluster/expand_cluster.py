#!/usr/bin/env python
# for a cluster in the clustering result, expand it by adding its nearest neighbours
# 1, got all neighbours of cluster members
# 2, for all neighbours, sum up their similarity with cluster members
# 3, expand the cluster to n*size by adding the top similarity neighbours

if __name__ == "__main__":
#  import networkx as nx
  import sqlite3
  import sys
  import os
  import random
  from pprint import pprint
  from matplotlib.backends.backend_pdf import PdfPages
  import matplotlib.pyplot as plt

  EXPAND_INDEX=3

  conn = sqlite3.connect("top_10_motif_graph.db")

  clu_f = "edge_1_300.mcl"

  fh = open(clu_f)
  for line in fh:
    line = line.rstrip('\n\r')
    clu = line.split()
    size = len(clu)
    expand_size = EXPAND_INDEX * size

    ngb2sim = {}
    for motif in clu:
      c = conn.cursor()
      for row in c.execute('SELECT opr1_motif, opr2_motif, similarity FROM top_10 WHERE \
          opr1_motif=?', (motif, )):
        if ngb2sim.get(row[1]): ngb2sim[row[1]] += row[2]
        else: ngb2sim[row[1]] = row[2]

        #print("%s\t%s\t%f" % (row[0], row[1], row[2]))

      for row in c.execute('SELECT opr1_motif, opr2_motif, similarity FROM top_10 WHERE \
          opr2_motif=?', (motif, )):
        if ngb2sim.get(row[0]): ngb2sim[row[0]] += row[2]
        else: ngb2sim[row[0]] = row[2]
        #print("%s\t%s\t%f" % (row[0], row[1], row[2]))
      
    #pprint(ngb2sim)
    for (m, s) in sorted(ngb2sim.items(), key=lambda x:x[-1], reverse=True):
      if len(clu) >= expand_size: break
      if m in clu: continue
      else: clu.append(m)
    #pprint(clu)
    print('\t'.join(clu))

    #break

  conn.close()

