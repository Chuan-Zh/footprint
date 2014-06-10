#!/usr/bin/env python

import sqlite3
import sys
import networkx as nx

conn = sqlite3.connect("operon_pairwise_relation.db")
c = conn.cursor()
#for row in c.execute('SELECT * from top_10 ORDER BY similarity DESC LIMIT 10'):
#  print row
# cannot use ? for table name or something..
for row in c.execute('SELECT opr1, opr2 \
    FROM top_10 ORDER BY ? DESC LIMIT ?',
    ('similarity', 10)):
  print row

# error
#for row in c.execute('SELECT opr1, opr2 \
#    FROM :table ORDER BY :sim DESC LIMIT :lim',
#    {'table': 'top_10', 'sim': 'similarity', 'lim': 10} ):
#  print row

#  print row
t = (10,)
for row in c.execute('SELECT opr1, opr2 \
    FROM top_10 ORDER BY similarity DESC LIMIT ?',
     t):
  print row

def buildSimilarityGraph_top_10(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  # tuple literal (1000, ), not (1000)
  for row in c.execute('SELECT opr1, opr2, similarity FROM top_10 ORDER BY \
      similarity DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))

  return G

def buildGfrGraph(conn, edge_number):
  c = conn.cursor()
  G = nx.Graph()
  for row in c.execute('SELECT opr1, opr2, score FROM gfr ORDER BY \
      score DESC LIMIT ?', (edge_number, )):
    G.add_edge(row[0], row[1], score=float(row[2]))
  return G

G = buildGfrGraph(conn, 100)
print G.number_of_nodes()
