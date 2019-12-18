#!/usr/bin/python3

import networkx as nx
import matplotlib.pyplot as plt

graph = nx.readwrite.edgelist.read_edgelist("../Graphs/graph_1.txt")
print(graph.number_of_edges())
print(graph.number_of_nodes())

#nx.draw(graph)
#plt.show()
#plt.savefig("../View/graph_1.png")
