#!/usr/bin/ruby -w

require "./social_graph"
require "./write_results"
require "./ant_colony"

# Idea
#  Use the ant colony to create diverse paths
#  Run a series of genetic operations
#  Update the node weights 'fermonio'

class HybridAlgorithm
	def initialize(graph,nodes,iterations,n_ants)
		@alfa   = 1
		@best   = [0,graph.n_nodes]
		@graph  = graph
		@iter   = iterations
		@n_ants = n_ants
		@nodes  = Hash.new
		@heuri  = Hash.new
		@answer = []

		# Initialize pheromone
		#  maybe put some heuristic (number of neighbours)
		aux = 0
		for i in 0..(nodes.size - 1)
			@nodes[nodes[i]] = 0.5
			aux += (0.5**@alfa)
		end
		@nodes_f_sum = aux
	end

	def run()
		for i in 1..@iter
			puts "Iteration " + i.to_s

			# Ant initialization
			ants = Array.new
			for j in 0..(@n_ants - 1)
				a = Ant.new()
				a.create_path_decrescent_rnd(@nodes,@graph,@nodes_f_sum,@alfa)
			end

			# Run the genetic operators
			paths = []
			for a in ants
			end

			# Solution quality/Pheromone update
			lks   = []
			for p in paths
				lk = p.lenght
				for idx in p
					@nodes[idx] += (1.0/lk)
				end
			end

			# Update the cumulative sum
			att_nodes_f_sum
		end
		update_file()
	end

end

END{
	init_file()
	graph = SocialNetwork.new
	puts graph.keys.inspect
	saco  = HybridAlgorithm.new(graph,graph.keys,5000,100)
	saco.run()
	puts graph.keys.inspect
     puts graph.show_graph
}
