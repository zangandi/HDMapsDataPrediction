import pickle
from utils.graphwave.graphwave import *
from utils.sparse_matrix_factorization import *
import numpy as np
from matplotlib import pyplot as plt

# g1 = nx.petersen_graph()
# nx.draw(g1)
# plt.show()

import json

node_file_path = 'hd_data/nodes.shp.json'
edge_file_path = 'hd_data/edges.shp.json'

with open(node_file_path, 'r') as j:
     nodes = json.loads(j.read())

with open(edge_file_path, 'r') as j:
    edges = json.loads(j.read())

edge_list = []
target_node_dict = {}
for edge_item in edges[0]:
    edge_list.append(edge_item)

node_list = []
for node_item in nodes[0]:
    node_list.append(node_item['osmid'])

list_edge = []
nodes_index = []
for edge_item in edge_list:
    u_node = edge_item['u']
    v_node = edge_item['v']
    edge_length = edge_item['length']

    nodes_index.extend([u_node, v_node])
    edge = (u_node, v_node, edge_length)
    list_edge.append(edge)

nodes_index_unique = list(set(nodes_index))
nodes_index_unique.sort(key=nodes_index.index)

g = nx.DiGraph()
g.add_weighted_edges_from(list_edge)
chi, _, _ = graphwave_alg(g, np.linspace(0, len(nodes_index_unique), int(16)),
                          taus='auto', verbose=False,
                          nodes_index=nodes_index_unique,
                          nb_filters=2)
edge_embedding_list = []
for edge_item in edge_list:
    u_node = edge_item['u']
    v_node = edge_item['v']
    edge_osmid = edge_item['osmid']

    u_node_embedding = chi[nodes_index_unique.index(u_node)]
    v_node_embedding = chi[nodes_index_unique.index(v_node)]

    edge_embedding = np.concatenate((u_node_embedding, v_node_embedding), 0)
    edge_embedding_list.append(edge_embedding)
edge_embedding_list = np.array(edge_embedding_list)

with open('hd_data/edge_embedding_np.pkl', 'wb') as f:
    pickle.dump(edge_embedding_list, f)
print('ok')