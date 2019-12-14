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

=begin
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

	def create_path_roulette(node_hash,graph,cum_sum,alfa)
		@roulette = []
		aux = 0

		for k in node_hash.keys
			aux += (node_hash[k]**alfa)/cum_sum
			@roulette.push(aux)
		end
		@roulette.push(2.0)
#		puts @roulette.inspect
#		for i in 0..@roulette.length - 1
#			puts @roulette[i]
#		end

		@path = []
		@path.push(node_hash.keys.sample)
		@stop = graph.neighbours(@path)
		while @stop < graph.n_nodes
			r = rand()
			for i in 0..@roulette.length - 1
				if(@roulette[i] > r)
					if(i != 0)
						i = i - 1
					end
					break
				end
				if not @path.include? node_hash.keys[i]
				@path.push(node_hash.keys[i])
				@stop = graph.neighbours(@path)
				end
			end
		end

	end
=end
