-- Parsing input
f = io.open("puzzle.txt")
line = f:read("*line")

input = {}
while line do
	a={}
	for c in line:gmatch(".") do
		table.insert(a,c)
	end
	table.insert(input,a)
	line = f:read("*line")
end

-- Finding the guard
initposition = {}

for i,part in ipairs(input) do
	for j,c in ipairs(part) do
		if not (c=="." or c=="#") then
			initposition = {i,j}
			break
		end
	end
end

--
-- Part 1
--

dir = 1
directions = {{-1,0},{0,1},{1,0},{0,-1}}
visited = {}
position = {initposition[1],initposition[2]}

function contains(table,pair)
	if not table[pair[1]] then
		return false
	end
	for _,j in ipairs(table[pair[1]]) do
		if j == pair[2] then
			return true
		end
	end
	return false
end

function sum(v1,v2)
	return {v1[1]+v2[1],v1[2]+v2[2]}
end

function stringify(pair)
	return ""..pair[1].."_"..pair[2]
end

function countX()
	exes = 0
	for _,i in ipairs(input) do
		for _,j in ipairs(i) do
			if(j=="X") then
				exes = exes+1
			end
		end
	end
	return exes
end

direction = directions[dir]
while true do
	if not visited[stringify(position)] then
		visited[stringify(position)] = {}
	end
	table.insert(visited[stringify(position)],stringify(direction))
	s = sum(position,direction)
	if input[s[1]] and input[s[1]][s[2]] then
		while input[s[1]][s[2]] == "#" do
			dir = dir+1
			if dir > #directions then
				dir = 1
			end
			direction = directions[dir]
			s = sum(position,direction)
		end
		input[position[1]][position[2]] = "X"
		position = sum(position,direction)
	else
		input[position[1]][position[2]] = "X"
		break
	end
end

print(countX())

--
-- Part 2
--

res = 0
for i,put in ipairs(input) do
	for j,_ in ipairs(put) do
		if input[i][j] == "X" and stringify({i,j}) ~= stringify(initposition) then
			input[i][j] = "#"
			dir = 1
			visited = {}
			position = {initposition[1],initposition[2]}
			direction = directions[dir]
			while true do
				if not visited[stringify(position)] then
					visited[stringify(position)] = {}
				end
				if contains(visited,{stringify(position),stringify(direction)}) then
					-- Loop detected
					res = res+1
					break
				end
				table.insert(visited[stringify(position)],stringify(direction))
				nextp = sum(position,direction)
				if input[nextp[1]] and input[nextp[1]][nextp[2]] then
					while input[nextp[1]][nextp[2]] == "#" do
						dir = dir+1
						if dir > #directions then
							dir = 1
						end
						direction = directions[dir]
						nextp = sum(position,direction)
					end
					position = {nextp[1],nextp[2]}
				else
					-- Guard exits the area
					break
				end
			end
			input[i][j] = "X"
		end
	end
end
::fin::
print(res)


