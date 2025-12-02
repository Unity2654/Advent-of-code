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

function getZeroHits(number)
    local c = 0
    while number > max do
        c = c+1
        number = number - max
    end
    while number < 0 do
        c = c+1
        number = number + max
    end
    return c
end

function rotateMore(line)
    if line == "" then
        return 0
    end
    local direction = string.sub(line,1,1)
    local totalTimes = tonumber(string.sub(line,2))
    local hitzero = 0
    if direction == "L" then
        hitzero = getZeroHits(dial - totalTimes)
        dial = (dial - totalTimes) % max
    else
        hitzero = getZeroHits(dial + totalTimes)
        dial = (dial + totalTimes) % max
    end
    return hitzero
end

psswd = 0

for _,i in pairs(lines) do
    psswd = psswd + rotateMore(i)
end

print(psswd)
