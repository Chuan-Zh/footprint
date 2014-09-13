#!/usr/bin/env python
""" Validate regulon prediction with gene expression bicluster results"""

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

def read_bicluster(f):
    """ read biclusters as list of sets """
    rv = []

    fin = open(f)
    cur_cluster = ''
    for line in fin:
        line = line.rstrip()
        if line.startswith('BC'): cur_cluster = line
        if cur_cluster and line.startswith(" Gene"):
            genes = line.split(' ')
            genes = genes[3:]
            genes = [g.split('_')[1] for g in genes]
            rv.append(set(genes))
    return rv

def read_bicluster_positive(f):
    """ read biclusters as list of sets, only keep positive set """
    rv = []

    fin = open(f)
    cur_cluster = ''
    cur_gene_set = set()
    for line in fin:
        line = line.rstrip()
        if line.startswith('BC'): 
            cur_cluster = line
            if cur_gene_set: rv.append(cur_gene_set)
            cur_gene_set = set()
            continue

        if line == '': 
            cur_cluster = ''
            continue

        if cur_cluster and line.startswith(" Gene"): continue
        if cur_cluster and line.startswith(" Conds"): continue
        if cur_cluster:
            g = line.split('\t')[0]
            g = g.split('_')[1]
            cur_gene_set.add(g)

    return rv

def ppt_b2gi(file='NC_000913.ptt'):
    ''' read ppt file, return bnum to gi'''
    fin = open(file)
    fin.readlines(3)
    rv = {}
    for line in fin:
        line = line.rstrip()
        items = line.split("\t")
        rv[ items[5] ] = items[3]

    return rv

def opr_gi2set(file='NC_000913.opr'):
    ''' read opr file, return ang gi to the opr gi set it is in'''
    fin = open(file)
    rv = {}
    for l in fin:
        l = l.rstrip()
        gs = l.split('\t')[1]
        gs = gs.split(' ')

        gis = []
        for g in gs:
            if g.find('-') == -1:
                gis.append(g)


        for gi in gis:
            rv[gi] = set(gis)

    return rv




if __name__ == "__main__":
    from pprint import pprint
    from scipy.stats import hypergeom
    import sys
    import math 

    exp_f = "co-expression-validation-09072014/avg_E_coli_v4_Build_6_exps466probes4297.tab.blocks.default"

    if len(sys.argv) != 5:
        print("python %s <expression_file> <cluster_file> <expression_type> <cluster_type>" %
                sys.argv[0])
        sys.exit(-1);

    exp_f = sys.argv[1];
    cluster_f = sys.argv[2];
    clusters = read_mcl(cluster_f)
    #clusters = read_mcl("bbs_cluster.mcl")

    GENE_COUNT = 4146
    P_CUTOFF = 1e-5

    biclu = read_bicluster(exp_f)
    bic_p = read_bicluster_positive(exp_f)
    b2gi = ppt_b2gi()

    # bicluster from bnum to gi
    biclusters = []
    for clu in biclu:
        gis = [b2gi[b] for b in clu if b2gi.has_key(b)]
        biclusters.append(set(gis))

    biclusters_p = []
    for clu in bic_p:
        gis = [b2gi[b] for b in clu if b2gi.has_key(b)]
        biclusters_p.append(set(gis))

    opr = opr_gi2set()

    clu_index = 0
    for clu in clusters:
        clu_index += 1
        if clu_index > 100: break
        clu_set = set()
        # transfer cluster from operon set to gene set
        for gi in clu:
            clu_set.add(gi)
            if opr.has_key(gi):
                clu_set.update(opr[gi])

        clu_sig_score = 0
        clu_sig_smallest = -1;
        for bic in biclusters:
            bic_size = len(bic)
            clu_size = len(clu_set)
            overlap = len(bic & clu_set)


            hyper = hypergeom(GENE_COUNT, bic_size, clu_size)
            hypersf = hyper.sf(overlap)
            #print("%d\t%d\t%d\t%.3f" % (bic_size, clu_size, overlap, hypersf))
            if clu_sig_smallest < 0:
                clu_sig_smallest = hypersf
            elif clu_sig_smallest > hypersf:
                clu_sig_smallest = hypersf


            if hypersf < P_CUTOFF:
                if hypersf <= 0: hypersf = P_CUTOFF
                clu_sig_score += -math.log10(hypersf)

        clu_sig_score_p = 0
        clu_sig_smallest_p = -1;
        for bic in biclusters_p:
            bic_size = len(bic)
            clu_size = len(clu_set)
            overlap = len(bic & clu_set)


            hyper = hypergeom(GENE_COUNT, bic_size, clu_size)
            hypersf = hyper.sf(overlap)
            #print("%d\t%d\t%d\t%.3f" % (bic_size, clu_size, overlap, hypersf))

            if clu_sig_smallest_p < 0:
                clu_sig_smallest_p = hypersf
            elif clu_sig_smallest_p > hypersf:
                clu_sig_smallest_p = hypersf

            if hypersf < P_CUTOFF:
                if hypersf <= 0: hypersf = P_CUTOFF
                clu_sig_score_p += -math.log10(hypersf)

        print("%d\t%.3e\t%.3e\t%.3f\t%.3f\t%s\t%s" % (clu_index, 
            clu_sig_smallest,
            clu_sig_smallest_p,
            clu_sig_score,
            clu_sig_score_p, 
            sys.argv[3],
            sys.argv[4]))




