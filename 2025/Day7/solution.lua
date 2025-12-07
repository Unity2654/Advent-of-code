-- Parsing the input

f = io.open("smallPuzzle.txt")
source = {}
grid = {}



line = f:read("*line")
while line do
    l = {}
    x = 1
    for c in line:gmatch(".") do
        if c == "S" then
            source = {x,1}
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

cache = {}

function beam(start)
    local coords = start
    if cache[serialize(start)] then
        return cache[serialize(start)]
    end
    while grid[coords[2]] and grid[coords[2]][coords[1]] do
        print(coords[2], coords[1], grid[coords[2]][coords[1]])
        if grid[coords[2]][coords[1]] == "^" then
            local value = 1 + beam({coords[1]+1, coords[2]}) + beam({coords[1]-1, coords[2]})
            cache[serialize(start)] = value
            return value
        end
        grid[coords[2]][coords[1]] = "#"
        coords[2] = coords[2] + 1
    end
    cache[serialize(start)] = 0
    return 0
end

print(beam(source))

for _,e in pairs(grid) do
    for _,i in pairs(e) do
        io.write(i)
    end
    print()
end

