
-- Reading input file
f = io.open("puzzle.txt","r")
lines = {}
line = f:read("*line")
while(line) do
	table.insert(lines,line)
	line = f:read("*line")
end

-- Creating pairs
left = {}
right={}
for k,s in ipairs(lines) do
	it = s:gmatch("(%d+)")
	table.insert(left,it())
	table.insert(right,it())
end

table.sort(left)
table.sort(right)

--
-- Part 1
--

-- Calculating the final sum
sum = 0
for index,_ in ipairs(left) do
	sum = sum + math.abs(left[index] - right[index])
end

--print(sum)

--
-- Part 2
--
frequency = {}
current = nil
c = 1
for _,number in ipairs(right) do
	if(current == nil) then
		current = number
	else
		if(number == current) then
			c=c+1
		else
			frequency[current] = c
			current = number
			c=1
		end
	end
end
frequency[current] = c

sum = 0
for _,number in ipairs(left) do
	if(frequency[number] ~= nil) then
		sum = sum + number*frequency[number]
	end
end
print(sum)
