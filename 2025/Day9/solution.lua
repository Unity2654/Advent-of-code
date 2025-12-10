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

for _,c in pairs(corners) do
    table.insert(xAxis, c[1])
    table.insert(yAxis, c[2])
end

table.sort(xAxis)
table.sort(yAxis)
maxX = xAxis[#xAxis]
maxY = yAxis[#yAxis]


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


for _,c in pairs(redCorners) do
    x = c[1]
    y = c[2]
    grid[y][x] = "#"
end

for i,v in pairs(redCorners) do
    for j = (i+1),(#redCorners+1) do
        if j > #redCorners then
            j = 1
        end
        v1 = redCorners[j]
        if v1[1] == v[1] then
            min = math.min(v1[2],v[2])
            max = math.max(v1[2],v[2])
            for k=min,max do
                grid[k][v1[1]] = "#"
            end
        else
            min = math.min(v1[1],v[1])
            max = math.max(v1[1],v[1])
            print(min,max)
            for k=min,max do
                io.write("("..v1[2].." " ..k..") ")
                grid[v1[2]][k] = "#"
            end
            print()
        end
    end
end

for _,l in pairs(grid) do
    for _,e in pairs(l) do
        io.write(e)
    end
    print()
end
