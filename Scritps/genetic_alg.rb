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
		for i in 0..@@generations do
			puts i
			eval = @population.fitness

			# Seleção
			seld = @selection.run(eval,@@sr)

			# Cruzamento/Combinação
			aux = @population.crossing_1(seld,$sonet)

			# Mutação
			@population.mutation_2(seld)

			# Update population (only if crossing_1 is used)		
			@population.update_population(aux,$sonet)

			eval = @population.fitness
		end
	end
end

#END {
#	$sonet = SocialNetwork.new
#	pop = SPopulation.new(100,$sonet)
#	sel = Tournament.new()
#	gen = GeneticAlg.new(pop,sel)
#	gen.run()
#}
