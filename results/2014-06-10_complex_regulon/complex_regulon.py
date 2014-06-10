#!/usr/bin/env python
''' Generate complex regulon by overlap '''

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

def readRegulonG2R(file="regulon_by_first_gene.txt", regulon_size_cutoff=0):
  ''' read regulon file, return gene id to regulon names joined by _ '''
  rv = {}
  reg_now = ''

  datafile = open(file)
  for line in datafile:
    line = line.rstrip('\n\r')
    if line.startswith('>'):
      reg_now = line[1:]
    else:
      if len(line.lstrip().split()) > regulon_size_cutoff:
        for gi in line.lstrip().split():
          if gi in rv: rv[gi] += ('_' + reg_now)
          else: rv[gi] = reg_now

  return rv

def complexRegulon(regG2R):
  ''' generate complex regulon from gene id to regulon names map by reversing 
  key and value'''
  complex = {}
  for i in regG2R.values():
    complex[i] = []

  for (k, v) in  regG2R.iteritems():
    complex[v].append(k)

  return complex

if __name__ == "__main__":
  regG2R = readRegulonG2R(file="regulon_by_first_gene.txt", regulon_size_cutoff=20)
  complex = complexRegulon(regG2R)
  for i in complex.keys():
    print( ">%s" % (i) )
    print "\t".join(complex[i])

