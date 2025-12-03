-- Initialisation
dial = 50
max = 100

-- Reading the content of the file
lines = {}
f = io.open("smallPuzzle.txt")
line = f:read("*line")
while(line) do
    table.insert(lines, line)
    line = f:read("*line")
end

--
--- Part 1
--

function rotate(line)
    if line == "" then
        return
    end
    local direction = string.sub(line,1,1)
    local times = tonumber(string.sub(line,2))
    times = times % max
    if direction == "L" then
        dial = (dial - times) % max
    else
        dial = (dial + times) % max
    end
end

psswd = 0

for _,i in pairs(lines) do
    rotate(i)
    if dial == 0 then
        psswd = psswd + 1
    end
end

--
--- Part 2
--

dial = 50

function doTurn(direction, number)
	c = 0
	for i = 1,number do
		if direction == "L" then
			dial = dial - 1
			if dial < 0 then
				dial = max - 1
			end
		else
			dial = dial + 1
			if dial == max then
				dial = 0
			end
		end
		if dial == 0 then
			c = c + 1
		end
	end
	return c
end

function countZeros(line)
	if line == "" then
		return 0
	end
	local dir = string.sub(line,1,1)
	local times = tonumber(string.sub(line,2))
	res = doTurn(dir,times)
	return res
end

psswd = 0
for _,l in pairs(lines) do
	psswd = psswd + countZeros(l)
end
print(psswd)
