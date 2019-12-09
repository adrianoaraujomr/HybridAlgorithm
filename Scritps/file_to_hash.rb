#!/usr/bin/ruby -w

#END {
#	edge_list_to_hash()
#}

$path = "../Graphs/"

def edge_list_to_hash()
	hs = Hash.new
	fd = File.new($path + "graph_2.txt","r")

	while (line = fd.gets)
		edge        = line.split(" ")

		if not hs.keys.include? edge[0]
			hs[edge[0]] = Array.new()
		end
		if not hs.keys.include? edge[1]
			hs[edge[1]] = Array.new()
		end
		hs[edge[0]].push(edge[1])
		hs[edge[1]].push(edge[0]) # Comment this line so the graph become a digraph
	end

	return hs
end

def read_transform()
	hs = Hash.new
	fd = File.new("../Graphs/graph.csv", "r")

	while (line = fd.gets)
		root  = line.split(",")[0].to_i
		nodes = line.split("[")[1]
		nodes = nodes.gsub("\"","").gsub("]","").gsub("\'","").gsub("\r\n","")
		nodes = nodes.split(",")
		hs[root] = nodes
	end

	return hs
end
