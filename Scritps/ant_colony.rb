#!/usr/bin/ruby -w

require "./social_graph"
require "./write_results"


# Somethins tells me the problem is in here
class Ant
	def create_path_crescent_rnd(node_hash,heuristics,graph,cum_sum,alfa,beta)
		@path = [] # Array
		@stop = 0
		
		while @stop < graph.n_nodes
			j = node_hash.keys.sample
			r = rand()
			if((r < ((node_hash[j]**alfa)*(heuristics[j]**beta)/cum_sum)) and (not(@path.include? j)))# probability of chosing the j node
				@path.push(j)
				@stop = graph.neighbours(@path)
#				print @path.inspect + " : "
#				puts @stop
			end
		end
	end

	def path()
		return @path
	end

	def path_lenght()
		return @path.size
	end
end
