#!/usr/bin/env python
''' load all data into a sqlite3 database in an easy and dirty way'''

import sys
import sqlite3

conn = sqlite3.connect("top_10_motif_graph.db")
c = conn.cursor()
# Create table
c.execute('''CREATE TABLE top_10
                 (opr1_motif text, opr2_motif text, similarity real, zscore real, 
                 node1_degree integer, node2_degree integer,
                 common_neighbor integer, in_regulon integer, in_regulon_name text)''')

fh = open("filtered_graph_top_20_inter_12-20_top_10_motif.tsv")

fh.readline()

for line in fh:
  it = line.rstrip('\n\r').split()
  c.execute('INSERT INTO top_10 VALUES (?,?,?,?,?,?,?,?,?)', it)

conn.commit()

conn.close()

sys.exit()
###STOP HERE ##############################################################
##########################################################################
# Create table
c.execute('''CREATE TABLE top_30
                 (opr1 text, opr2 text, similarity real, zscore real, 
                 multiplicity integer, in_regulon integer, in_regulon_name text)''')

fh = open("top_30_result_table.tsv")
fh.readline()

for line in fh:
  it = line.rstrip('\n\r').split()
  c.execute('INSERT INTO top_30 VALUES (?,?,?,?,?,?,?)', it)

conn.commit()

# Create table
c.execute('''CREATE TABLE gfr
                 (opr1 text, opr2 text, score real, 
                 in_regulon integer, in_regulon_name text)''')

fh = open("hongwei_socre_operon_level.tsv")
fh.readline()
for line in fh:
  it = line.rstrip('\n\r').split()
  c.execute('INSERT INTO gfr VALUES (?,?,?,?,?)', it)

conn.commit()

# Create table
c.execute('''CREATE TABLE pcs
                 (opr1 text, opr2 text, score real)''')

fh = open("pcs_216_opr_level.tsv")
fh.readline()
for line in fh:
  it = line.rstrip('\n\r').split()
  c.execute('INSERT INTO pcs VALUES (?,?,?)', it)

conn.commit()

conn.close()
