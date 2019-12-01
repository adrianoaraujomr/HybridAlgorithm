#!/usr/bin/ruby -w

require 'set'
require "./file_to_hash"
require "./selection_methods.rb"

class SocialNetwork
#	@@graph = read_transform()
	@@graph = edge_list_to_hash()

	def show_graph()
		return @@graph
	end

	def keys()
		return @@graph.keys
	end

	def neighbours(nodes)
		neigh = Set.new

		for v in nodes
			aux = Set.new @@graph[v] 
			neigh.merge aux
		end

		return neigh.length
	end
end

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Individual 02
#	array of nodes
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Change fitness
#   Idea : size of followers set and if the followers set is in the max size it decrement by the number of nodes in the path
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

	# sortear entre (troca, remoção, adição de nos no vetor de individuo)
	def mutation_1()
		if rand() <= @@prob_mutation
			if @feature.length <= 1 
				idx = rand(2)
			else
				idx = rand(3)
			end

			case idx
			when 1 then
				loop do
					aux = @keys.sample
					if ((not @feature.include? aux) and (aux != nil))
						@feature.push(aux)	
						break
					end
				end 
			when 2 then
					aux = rand(@feature.length)
					@feature.delete_at(aux)
			else
				loop do
					aux = @keys.sample
					if ((not @feature.include? aux) and (aux != nil))
						@feature.push(aux)	
						break
					end
				end 
				aux = rand(@feature.length)
				@feature.delete_at(aux)
			end

			fit = Array.new()
			flw = @graph.neighbours(@feature)
			fit.push(@feature.size,flw)
			@fitness = fit

			if @feature.include? nil
				puts "Here on mut"
				puts idx
			end
		end
	end

	# More simple and agressive mutation
	def mutation_2()
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
	def crossing_1(graph,partner)
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

	# Ideia 2 : sortear algumas posições e fazer trocas (1 or more)
	def crossing_2(graph,partner)
		if rand() <= @@prob_crossing
			if Set.new(@feature) == Set.new(partner.feature)
				return nil
			end

			p1 = @feature
			f1 = @fitness
			p2 = partner.feature
			f2 = partner.fitness

			aux1 = @feature.sample
#			while partner.feature.include? aux1 
#				aux1 = @feature.sample
#			end
			aux2 = partner.feature.sample
#			while @feature.include? aux2
#				aux2 = partner.feature.sample
#			end
 
			@feature.delete(aux1)
			partner.feature.delete(aux2)

			partner.feature.push(aux1)
			@feature.push(aux2)

			f1xp1 = Domination(f1,@fitness)
			f2xp2 = Domination(f2,partner.fitness)

			if f1xp1 == 1
				@feature = p1
			end 

			if f2xp2 == 1
				partner.feature = p2
			end

			fit = Array.new()
			flw = @graph.neighbours(@feature)
			fit.push(@feature.size,flw)
			@fitness = fit

		end
		return nil
	end
end

class SPopulation
	attr_accessor :people

	def initialize(nro,graph)
		@people =  Array.new()

		for i in 1..nro do
			@people.push(IndividualGraph.new(graph))
		end
	end

	def mutation_1(seld)
		for j in seld
			@people[j].mutation_1
		end
	end

	def mutation_2(seld)
		for j in seld
			@people[j].mutation_2
		end
	end

	def crossing_1(seld,graph)
		aux = Set.new
		for j in 1..(seld.length - 1)
			ret = @people[seld[j - 1]].crossing_1(graph,@people[seld[j]])
			if !ret.nil? 
				aux.merge ret
			end
		end
		aux = aux.to_a
		return aux
	end

	def crossing_2(seld,graph)
		for j in 1..(seld.length - 1)
			@people[seld[j - 1]].crossing_2(graph,@people[seld[j]])
		end
	end

	def return_params()
		pop_size = @people.length
		cro_prob = @people[0].prob_crossing
		mut_prob = @people[0].prob_mutation
		rnge_val = @people[0].range_val

		return [pop_size,cro_prob,mut_prob,rnge_val]
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

	def pop_values()
		@people.map {|x| x.feature}
	end

	def fitness()
		@people.map {|x| x.fitness}
	end

end

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Individual 01
#	minimizar x² + 100x - 16
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$limit = 100

class IndividualCube
	@@prob_mutation = 0.1
	@@prob_crossing = 0.8

	attr_accessor :value

	def initialize(value)
		@value = value 
	end

	def fitness()
		return (@value**2) + 100*@value - 16
	end

	def mutation()
		if rand() <= @@prob_mutation
			p = [true, false].sample
			if p 
				@value = @value - 1
			else 
				@value = @value + 1
			end
		end
	end

	def crossing(partner)
		if rand() <= @@prob_crossing
			aux = IndividualCube.new((@value + partner.value)/2)
			if aux.fitness() < self.fitness()
				@value = aux.value
			end
			if aux.fitness() < partner.fitness()
				partner.value = aux.value
			end
		end
	end
end

class Population
	attr_accessor :people

	def initialize(nro)
		@people =  Array.new()

		for i in 1..nro do
			value = (-1)*(rand $limit) - 1000#- value/2
			@people.push(IndividualCube.new(value))
		end
	end

	def pop_values()
		@people.map {|x| x.value}
	end

	def fitness()
		@people.map {|x| x.fitness}
	end
end
