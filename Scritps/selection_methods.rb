#!/usr/bin/ruby -w

def Domination(first,second)
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
