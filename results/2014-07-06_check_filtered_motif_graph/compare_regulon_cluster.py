#!/usr/bin/env python
"""
Compare a regulon (as operon set) with a mcl cluster(as set of motifs, 
transfer to operon set) with hypergeometric distribution, overlap coefficient 
(overlap_coe = |intersection(X, Y)| / min(|X|, |Y|) ) and 
(overlap_coe2 = |intersection(X, Y)| / |union(X, Y)| ) .
p-value corresponds to Fisher Exact test, EASE score is a modified Fisher Exact test.
See http://david.abcc.ncifcrf.gov/content.jsp?file=functional_annotation.html
"""

def overlap_coe1(inter, x, y):
  """ compute the overlap coefficient as defined in wikipedie"""
  return float(inter)/min(x, y)

def read_regulon(file="./regulon_by_first_gene.txt"):
  """ regulon as hash of set """
  rv = {}
  reg_now = ''

  datafile = open(file)
  for line in datafile:
    line = line.rstrip('\n\r')
    if line.startswith('>'):
      reg_now = line[1:]
    else:
      # at least 2 operons in a regulon to deal with
      if len(line.lstrip().split()) > 1:
        rv[reg_now] = set(line.lstrip().split())

  return rv

def read_mcl(file):
  """ mcl clusters as list of set """
  rv = []

  count = 0

  datafile = open(file)
  for line in datafile:
    count = count + 1
    line = line.rstrip()

    opr_set = set()

    for motif in line.split():
      [opr, n] = motif.split('_')
      opr_set.add(opr)

    rv.append(opr_set)

  return rv

if __name__ == "__main__":
  from scipy.stats import hypergeom

  import sys
  import os

  try:
    mcl_f = sys.argv[1]
  except IndexError:
    sys.exit("Compare regulon and mcl clusters\npython %s <mcl file generated by mcl>" % (sys.argv[0]))

  bindir = os.path.abspath(os.path.dirname(sys.argv[0]))
  regulon_f = os.path.join(bindir, "./regulon_by_first_gene.txt")
  #regulon_f = os.path.join(bindir, "./complex_reg_from_larger_than_20_regulon.txt");

  # total operon number in E.coli
  OPERON_COUNT = 2549
  regulon = read_regulon(file = regulon_f)

  clusters = read_mcl(mcl_f)
  #print clusters
  #sys.exit()

  print("cluster\tregulon\tclu_size\treg_size\toverlap\toverlap_coe(wiki)\tcoe2\tp-value(hypergeom)\tEASE")
  for index,clu in enumerate(clusters):
    if len(clu) > 1:
      for reg_name in regulon.keys():
        reg = regulon[reg_name]
        clu_size = len(clu)
        reg_size = len(reg)
        overlap  = len(clu & reg)
        union    = len(clu | reg)

        coe1 = overlap_coe1(overlap, clu_size, reg_size)
        coe2 = overlap/float(union)

        # and or or, control the output results
        if coe1 < 0.1 or coe2 < 0.1: continue
        if overlap == 1: continue

        rv = hypergeom(OPERON_COUNT, reg_size, clu_size)

        print("%s\t%s\t%i\t%i\t%i\t%.3f\t%.3f\t%g\t%g" %
            (index + 1,
              reg_name,
              clu_size,
              reg_size,
              overlap,
              coe1,
              coe2,
              rv.sf(overlap),
              rv.sf(overlap-1)))
