-- parsing the input
batteries = {}
f = io.open("puzzle.txt")
line = f:read("*line")
while line do
    batt = {}
    for l in line:gmatch("%d") do
        table.insert(batt, tonumber(l))
    end
    table.insert(batteries, batt)
    line = f:read("*line")
end

--
--- Part 1
--

function findMax(t, position)
    local max = nil
    for i=position, #t do
        if (not max) or t[i] > max then
            max = t[i]
        end
    end
    return max
end

function findBestCombination(batt)
    local best = 0
    for pos,b in pairs(batt) do
        local first = b
        local second = findMax(batt, pos+1)
        if second then
            local nb = tonumber(first..second)
            if nb == 99 then
                return nb
            end
            if nb > best then
                best = nb
            end
        end
    end
    return best
end

sum = 0
for _,battery in pairs(batteries) do
    sum = sum + findBestCombination(battery)
end
--print(sum)

--
--- Part 2
--

function findMax(batt, start, finish)
    local max = 0
    local index = 0
    for i=start,finish do
        if batt[i] > max then
            max = batt[i]
            index = i
        end
    end
    return max,index
end

totalLen = 12

function findBest(batt)
    local nb = ""
    local startIndex = 1
    for i=1,totalLen do
        local max,index = findMax(batt,startIndex,#batt - (totalLen - i))
        startIndex = index + 1
        nb = nb..max
    end
    return tonumber(nb)
end

sum = 0
for _,battery in pairs(batteries) do
    sum = sum + findBest(battery)
end
print(sum)
