#!/usr/bin/ruby -w

require "./social_graph"
require "./write_results"

class Ant
	def create_path_decrescent_rnd(node_hash,graph,cum_sum,alfa)
		@path = node_hash.keys # Array
		@stop = graph.neighbours(@path)
		while @stop == graph.n_nodes
			j = @path.sample       # probale new node
			r = rand()                  # "randomness control"
			if r > ((node_hash[j]**alfa))/cum_sum
				rm = @path.delete(j)
				@stop = graph.neighbours(@path)
			end
		end
		@path.push(rm)

	end
	
	def path()
		return @path
	end

	def path_lenght()
		return @path.size
	end
end
