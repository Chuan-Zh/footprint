#!/usr/bin/env python

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
      items = motif.split('_')
      opr = items[0]
      opr_set.add(opr)

    rv.append(opr_set)

  return rv

if __name__ == "__main__":
    import sys

    if(len(sys.argv) < 2):
        print("python %s <cluster file in mcl format>" % sys.argv[0])
        sys.exit(-1);

    reg_size_limit = 20

    regulon = read_regulon()
    mcl_f = sys.argv[1]
    clusters = read_mcl(mcl_f)

    top_range = range(5, 101, 5)

    print("regulon\treg_size\tscore\ttop_n\ttop_size\toverlap\tRCS\toverlap_coe")
    top_n = set()
    for index, clu in enumerate(clusters):
        top_n.update(clu)
        if (index + 1) in top_range:
            for reg_name in regulon.keys():
                reg = regulon[reg_name]
                reg_size = len(reg)
                if reg_size < reg_size_limit: 
                    continue
                overlap = len(reg.intersection(top_n))

                print("%s\t%d\t%s\t%d\t%d\t%d\t%f\t%f" %
                        (reg_name,
                        reg_size,
                        mcl_f,
                        index + 1,
                        len(top_n),
                        overlap,
                        float(overlap) / reg_size, 
                        overlap_coe1(overlap, reg_size, len(top_n))
                        ))







