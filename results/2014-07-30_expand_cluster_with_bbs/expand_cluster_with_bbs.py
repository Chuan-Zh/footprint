#!/usr/bin/env python

if __name__ == "__main__":
    import sys
    from pprint import pprint

    motif2sites = {}

    bbs_f = "bbs_result.tsv"
    fh = open(bbs_f)
    for line in fh:
        line = line.rstrip("\n")
        items = line.split("\t")
        motif = items[0][1:]
        motif = motif.replace('-', '_')
        score = items[5]

        its = items[6].split("_")
        gi = its[2]

        sites = { 'score':score, 'gi':gi }
        #print(motif)
        #print(gi)
        #print(score)

        if motif2sites.get(motif):
            motif2sites[motif].append(sites)
        else:
            motif2sites[motif] = []
            motif2sites[motif].append(sites)

    fh.close() 
    #for k in motif2sites.keys():
        #print(len(motif2sites[k]))

    sys.exit()
    cluster_f = "edge_1_300.mcl"
    fh = open(cluster_f)
    for line in fh:
        line = line.rstrip("\n")
        items = line.split("\t")
        gis = [ site['gi'] for site in motif2sites[items[0]] ]
        print( "\t".join(gis) )

    fh.close()
            
