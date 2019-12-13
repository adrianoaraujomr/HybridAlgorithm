#!/usr/bin/ruby -w

require "./social_graph"
require "./write_results"
require "./ant_colony"
require "./genetic_alg"

# Idea
#  Use the ant colony to create diverse paths
#  Run a series of genetic operations
#  Update the node weights 'fermonio'

class HybridAlgorithm
	def initialize(graph,nodes,iterations,n_ants)
		@alfa   = 3
		@beta   = 1
		@graph  = graph
		@iter   = iterations
		@n_ants = n_ants
		@nodes  = Hash.new
		@heuri  = Hash.new
		@best   = [0,graph.n_nodes]

		# Initialize pheromone
		#  maybe put some heuristic (number of neighbours)
		aux = 0
		for i in 0..(nodes.size - 1)
			r = rand()
			x = graph.neighbours_list(nodes[i]).size + 2
			h = (1.0 - (1.0/x))
			@nodes[nodes[i]] = 0.5
			@heuri[nodes[i]] = h

			aux += (0.5**@alfa) * (h**@beta)
		end
		@nodes_f_sum = aux
	end

	def run()
		for i in 1..@iter
			puts "Iteration " + i.to_s

			# Ant initialization
			paths = []
			for j in 0..(@n_ants - 1)
				a = Ant.new
				a.create_path_crescent_rnd(@nodes,@heuri,@graph,@nodes_f_sum,@alfa,@beta)
#				a.create_path_roulette(@nodes,@graph,@nodes_f_sum,@alfa)
				paths.push(a.path)
			end

			# Run the genetic operators
#			ga    = GeneticAlg.new(paths,100,0.6) # path,iterations,selection_rate
#			paths = ga.run()

			# If needed use evaporation
			for j in @nodes.keys
				@nodes[j] *= (1 - rand())
			end

			# Solution quality/Pheromone update
			lks = []
			for p in paths
#				puts p.inspect
				lk = p.length
				lks.push(lk)
				for idx in p
					@nodes[idx] += (1.0/lk)
				end
			end

			# If needed run evaportaion
			# Update the cumulative sum
			att_nodes_f_sum
			write_stats(i,lks,@nodes,@nodes_f_sum)
		end
	end

	private
	def att_nodes_f_sum()
		aux = 0
		for i in @nodes.keys
			aux += (@nodes[i]**@alfa) * (@heuri[i]**@beta)
#			aux += @nodes[i]**@alfa
		end
		@nodes_f_sum = aux
	end

end

END{
	init_file()
	graph = SocialNetwork.new
	puts graph.show_graph
	hype  = HybridAlgorithm.new(graph,graph.keys,1000,10)
	hype.run()
	update_file()
}
