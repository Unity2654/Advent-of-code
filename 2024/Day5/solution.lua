f = io.open("puzzle.txt")
input = f:read("*all")

-- Reading all the rules
rules = {}
for rule in input:gmatch("(%d+|%d+)") do
	it = rule:gmatch("(%d+)")
	a = tonumber(it())
	b = tonumber(it())
	if not rules[a] then
		rules[a] = {}
	end
	table.insert(rules[a],b)
end

-- Reading all the printing updates
updates = {}
for update in input:gmatch("(%d+,.-)\n") do
	if(update ~= "") then
		up = {}
		for u in update:gmatch("(%d+)") do
			table.insert(up,tonumber(u))
		end
		table.insert(updates,up)
	end
end

--
-- Part 1
--
function find(number,table) 
	for i,n in pairs(table) do
		if n == number then
			return i
		end
	end
	return nili
end

function isPrevious(previous, number)
	if not rules[number] then
		return false
	end
	for i,n in ipairs(rules[number]) do
		if find(n,previous) then
			return true
		end
	end
	return false
end

function validUpdate(update) 
	previous = {}
	for _,n in ipairs(update) do
		if isPrevious(previous,n) then
			return false
		end
		table.insert(previous,n)
	end
	return true
end

sum = 0
for _,update in ipairs(updates) do
	if validUpdate(update) then
		sum = sum + update[#update//2+1] 
	end
end

--print(sum)

-- 
-- Part 2 
--

function order(n1,n2) 
	if not rules[n1] then
		return false
	end
	for _,r in ipairs(rules[n1]) do
		if r==n2 then
			return true
		end
	end
	return false
end

sum2=0

for _,update in ipairs(updates) do
	if not validUpdate(update) then
		table.sort(update,order)
		sum2 = sum2 + update[#update//2+1] 
	end
end

print(sum2)
