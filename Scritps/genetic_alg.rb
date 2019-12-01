#!/usr/bin/ruby -w

require "./write_results.rb"
require "./selection_methods.rb"
require "./individual.rb"
require 'gruff'

class GeneticAlg
	@@generations = 50000
	@@sr = 0.8

	def initialize(pop,smethods)
		@population    = pop
		@selection     = smethods
	end

	def run()
#		write_parameters(@population.return_params)

		for i in 0..@@generations do
			puts i
			eval = @population.fitness

			# Seleção
			seld = @selection.run(eval,@@sr)

			# Cruzamento/Combinação
#			@population.crossing_2(seld,$sonet)
			aux = @population.crossing_1(seld,$sonet)

			# Mutação
			@population.mutation_2(seld)

			# Update population (only if crossing_1 is used)		
			@population.update_population(aux,$sonet)

			eval = @population.fitness

			# Write eval to file
#			write_stats(iter,path_sizes)
			neval = eval.map {|x| x[0]}
			write_fitness(i,neval)

			# Graph of the population
			if i % 150 == 0 or i < 150
				nds = Array.new
				flw = Array.new
				for x in eval
					nds.push(x[0])
					flw.push(x[1])
				end
				g = Gruff::Scatter.new
				g.title = "Population #{i}"
				g.data('individuos',nds,flw)
				g.write("./graphs/population#{i}.png")
			end
		end
		update_file()
	end
end

END {
	init_file()
	$sonet = SocialNetwork.new
	pop = SPopulation.new(100,$sonet)
	sel = Tournament.new()
	gen = GeneticAlg.new(pop,sel)
	gen.run()
}
