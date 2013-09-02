#!/usr/bin/env python

import networkx as nx

def crs_graph(file):
    G = nx.Graph()

    datafile = open(file)
    for line in datafile:
        line.rstrip('\n\r')
        if line.startswith('g'): continue
        else:
            #print(line)
            gi1, gi2, zscore, in_regulon, names = line.split('\t')

            G.add_edge(gi1, gi2, zscore=zscore, in_regulon=in_regulon, names=names)

    return G

if __name__ == '__main__':
    import networkx as nx
    G = crs_graph('res_sim_bigger_0.5/table_edge1_0.5.csv_test')

    print("graph has %d nodes with %d edges"\
          %(nx.number_of_nodes(G),nx.number_of_edges(G)))
    print(nx.number_connected_components(G),"connected components")


    try:
        from networkx import graphviz_layout
    except ImportError:
        raise ImportError("This example needs Graphviz and either PyGraphviz or Pydot")

    import matplotlib.pyplot as plt
    plt.figure(1,figsize=(20,20))
    # layout graphs with positions using graphviz neato
    pos=nx.graphviz_layout(G,prog="neato")
    # color nodes the same in each connected subgraph
    C=nx.connected_component_subgraphs(G)
    for g in C:
#        c=[random.random()]*nx.number_of_nodes(g) # random color...
        nx.draw(g,
             pos,
             node_size=40,
#             node_color=c,
             vmin=0.0,
             vmax=1.0,
             with_labels=False
             )
    plt.savefig("atlas.png",dpi=75)



