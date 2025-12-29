-- Parsing the input
corners = {}
f = io.open("puzzle.txt")
text = f:read("*all")
for x,y in text:gmatch("(%d+),(%d+)") do
    table.insert(corners, {tonumber(x),tonumber(y)})
end

--
--- Part 1
--

function calcArea(v1,v2)
    return math.abs(math.max(v1[1], v2[1]) - math.min(v1[1], v2[1]) + 1) * math.abs(math.max(v1[2], v2[2]) - math.min(v1[2], v2[2]) + 1)
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

function indexof(table, number)
    for i,e in pairs(table) do
        if number == e then return i end
    end
    return nil
end

--- Distance compression

-- sorting the edges coordinates
xAxis = {}
yAxis = {}
xAxisSet = {}
yAxisSet = {}

for _,c in pairs(corners) do
    if not xAxisSet[c[1]] then
        table.insert(xAxis, c[1])
        xAxisSet[c[1]] = true
    end
    if not yAxisSet[c[2]] then
        table.insert(yAxis, c[2])
        yAxisSet[c[2]] = true
    end
end

table.sort(xAxis)
table.sort(yAxis)
maxX = #xAxis
maxY = #yAxis

-- Reducing the grid
redCorners = {}

for _,c in pairs(corners) do
    table.insert(redCorners,{indexof(xAxis,c[1]), indexof(yAxis,c[2])})
end

-- Generating the grid
grid = {}
for i=1,maxY do
    grid[i] = {}
    for j=1,maxX do
        grid[i][j] = '.'
    end
end

for i,v in pairs(redCorners) do
    j = i + 1
    if j > #redCorners then
        j = 1
    end
    v1 = redCorners[j]

    if v1[1] == v[1] then
        min = math.min(v1[2],v[2])
        max = math.max(v1[2],v[2])
        for k=min,max do
            if grid[k] then
                if v[2] > v1[2] then
                    grid[k][v1[1]] = "^"
                else
                    grid[k][v1[1]] = "v"
                end
            end
        end
    else
        min = math.min(v1[1],v[1])
        max = math.max(v1[1],v[1])
        for k=min,max do
            if grid[v1[2]][k] == '.' then
                grid[v1[2]][k] = "#"
            end
        end
    end
end

-- Filling the grid
for y=1,#grid do
    ispip = false
    for x = 1,(#grid[1]) do
        if (not ispip) and grid[y][x] == "^" then
            ispip = true
        end
        if ispip and grid[y][x] == "v" then
            ispip = false
        end
        if ispip or grid[y][x] == "v" then
            grid[y][x] = "#"
        end
    end
end

-- Utilities
function stringify(p)
    return p[1].."_"..p[2]
end

function pip(point)
    return grid[point[2]][point[1]] == "#"
end

function isRectInPoly(c1, c2)
    local redc1 = {indexof(xAxis,c1[1]), indexof(yAxis,c1[2])}
    local redc2 = {indexof(xAxis,c2[1]), indexof(yAxis,c2[2])}
    for x = math.min(redc1[1], redc2[1]),math.max(redc1[1], redc2[1]) do
        for y = math.min(redc1[2], redc2[2]),math.max(redc1[2], redc2[2]) do
            if not pip({x,y}) then
                return false
            end
        end
    end
    return true
end

function maxArea2()
    local max = 0
    local maxRect = {}
    for _,v in pairs(corners) do
        for _,v2 in pairs(corners) do
            local area = calcArea(v,v2)
            if area > max and isRectInPoly(v,v2) then
                max = area
                maxRect = {{v[1],v[2]},{v2[1],v2[2]}}
            end
        end
    end

    return max
end

print(maxArea2())

