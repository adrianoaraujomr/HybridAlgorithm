#!/usr/bin/ruby -w

require "./write_results.rb"
require "./selection_methods.rb"
require "./individual.rb"
require 'gruff'

$sonet = SocialNetwork.new

class GeneticAlg
	def initialize(paths,gen,sr)
		@generations = gen
		@sr          = sr
		@population  = SPopulation.new(paths)
		@selection   = Tournament.new()
	end

	def run()
		for i in 0..@generations do
			puts i
			eval = @population.fitness

#			# Seleção
			seld = @selection.run(eval,@sr)

#			# Cruzamento/Combinação
			aux = @population.crossing(seld,$sonet)

#			# Mutação
			@population.mutation(seld)

#			# Update population
			@population.update_population(aux,$sonet)

			eval = @population.fitness
		end

		return @population.pop_values
	end
end
