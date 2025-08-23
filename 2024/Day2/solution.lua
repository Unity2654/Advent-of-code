-- Reading and parsing the file
reports = {}

f = io.open("puzzle.txt")
line = f:read("*line")
while(line) do
	data = {}
	for w in line:gmatch("(%d+)") do
		table.insert(data,tonumber(w))
	end
	table.insert(reports,data)
	line = f:read("*line")
end

--
-- Part 1
--

function isSafe(data)
	prev = nil
	direction = nil
	if(data[1] > data[2]) then
		direction = function(a,b) return a>b end
	else
		direction = function(a,b) return a<b end
	end
	for i,d in pairs(data) do
		if(prev) then
			if(math.abs(d-prev) < 1 or math.abs(d-prev) > 3 or not(direction(prev,d))) then
				return false
			end
		end
		prev = d
	end
	return true
end

safe = 0
for _,r in ipairs(reports) do
	if(isSafe(r)) then
		safe = safe + 1
	end		
end

print(safe)

--
-- Part 2
--

function copy(t)
	o = {}
	for _,i in pairs(t) do
		table.insert(o,i)
	end
	return o
end

damp = 0
for _,r in pairs(reports) do
	if(isSafe(r)) then
		damp = damp+1
	else
		for i,_ in ipairs(r) do
			j = copy(r)
			table.remove(j,i)
			if(isSafe(j)) then
				damp = damp+1
				break
			end
		end
	end
end
print(damp)
		
