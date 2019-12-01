#!/usr/bin/ruby -w

require 'set'
require "./selection_methods.rb"

class IndividualGraph
	@@prob_mutation = 0.01
	@@prob_crossing = 0.8
	@@a             = 1
	@@b             = 3
	attr_accessor :feature
	attr_accessor :fitness

	# Mudar feature de Array para Set
	def initialize(graph)
		@graph = graph
		@keys  = graph.keys
		val = rand(@@a) + @@b
		@feature = graph.keys.sample(val)

		fit = Array.new()
		flw = graph.neighbours(@feature)
		fit.push(@feature.size,flw)
		@fitness = fit
	end

	def prob_mutation()
		return @@prob_mutation
	end

	def prob_crossing()
		return @@prob_crossing
	end

	def range_val()
		return [@@a,@@b]
	end

	# More simple and agressive mutation
	def mutation()
		if rand() <= @@prob_mutation
			nro = rand(10) + 10
			spl = @keys.sample(nro)

			aux_1 = Set.new spl
			aux_2 = Set.new @feature
			aux_1.merge aux_2

			@feature = aux_1.to_a

			fit = Array.new()
			flw = @graph.neighbours(@feature)
			fit.push(@feature.size,flw)
			@fitness = fit
		end
	end

	# Ideia 1 : sortear um ponto em cada vetor e fazer a troca das partes do vetor de cada individuo
	def crossing(graph,partner)
		if rand() <= @@prob_crossing
			i = rand(@feature.length)
			p11 = @feature[0,i]
			p12 = @feature[i,@feature.length]

			j = rand(partner.feature.length)
			p21 = partner.feature[0,j]
			p22 = partner.feature[j,@feature.length]

			f1 = Set.new p11
			f2 = Set.new p22

			f1.merge p21
			f2.merge p12

			f1 = f1.to_a
			f2 = f2.to_a

			ret = Array.new
			ret.push(f1)
			ret.push(f2)

			return ret

		end
		return nil
	end
end

class SPopulation
	attr_accessor :people

	def initialize(path)
		@people = path
	end

	def mutation(seld)
		for j in seld
			@people[j].mutation
		end
	end

	def crossing(seld,graph)
		for j in 1..(seld.length - 1)
			@people[seld[j - 1]].crossing(graph,@people[seld[j]])
		end
	end

	def update_population(children,graph)
		j = 0

		for i in 0..@people.length - 1
			if j == children.length
				break
			end

			child_fit = [children[j].size,graph.neighbours(children[j])]
			aux = Domination(child_fit,@people[i].fitness)

			case aux
			when 1 then
				@people[i].feature = children[j]
				@people[i].fitness = child_fit
				j += 1
			when 0 then
				rnd = rand(2)
				if rnd == 1
					@people[i].feature = children[j]
					@people[i].fitness = child_fit
					j += 1
				end
			end

		end
	end

	def return_params()
		pop_size = @people.length
		cro_prob = @people[0].prob_crossing
		mut_prob = @people[0].prob_mutation
		rnge_val = @people[0].range_val

		return [pop_size,cro_prob,mut_prob,rnge_val]
	end

	def pop_values()
		@people.map {|x| x.feature}
	end

	def fitness()
		@people.map {|x| x.fitness}
	end
end
