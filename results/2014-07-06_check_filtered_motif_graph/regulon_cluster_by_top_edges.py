#!/usr/bin/env python
'''
With pairwise CRS score, add edges progressively to the graph and see whether nodes from regulon will form clusters
'''
import sqlite3
import networkx as nx
import matplotlib.pyplot as plt

# globle cutoffs
RegulonSizeCutoff = 20
RandomSampleSize = 100 # actually is random sample times

def readRegulon(file="regulon_by_first_gene.txt"):
  ''' read regulon file, return dict of regulon name to gene id set '''
  rv = {}
  reg_now = ''

  datafile = open(file)
  for line in datafile:
    line = line.rstrip('\n\r')
    if line.startswith('>'):
      reg_now = line[1:]
    else:
      rv[reg_now] = line.lstrip().split()

  return rv

def readRegulonG2R(file="regulon_by_first_gene.txt"):
  ''' read regulon file, return gene id to regulon names joined by _ '''
  rv = {}
  reg_now = ''

  datafile = open(file)
  for line in datafile:
    line = line.rstrip('\n\r')
    if line.startswith('>'):
      reg_now = line[1:]
    else:
      for gi in line.lstrip().split():
        if gi in rv: rv[gi] += ('_' + reg_now)
        else: rv[gi] = reg_now

  return rv

def readOperonSet(file="top_30_result_table.tsv"):
  ''' read all operon ids, e.g., the genomically first gene id in an operon '''
  rv = set();
  fh = open(file)
  fh.readline()

  for line in fh:
    line = line.rstrip('\n\r')
    it = line.split()
    gi = it[0]
    rv.add(gi)
    gi = it[1]
    rv.add(gi)

  return rv

def buildSimilarityGraph_top_10(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  for row in c.execute('SELECT opr1, opr2, similarity FROM top_10 ORDER BY \
      similarity DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))
  return G

def buildSimilarityGraph_top_10_v2(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  for row in c.execute('SELECT opr1_motif, opr2_motif, similarity FROM top_10 ORDER BY \
      similarity DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))
  return G

def buildSimilarityGraph_top_30(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  for row in c.execute('SELECT opr1, opr2, similarity FROM top_30 ORDER BY \
      similarity DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))
  return G

def buildCrsGraph_top_10(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  for row in c.execute('SELECT opr1, opr2, zscore FROM top_10 ORDER BY \
      zscore DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))
  return G

def buildCrsGraph_top_10_v2(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  for row in c.execute('SELECT opr1_motif, opr2_motif, zscore FROM top_10 ORDER BY \
      zscore DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))
  return G

def buildCrsGraph_top_30(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  for row in c.execute('SELECT opr1, opr2, zscore FROM top_30 ORDER BY \
      zscore DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))
  return G

def buildPcsGraph(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  for row in c.execute('SELECT opr1, opr2, score FROM pcs ORDER BY \
      score DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))
  return G

def buildGfrGraph(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  for row in c.execute('SELECT opr1, opr2, score FROM gfr ORDER BY \
      score DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))
  return G

def edge_density(edge_n, node_n):
  """probobility of having an edge between two nodes"""
  try:
    rv = 2.0 * edge_n / (node_n * (node_n - 1))
  except ZeroDivisionError:
    sys.stderr.write("graph has 0 or 1 node, return 0 for edge density\n")
    rv = 0

  return rv

def subgraphProperty(H):
  nnodes = nx.number_of_nodes(H)
  if nnodes < 2:
    return (2, 0, 0, 0, 0)
  nedges = nx.number_of_edges(H)
  dens = edge_density(nedges, nnodes)
  average_score = 0
  score = 0
  for (u, v, d) in H.edges(data=True):
    score += d['score']

  # average over all possible edges
  # average_score = 2 * score / (nnodes * (nnodes - 1))
  # average over all present edges
  average_score = score / nedges
  trans = nx.transitivity(H)

  return (nnodes, nedges, dens, average_score, trans)

def printGraphProperty(G, score_name):
  total_nodes = G.number_of_nodes()
  total_edges = G.number_of_edges()
  trans = nx.transitivity(G)
  print ("score\tnodes\tedges\ttransitivity")
  print ("%s\t%d\t%d\t%.3f" % (score_name, total_nodes, total_edges, trans))

def printSubgraphProperty(G, score_name, regulon_set):
  #global header
  #print("score\tregulon\ttype\tnodes\tedges\tedge_density\taverage_score\ttransitivity")
  G_nodes = G.nodes()
  for (reg, gene_set) in regulon_set.items():
    if len(gene_set) > RegulonSizeCutoff:
      H = G.subgraph(gene_set)
      if H.number_of_nodes < 2: continue
      else:
        (nnodes, nedges, dens, average_score, trans) = subgraphProperty(H)
        print("%s\t%s\treal\t%d\t%d\t%.3f\t%.3f\t%.3f" \
            % (score_name, reg, nnodes, nedges, dens, average_score, trans))
        for i in xrange(RandomSampleSize):
          H_random = G.subgraph( random.sample(G_nodes, nnodes) )
          (nnodes, nedges, dens, average_score, trans) = subgraphProperty(H_random)
          print("%s\t%s\trand\t%d\t%d\t%.3f\t%.3f\t%.3f" \
              % (score_name, reg, nnodes, nedges, dens, average_score, trans))

def print_pdf_graph(file_f, regulon, conn):
  pdf = PdfPages(file_f)
  edgesLimits = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
  #CRP = regulon_set['LexA']
  for lim in edgesLimits:
    print lim
    g = buildSimilarityGraph_top_10_v2(conn, lim)

    # Here the node is motif, eg 87878787_1, the first 8 digits represent gi
    node_color = [ 1 if node[0:8] in regulon else 0 for node in g ]

    pos = nx.graphviz_layout(g, prog="neato")
    plt.figure(figsize=(10.0, 10.0))
    plt.axis("off")
    nx.draw(g,
        pos,
        node_color = node_color,
        node_size = 20,
        alpha=0.8,
        with_labels=False,
        cmap=plt.cm.jet,
        vmax=1.0,
        vmin=0.0
        )
    pdf.savefig()
    plt.close()

  pdf.close()

if __name__== "__main__":
  import networkx as nx
  import sys
  import os
  import random
  from pprint import pprint
  from matplotlib.backends.backend_pdf import PdfPages
  import matplotlib.pyplot as plt

  EdgeLimit = 5e5
  RegulonSizeCutoff = 20
  #RandomSampleSize = 100
  #operons = readOperonSet()
  #pprint(operons)
  #print len(operons)

  regulon_set = readRegulon()
  regulon_g2r = readRegulonG2R()

  conn = sqlite3.connect("top_10_motif_graph.db")


  #G_sim_top_10 = buildSimilarityGraph_top_10(conn, EdgeLimit)
  #printSubgraphProperty(G_sim_top_10, 'sim_top_10', regulon_set)
  #printGraphProperty(G_sim_top_10, 'sim_top_10')
  #G_sim_top_10.clear()

  #G_sim_top_10 = buildSimilarityGraph_top_10(conn, EdgeLimit)
  #printSubgraphProperty(G_sim_top_10, 'sim_top_10', regulon_set)
  #printGraphProperty(G_sim_top_10, 'sim_top_10')
  #G_sim_top_10.clear()

  #G_sim_top_30 = buildSimilarityGraph_top_30(conn, EdgeLimit)
  #printSubgraphProperty(G_sim_top_30, 'sim_top_30', regulon_set)
  #printGraphProperty(G_sim_top_30, 'sim_top_30')
  #G_sim_top_30.clear()

  #G_crs_top_10 = buildCrsGraph_top_10(conn, EdgeLimit)
  #printSubgraphProperty(G_crs_top_10, 'crs_top_10', regulon_set)
  #printGraphProperty(G_crs_top_10, 'crs_top_10')
  #G_crs_top_10.clear()

  for (reg, gene_set) in regulon_set.items():
    if len(gene_set) > RegulonSizeCutoff:
      file_name = "similarity_" + reg + ".pdf"
      print_pdf_graph(file_name, gene_set, conn)
      
  conn.close()



#  pdf = PdfPages("LexA_similarity.pdf")
#  edgesLimits = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
#  CRP = regulon_set['LexA']
#  for lim in edgesLimits:
#    print lim
#    g = buildSimilarityGraph_top_10_v2(conn, lim)
#
#    node_color = [ 1 if node in CRP else 0 for node in g ]
#
#    pos = nx.graphviz_layout(g, prog="neato")
#    plt.figure(figsize=(10.0, 10.0))
#    plt.axis("off")
#    nx.draw(g,
#        pos,
#        node_color = node_color,
#        node_size = 20,
#        alpha=0.8,
#        with_labels=False,
#        cmap=plt.cm.jet,
#        vmax=1.0,
#        vmin=0.0
#        )
#    pdf.savefig()
#    plt.close()
#
#  conn.close()
#  pdf.close()
#
