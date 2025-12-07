require("PriorityQueue")
-- Parsing the input

f = io.open("puzzle.txt")
source = {}
grid = {}

line = f:read("*line")
while line do
    l = {}
    x = 1
    for c in line:gmatch(".") do
        if c == "S" then
            source = {1,x}
        end
        x = x + 1
        table.insert(l,c)
    end
    x = 1
    table.insert(grid, l)
    line = f:read("*line")
end

--
--- Part 1
--

function serialize(vector)
    return vector[1].."_"..vector[2]
end

Q = PriorityQueue.new(comparator)
function beam(start)
    local splits = 0
    Q:Add(start, -start[1])
    while Q:Size() > 0 do
        local coords = Q:Pop()
        if grid[coords[1]] and grid[coords[1]][coords[2]] and grid[coords[1]][coords[2]] ~= "|" then
            while grid[coords[1]] and grid[coords[1]][coords[2]] do
                if grid[coords[1]][coords[2]] == "^" then
                    splits = splits + 1
                    Q:Add({coords[1],coords[2]+1}, -coords[1])
                    Q:Add({coords[1],coords[2]-1}, -coords[1])
                    break;
                end
                grid[coords[1]][coords[2]] = "|"
                coords[1] = coords[1] + 1
            end
        end
    end
    return splits
end

--
--- Part 2
--

cache = {}

function timelines(start)
    local coords = start
    local startingcoords = {start[1],start[2]}
    if cache[serialize(startingcoords)] then
        return cache[serialize(startingcoords)]
    end
    while grid[coords[1]] and grid[coords[1]][coords[2]] do
        if grid[coords[1]][coords[2]] == "^" then
            local value = timelines({coords[1], coords[2]+1}) + timelines({coords[1], coords[2]-1})
            cache[serialize(startingcoords)] = value
            return value
        end
        grid[coords[1]][coords[2]] = "|"
        coords[1] = coords[1] + 1
    end
    cache[serialize(startingcoords)] = 1
    return 1
end

print(timelines(source))
