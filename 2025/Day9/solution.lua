-- Parsing the input
corners = {}
f = io.open("smallPuzzle.txt")
text = f:read("*all")
for x,y in text:gmatch("(%d+),(%d+)") do
    table.insert(corners, {tonumber(x),tonumber(y)})
end

--
--- Part 1
--

function calcArea(v1,v2)
    return math.abs(v1[1] - v2[1]+1) * math.abs(v1[2] - v2[2]+1 )
end

function printVector(vector)
    print(vector[1],vector[2])
end

function maxArea()
    local max = 0
    for i,v in pairs(corners) do
        for j=(i+1),#corners do
            local v2 = corners[j]
            local area = calcArea(v,v2)
            if area > max then
                max = area
            end
        end
    end
    return max
end

--print(maxArea())

--
--- Part 2
--

function isVertical(head, tail)
    return head[2] ~= tail[2]
end

function generateEdges(c1, c2)
    local edges = {}
    local corner1 = {c1[1], c1[2]}
    local corner2 = {c2[1], c2[2]}
    local corner3 = {c2[1], c1[2]}
    local cornet4 = {c1[1], c2[2]}
    table.insert(edges, {corner1, corner3})
    table.insert(edges, {corner3, corner2})
    table.insert(edges, {corner2, cornet4})
    table.insert(edges, {cornet4, corner1})
    return edges
end

function isInInterval(number, b1, b2)
    --if b1 > b2 then return number <= b1 and number >= b2 end
    return number <= b2 and number >= b1
end

function isCrossing(e1, e2)
    if isVertical(e1[1], e1[2]) == isVertical(e2[1], e2[2]) then return false end
    --[[if e1[1] == e2[1] and e1[2] == e2[2] then return false end
    if isVertical(e1[1], e1[2]) and isVertical(e2[1], e2[2]) then
        return isInInterval(e1[1][2], e2[1][2], e2[2][2]) and isInInterval(e1[2][2], e2[1][2], e2[2][2])
    end
    if (not isVertical(e1[1], e1[2])) and (not isVertical(e2[1], e2[1])) then
        return isInInterval(e1[1][1], e2[1][1], e2[2][1]) and isInInterval(e1[2][1], e2[1][1], e2[2][1])
    end]]--
    if isVertical(e1[1], e1[2]) then
        return isInInterval(e2[1][2], e1[1][2], e1[2][2]) and isInInterval(e1[1][1], e2[1][1], e2[2][1])
    end
    return isInInterval(e1[1][2], e2[1][2], e2[2][2]) and isInInterval(e2[1][1], e1[1][1], e1[2][1])
end

function printEdge(e)
    print(e[1][1], e[1][2], e[2][1], e[2][2])
end

function isInRectangePoly(c1, c2)
    edges = generateEdges(c1,c2)
    for _,e in pairs(edges) do
        for _,e1 in pairs(allEdges) do
            if isCrossing(e, e1) then return false end
        end
    end
    return true
end

-- sorting the edges
allEdges = {}

for i,e in pairs(corners) do
    j = i+1
    if j > #corners then j = 1 end
    table.insert(allEdges, {e, corners[j]})
end

-- Computing the result
function maxAreaWithinPoly()
    local max = 0
    for i,v in pairs(corners) do
        for j=(i+1),#corners do
            local v2 = corners[j]
            local area = calcArea(v,v2)
            if isInRectangePoly(v,v2) then
                printVector(v)
                printVector(v2)
                print()
                max = area
            end
        end
    end
    return max
end

print(maxAreaWithinPoly())
