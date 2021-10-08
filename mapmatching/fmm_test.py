from fmm import FastMapMatch,Network,NetworkGraph,UBODTGenAlgorithm,UBODT,FastMapMatchConfig
import json
### Read network data

network = Network("network/edges.shp","fid","u","v")
print "Nodes {} edges {}".format(network.get_node_count(),network.get_edge_count())
graph = NetworkGraph(network)


### Precompute an UBODT table

# Can be skipped if you already generated an ubodt file
ubodt_gen = UBODTGenAlgorithm(network,graph)
status = ubodt_gen.generate_ubodt("network/ubodt.txt", 0.02, binary=False, use_omp=True)
print status

### Read UBODT

ubodt = UBODT.read_ubodt_csv("network/ubodt.txt")

### Create FMM model
model = FastMapMatch(network,graph,ubodt)

### Define map matching configurations

k = 8
radius = 0.003
gps_error = 0.0005
fmm_config = FastMapMatchConfig(k,radius,gps_error)
# initialize results
all_results = []

# open wkts file
filepath = './test_sparse.wkt'

file = open(filepath, 'r')
lines = file.readlines()



for index, line in enumerate(lines):
	wkt = line
	wkt = wkt[0:-1]
	# #wkt2 = "LineString(108.92935 34.23712,108.92936 34.23712,108.92968 34.23713,108.92982 34.23713,108.93004 34.23714,108.93028 34.23714,108.93053 34.23715,108.93084 34.23715,108.93111 34.23716,108.93135 34.23715,108.93158 34.23715,108.93183 34.23715,108.93213 34.23715,108.93231 34.23715,108.93276 34.23714,108.93306 34.23714,108.93330 34.23714,108.93358 34.23714,108.93385 34.23714,108.93400 34.23714,108.93413 34.23714,108.93428 34.23709,108.93428 34.23689,108.93429 34.23675,108.93443 34.23658,108.93458 34.23659,108.93483 34.23659,108.93499 34.23659,108.93541 34.23660,108.93569 34.23660,108.93601 34.23661,108.93627 34.23661,108.93644 34.23661,108.93680 34.23662,108.93699 34.23662,108.93727 34.23663,108.93744 34.23663,108.93760 34.23663,108.93779 34.23664,108.93818 34.23664,108.93834 34.23664,108.93860 34.23664,108.93879 34.23665,108.93945 34.23664,108.93972 34.23664,108.94001 34.23664,108.94028 34.23664,108.94060 34.23663,108.94093 34.23663,108.94119 34.23663,108.94147 34.23663,108.94173 34.23663,108.94190 34.23663,108.94206 34.23647,108.94206 34.23625,108.94206 34.23600,108.94206 34.23576,108.94205 34.23557,108.94205 34.23539,108.94205 34.23512,108.94205 34.23486,108.94205 34.23463,108.94205 34.23450,108.94205 34.23439,108.94204 34.23418,108.94204 34.23408,108.94204 34.23398)"
	# print(len(wkt))
	# print(wkt[-2:])
	# print(len(wkt2))
	# print(wkt2[-2:])
	result = model.match_wkt(wkt,fmm_config)
	# there is a path matech
	this_result = {} 
	### Print map matching result
	this_result['Opath'] = list(result.opath)
	this_result['Cpath'] = list(result.cpath)
	this_result['mmWKT'] = result.mgeom.export_wkt()
	this_result['mmRaw'] =  wkt
	this_result['traj_id'] = index
	#this_result['Error'] = result.error
	#this_result['Speed'] = result.speed
	# print "Opath ",list(result.opath)
	# print "Cpath ",list(result.cpath)
	all_results.append(this_result)
print(len(all_results))
file.close()
### Run map matching for wkt
# wkt = "LineString(108.92935 34.23712,108.92936 34.23712,108.92968 34.23713,108.92982 34.23713,108.93004 34.23714,108.93028 34.23714,108.93053 34.23715,108.93084 34.23715,108.93111 34.23716,108.93135 34.23715,108.93158 34.23715,108.93183 34.23715,108.93213 34.23715,108.93231 34.23715,108.93276 34.23714,108.93306 34.23714,108.93330 34.23714,108.93358 34.23714,108.93385 34.23714,108.93400 34.23714,108.93413 34.23714,108.93428 34.23709,108.93428 34.23689,108.93429 34.23675,108.93443 34.23658,108.93458 34.23659,108.93483 34.23659,108.93499 34.23659,108.93541 34.23660,108.93569 34.23660,108.93601 34.23661,108.93627 34.23661,108.93644 34.23661,108.93680 34.23662,108.93699 34.23662,108.93727 34.23663,108.93744 34.23663,108.93760 34.23663,108.93779 34.23664,108.93818 34.23664,108.93834 34.23664,108.93860 34.23664,108.93879 34.23665,108.93945 34.23664,108.93972 34.23664,108.94001 34.23664,108.94028 34.23664,108.94060 34.23663,108.94093 34.23663,108.94119 34.23663,108.94147 34.23663,108.94173 34.23663,108.94190 34.23663,108.94206 34.23647,108.94206 34.23625,108.94206 34.23600,108.94206 34.23576,108.94205 34.23557,108.94205 34.23539,108.94205 34.23512,108.94205 34.23486,108.94205 34.23463,108.94205 34.23450,108.94205 34.23439,108.94204 34.23418,108.94204 34.23408,108.94204 34.23398)"
# result = model.match_wkt(wkt,fmm_config)

# ### Print map matching result
# print "Opath ",list(result.opath)
# print "Cpath ",list(result.cpath)
# print "WKT ",result.mgeom.export_wkt()

# create json object from dictionary
json = json.dumps(all_results)

# open file for writing, "w" 
f = open("mm_test.json","w")

# write json object to file
f.write(json)

# close file
f.close()