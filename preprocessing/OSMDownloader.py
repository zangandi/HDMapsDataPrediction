# -*- coding: utf-8 -*-
"""
Created on Mon May 24 23:40:33 2021

@author: zanga
"""

# import 
import overpy
import numpy as np
import pandas as pd
from collections import OrderedDict
import json
import time
import csv
# read aoi bounding box
lat1 = 41.891721
lon1 = -87.638225
lat2 = 41.879839
lon2 = -87.626955
# intialize api
api = overpy.Overpass()
# start timer
# query all links locate inside this bbox 
bbox = (min(lat1, lat2),min(lon1, lon2),max(lat1, lat2),max(lon1, lon2))
links = api.query("[out:json];way['highway']['highway'!='path']['highway'!='steps']['highway'!='footway']['highway'!='escape']['highway'!='service']['highway'!='pedestrian'](%f,%f,%f,%f);out;" %(bbox))
# save all links in 'links' to file
thefile = open('links_ways.txt', 'w')
for item in links._ways:
  thefile.write("%s\n" % item)
thefile.close()

# query all nodes locate inside this bbox 
bbox = (min(lat1, lat2),min(lon1, lon2),max(lat1, lat2),max(lon1, lon2))
nodes = api.query("[out:json];node(%f,%f,%f,%f);out;" %(bbox))
# save all links in 'links' to file
thefile = open('nodes.txt', 'w')
for item in nodes.nodes:
  thefile.write("%d, %f, %f\n"%(item.id, item.lat, item.lon))
thefile.close()

#save node information it self
node_dict ={}
#saved the node and its corresponding link
node_id_dict={}
#saved the link information in it
link_dict={}
#used for filter
node_list=[]

for way in links.ways:
    flag = False
    way_id=str(way.id)
    #save the road information in dictionary of the link
    link_dict[way_id]=way

# for each link in links
for way in links.ways:
    # get the node ids for this link
    way_nodes = way._node_ids
    # open a file to write all the control points (AKA nodes)
    my_node = open('%s.nodes'%(str(way.id)), 'w')
    #my_tag = open('%s.tag'%(str(way.id)), 'w')
    #my_name = open('%s.name'%(str(way.id)), 'w')
    # for each node on this link
    for node_id in way_nodes:
        # call overpy API again 
        node = api.query("[out:json];node(%d);out;" %(node_id))
        # print the location to file
        my_node.write('%d, %f, %f\n'%(node.nodes[0].id, node.nodes[0].lat, node.nodes[0].lon))
    # close file
    my_node.close()
    # # write other attributes
    # my_tag.write('%s\n'%(way.tags['highway']))
    # try:
    #     my_name.write('%s\n'%(way.tags['name']))
    # except:
    #     my_name.write('noname\n')  
    # my_tag.close()
    # my_name.close()
    # print something...
    print(way.id)
