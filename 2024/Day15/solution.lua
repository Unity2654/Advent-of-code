-- Reading the input
f = io.open("puzzle.txt")
initialPosition = {}
grid = {}
instructions = {}
directions = {v={1,0}}
directions[">"] = {0,1}
directions["^"] = {-1,0}
directions["<"] = {0,-1}

line = f:read("*line")
while line ~= "" do
    row = {}
    for c in line:gmatch(".") do
        table.insert(row,c)
    end
    table.insert(grid,row)
    line = f:read("*line")
end
line = f:read("*line")
while line do
    for d in line:gmatch(".") do
        table.insert(instructions,directions[d])
    end
    line = f:read("*line")
end

for i,s in ipairs(grid) do
    for j,e in ipairs(s) do
        if e== "@" then
            initialPosition = {i,j}
            grid[i][j] = "."
            break
        end
    end
end

--
-- Part 1
--

function sum(v1,v2)
    return {v1[1]+v2[1],v1[2]+v2[2]}
end

function findValidMove(g,p,d)
    if g[p[1]][p[2]] == "#" then
        return nil
    end
    if g[p[1]][p[2]] == "." then
        return p
    end
    return findValidMove(g,sum(p,d),d)
end

function sumBoxes(g)
    local sum = 0
    for i,s in ipairs(g) do
        for j,e in ipairs(s) do
            if e == "O" or e=="[" then
                sum = sum + 100*(i-1)+(j-1)
            end
        end
    end
    return sum
end

p = {initialPosition[1],initialPosition[2]}

for _,i in ipairs(instructions) do
    newP = sum(p,i)
    if grid[newP[1]][newP[2]] == "#" then
        goto continue
    end
    if grid[newP[1]][newP[2]] == "O" then
        boxMove = findValidMove(grid,newP,i)
        if boxMove == nil then
            goto continue
        end
        grid[newP[1]][newP[2]] = "."
        grid[boxMove[1]][boxMove[2]] = "O"
    end
    p = newP
    ::continue::
end

print(sumBoxes(grid))


--
-- Part 2
--

-- Parsing the input **AGAIN**
newgrid = {}
f = io.open("puzzle.txt")
line = f:read("*line")
while line ~= "" do
    row = {}
    for c in line:gmatch(".") do
        if c == "O" then
            table.insert(row,"[")
            table.insert(row,"]")
        else
            if c == "@" then
                table.insert(row,c)
                table.insert(row,".")
            else
                table.insert(row,c)
                table.insert(row,c)
            end
        end
    end
    table.insert(newgrid,row)
    line = f:read("*line")
end

for i,s in ipairs(newgrid) do
    for j,e in ipairs(s) do
        if e=="@" then
            initialPosition = {i,j}
            newgrid[i][j] = "."
            break
        end
    end
end

function hasNilValue(g)
    if not g then return nil end
    for i,a in pairs(g) do
        if i>#g then
            return true
        end
    end
    return false
end

function findValidMovev2(g,p,d)
    if g[p[1]][p[2]] == "#" then
        return nil
    end
    if g[p[1]][p[2]] == "." then
        return {p}
    end
    if d[1]==0 then
        return findValidMovev2(g,sum(p,d),d)
    end
    local res = {}
    local s = sum(p,d)
    local l,r
    if g[p[1]][p[2]] == "[" then
        l,r = findValidMovev2(g,s,d),findValidMovev2(g,{s[1],s[2]+1},d)
    else
        l,r = findValidMovev2(g,{s[1],s[2]-1},d),findValidMovev2(g,s,d)
    end
    if hasNilValue(l) or not l or not r or hasNilValue(r) then
        return nil
    end
    if #l > 1 or #r==1 then
        for _,i in ipairs(l) do
            table.insert(res,i)
        end
    end
    if #r>1 or #l == 1 then
        for _,i in ipairs(r) do
            table.insert(res,i)
        end
    end
    return res
end

p = {initialPosition[1],initialPosition[2]}

for _,i in ipairs(instructions) do
    newP = sum(p,i)
    if newgrid[newP[1]][newP[2]] == "#" then
        goto continue
    end
    while newgrid[newP[1]][newP[2]] == "[" or newgrid[newP[1]][newP[2]] == "]" do
        boxMove = findValidMovev2(newgrid,newP,i)
        if boxMove == nil then
            goto continue
        end
        boxOrder = {"["}
        boxOrder[0]="]"
        if i[1]== 0 then
            pos=boxMove[1]
            if i[2]==1 then j = 0 else j=1 end
            while pos[2]~=newP[2] do
                newgrid[pos[1]][pos[2]] = boxOrder[j%2]
                pos = sum(pos,{0,-i[2]})
                j=j+1
            end
            newgrid[newP[1]][newP[2]] = "."
        else
            for j,pos in ipairs(boxMove) do
                newgrid[pos[1]][pos[2]] = boxOrder[j%2]
                if i[1] == 1 then
                    newgrid[pos[1]-1][pos[2]] = "."
                else
                    newgrid[pos[1]+1][pos[2]] = "."
                end
            end
        end
    end
    p = newP
    ::continue::
end

print(sumBoxes(newgrid))
