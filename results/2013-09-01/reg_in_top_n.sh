#!/usr/bin/env bash

# output all regulon appear in the top n edges
# $1 for the original edge file
# $2 for the top number of edges

sed '1d' $1 |
sort -k3nr |
head -n $2 |
cut -f 5 |
grep -v '-' |
tr '_' '\n' |
sort |
uniq -c  |
sed '1d'
