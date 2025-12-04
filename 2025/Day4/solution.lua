-- Parsing the input
grid = {}
f = io.open("puzzle.txt")
line = f:read("*line")

while line do
    row = {}
    for c in line:gmatch(".") do
        table.insert(row,c)
    end
    table.insert(grid, row)
    line = f:read("*line")
end

function printGrid(G)
    for _,i in pairs(G) do
        for _,j in pairs(i) do
            io.write(j)
        end
        print()
    end
end

--
--- First part
--

function isAccessible(G, x, y)
    local nbRolls = 0
    for i=x-1,x+1 do
        for j=y-1,y+1 do
            if (i ~= x or j ~= y) and G[i] and (G[i][j] == "x" or G[i][j] == "@") then
                nbRolls = nbRolls + 1
            end
        end
    end
    return nbRolls < 4
end

function part1()
    local accessible = 0
    for x,row in pairs(grid) do
        for y,roll in pairs(row) do
            if roll == "@" and isAccessible(grid,x,y) then
                accessible = accessible + 1
            end
        end
    end
    return accessible
end

--
--- Part 2
--

function removeAccessible(G)
    local removed = 0
    for x,row in pairs(G) do
        for y,roll in pairs(row) do
            if roll == "@" and isAccessible(G,x,y) then
                G[x][y] = '.'
                removed = removed + 1
            end
        end
    end
    return removed
end

totalRemoved = 0
removed = removeAccessible(grid)
while removed > 0 do
    totalRemoved = totalRemoved + removed
    removed = removeAccessible(grid)
end
print(totalRemoved)
