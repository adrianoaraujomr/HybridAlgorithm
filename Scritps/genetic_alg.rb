#!/usr/bin/ruby -w

require 'set'

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
#			puts "G " + i.to_s
			eval = @population.fitness
			if(i == 0 or i == @generations - 1)
				aux = eval.map{|x| x[1]}
				puts aux.inspect
			end

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

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------# Selection
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

def Domination(first,second)
	if    first[0] > second[0]
		return 1
	elsif first[0] < second[0]
		return 2
	end

	if first[1] < second[1]
		return 1
	elsif first[1] > second[1]
		return 2
	end
	
	return 0

end

class Tournament
	def run(pop,sr)
		n_sorteios = sr*pop.length
		n_sorteios = n_sorteios.round

		aux = Array.new()
		while aux.size < n_sorteios
			st  = rand(pop.length)
			nd  = rand(pop.length)
			
			first  = pop[st]
			second = pop[nd]

			#[0] - number of nodes
			#[1] - number of distinct followers/friends
			dom = Domination(first,second)
			case dom
			when 1 then
				aux.push(st)
			when 2 then
				aux.push(nd)
			else
				val = rand(2)
				if val == 1
					aux.push(st)
				else
					aux.push(nd)
				end
			end
		end
	return aux
	end
end

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Individual
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class IndividualGraph
	@@graph         = SocialNetwork.new
	@@prob_mutation = 0.01
	@@prob_crossing = 0.8
	@@a             = 1
	@@b             = 3
	attr_accessor :feature
	attr_accessor :fitness

	def initialize(path)
		@feature = path
	end

	def fitness()
		return [@@graph.neighbours(@feature),@feature.size]
	end

	def mutation()
		if rand() <= @@prob_mutation
			nro = rand(10) + 10
			spl = @@graph.keys.sample(nro)

			aux_1 = Set.new spl
			aux_2 = Set.new @feature
			aux_1.merge aux_2

			@feature = aux_1.to_a
		end
	end

	# Maybe change the way of change points
	def crossing(graph,partner)
		if rand() <= @@prob_crossing
			i = rand(@feature.length) + 1

			p11 = @feature[0,i]
			p12 = @feature[i,@feature.length]

			j = rand(partner.feature.length) + 1
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

	def prob_mutation()
		return @@prob_mutation
	end

	def prob_crossing()
		return @@prob_crossing
	end

	def range_val()
		return [@@a,@@b]
	end
end

class SPopulation
	attr_accessor :people

	def initialize(paths)
		@people = []
		for ant in paths
			@people.push(IndividualGraph.new(ant))
		end
	end

	def mutation(seld)
		for j in seld
			@people[j].mutation
		end
	end

	def crossing(seld,graph)
		childs = Array.new
		for j in 1..(seld.length - 1)
			aux = @people[seld[j - 1]].crossing(graph,@people[seld[j]])
			if aux != nil
				childs += aux
			end
		end
		return childs
	end

	# This function could be cuasing trouble childs x paretns
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
