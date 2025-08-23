-- Reading file

f = io.open("puzzle.txt")
data = {}
line = f:read("*line")
while line do
	l = {}
	for c in line:gmatch(".") do
		table.insert(l,c)
	end
	table.insert(data,l)
	line = f:read("*line")
end

--
-- Part 1
--

function getFullWord(origin, length, offset)
	res = ""
	while length>0 do
		if(data[origin[1]] and data[origin[1]][origin[2]]) then
			res = res .. data[origin[1]][origin[2]] 
			origin[1] = origin[1] + offset[1]
			origin[2] = origin[2] + offset[2]
			length = length-1
		else 
			break
		end
	end
	return res
end

xmases = 0

for i,sub in ipairs(data) do
	for j,letter in ipairs(sub) do
		if(letter == "X") then
			for a=-1,1 do
				for b = -1,1 do
					if not(a==0 and b==0) then
						w = getFullWord({i,j},4,{a,b})
						if(w == "XMAS") then
							xmases = xmases +1
						end
					end
				end
			end
		end
	end
end
print(xmases)

--
-- Part 2
-- 

function sum(tableA,tableB)
	return {tableA[1] + tableB[1], tableA[2] + tableB[2]}
end

function getCrossWord(origin)
	res = {}
	if data[origin[1]-1] and data[origin[1]+1] and data[origin[1]-1][origin[2]-1] and data[origin[1]+1][origin[1]+1] 
		and data[origin[1]-1][origin[2]+1] and data[origin[1]+1][origin[1]-1] then
		table.insert(res, data[origin[1]-1][origin[2]-1] .. data[origin[1]][origin[2]] .. data[origin[1]+1][origin[2]+1])
		table.insert(res, data[origin[1]+1][origin[2]-1] .. data[origin[1]][origin[2]] .. data[origin[1]-1][origin[2]+1])
	end
	return res
end

Xmases = 0

for i,sub in ipairs(data) do
	for j,letter in ipairs(sub) do
		if letter == "A" then
			t = getCrossWord({i,j})
			if(t[1] == "MAS" or t[1] == "SAM") and (t[2] == "MAS" or t[2] == "SAM") then
				Xmases = Xmases +1
			end
		end
	end
end

print(Xmases)
