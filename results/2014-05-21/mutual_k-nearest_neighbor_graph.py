#!/usr/bin/env python
'''
Turn the original similarty graph to a mutual k-nearest neighbor graph, e.g., for u and v,
keep edge uv iff v is the k-nearest neighbor of u and u in the k-nearest neighbor or v.
'''
import sqlite3
import networkx as nx

if __name__== "__main__":
  import heapq
  import networkx as nx
  import sys
  import os
  import random
  from pprint import pprint
  from matplotlib.backends.backend_pdf import PdfPages
  import matplotlib.pyplot as plt

  conn = sqlite3.connect("top_10_motif_graph.db")
  c = conn.cursor()

#  knn_digraph = 
#  mutual_knn_g = 
  knn_limit = 10
  motifs = set()
  motif2knn_simi = {}
  motif2knn = {}
  print "building set"
  for row in c.execute('SELECT opr1_motif, opr2_motif FROM top_10'):
    motifs.add(row[0])
    motifs.add(row[1])

  for m in motifs:
    motif2knn_simi[m] = []
    motif2knn[m] = set()

  print "Building knn cutoff"
  for row in c.execute('SELECT opr1_motif, opr2_motif, similarity from top_10'):
    m1 = row[0]
    m2 = row[1]
    s = row[2]

    if len(motif2knn_simi[m1]) < knn_limit or s > motif2knn_simi[m1][0]:
      if len(motif2knn_simi[m1]) == knn_limit: heapq.heappop(motif2knn_simi[m1])
      heapq.heappush(motif2knn_simi[m1], s)
      
    if len(motif2knn_simi[m2]) < knn_limit or s > motif2knn_simi[m2][0]:
      if len(motif2knn_simi[m2]) == knn_limit: heapq.heappop(motif2knn_simi[m2])
      heapq.heappush(motif2knn_simi[m2], s)

  print "Building knn"
  for row in c.execute('SELECT opr1_motif, opr2_motif, similarity from top_10'):
    m1 = row[0]
    m2 = row[1]
    s = row[2]
    if len(motif2knn[m1]) < knn_limit and s > motif2knn_simi[m1][0]:
      motif2knn[m1].add(m2)
    if len(motif2knn[m2]) < knn_limit and s > motif2knn_simi[m2][0]:
      motif2knn[m2].add(m1)

  print "mutual knn"
  for row in c.execute('SELECT * from top_10'):
    m1 = row[0]
    m2 = row[1]
    if m1 in motif2knn[m2] and m2 in motif2knn[m1]:
      print '\t'.join([str(i) for i in row])






  conn.close()
