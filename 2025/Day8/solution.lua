require("treeSets")

maxConnexions = 1000

function computeDistance(v1,v2)
    return math.sqrt((v2[1] - v1[1])*(v2[1] - v1[1]) + (v2[2] - v1[2])*(v2[2] - v1[2]) + (v2[3] - v1[3])*(v2[3] - v1[3]))
end

-- Parsing the input
distances = {}
coordinates = {}
f = io.open("puzzle.txt")
text = f:read("*all")
for x,y,z in text:gmatch("(%d+),(%d+),(%d+)") do
    table.insert(distances, {})
    i = #distances
    for j,v in pairs(coordinates) do
        distances[i][j] = computeDistance(v, {x,y,z})
    end
    table.insert(coordinates, {x,y,z})
end

--
--- Part 1
--

function findLowestDistance()
    local minindex = nil
    local min = nil
    for i,l in pairs(distances) do
        for j,e in pairs(l) do
            if not min or e < min then
                min = e
                minindex = {i,j}
            end
        end
    end
    if minindex then
        distances[minindex[1]][minindex[2]] = nil
    end
    return minindex
end

function Part1()
    set = UniqSet.new()
    for _=1,maxConnexions do
        minindex = findLowestDistance()
        if not set:getReferent(minindex[1]) and not set:getReferent(minindex[2]) then
            set:newSet(minindex[1])
            set:addElement(minindex[2], minindex[1])
        else
            if not set:getReferent(minindex[2]) then
                set:addElement(minindex[2], minindex[1])
            else
                if not set:getReferent(minindex[1]) then
                    set:addElement(minindex[1], minindex[2])
                else
                    set:merge(minindex[2], minindex[1])
                end
            end
        end
    end
    sizes = {}
    for _,e in pairs(set.Size) do
        table.insert(sizes,e)
    end
    table.sort(sizes, function(a,b) return a>b end)
    return sizes[1] * sizes[2] * sizes[3]
end



--
--- Part 2
--

function printVector(v)
    for _,e in pairs(coordinates[v]) do
        io.write(e.." ")
    end
    print()
end

set = UniqSet.new()
lastIndex = nil
minindex = findLowestDistance()
while set:maxSize() ~= #coordinates do
    if not set:getReferent(minindex[1]) and not set:getReferent(minindex[2]) then
        set:newSet(minindex[1])
        set:addElement(minindex[2], minindex[1])
    else
        if not set:getReferent(minindex[2]) then
            set:addElement(minindex[2], minindex[1])
        else
            if not set:getReferent(minindex[1]) then
                set:addElement(minindex[1], minindex[2])
            else
                set:merge(minindex[2], minindex[1])
            end
        end
    end
    lastIndex = {minindex[1], minindex[2]}
    minindex = findLowestDistance()
end

print(coordinates[lastIndex[1]][1] * coordinates[lastIndex[2]][1])
