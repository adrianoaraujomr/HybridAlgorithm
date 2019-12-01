#!/usr/bin/ruby -w

# Cada um dos algoritmos:
#	Recebe vetor de fitness
#	Retorna index dos selecionados

def Domination(first,second)
	# Rel dom 1
#	if    (first[0] < second[0] and first[1] >= second[1]) or (first[1] > second[1] and first[0] <= second[0]) or (second[0] == 0)
#		return 1
#	elsif (first[0] > second[0] and first[1] <= second[1]) or (first[1] < second[1] and first[0] >= second[0]) or (first[0] == 0)
#		return 2
#	else
#		return 0
#	end

	# Rel dom 2
	if    first[1] > second[1]
		return 1
	elsif first[1] < second[1]
		return 2
	end

	if first[0] < second[0]
		return 1
	elsif first[0] > second[0]
		return 2
	end
	
	return 0

end

class Tournament
# 1 in 2, change to m in n (m < n)
# Try EVO format 3 in 8
	def run(pop,sr)
		n_sorteios = sr*pop.length
		n_sorteios = n_sorteios.round

		aux = Array.new()
		while aux.size <= n_sorteios
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

class URandom
	def run(pop,sr)
		@population     = pop
		@selection_rate = sr 

		n_sorteios = @selection_rate*@population.length
		n_sorteios = n_sorteios.round

		selected = Array.new

		for i in 1..n_sorteios do
			aux = rand @population.length
			selected.push(aux)
		end

		return selected
	end
end


class Roulette
	# Probably will need changes, or changes in fitness will be necessary
	def probabilities()
		min = @population.sort.pop
		@population = @population.map{|x| (x - min)}
		sum = @population.inject(0){|sum,x| sum + x.abs}

		probs = Array.new
		aux   = 0
		for i in @population do
			aux += i.abs.fdiv(sum)
			probs.push(1 - aux)
		end

		return probs.reverse
	end

	def run(pop,sr)
		@population     = pop
		@selection_rate = sr

		n_sorteios = @selection_rate*@population.length
		n_sorteios = n_sorteios.round

		probs = self.probabilities()
		selected = Array.new
		for i in 1..n_sorteios do
			aux = rand()
			sl  = probs.rindex{|x| x < aux} #maybe this will need to change/ will return the last to satisfies the condition
			selected.push(sl)
		end

		return selected
	end
end


