-- Parsing the input file
f = io.open("smallPuzzle.txt")
input = {}
line = f:read("*line")

while line do
    l = {}
    for c in line:gmatch(".") do
        if c == "." then
            table.insert(l,-1)
        else
            table.insert(l,tonumber(c))
        end
    end
    table.insert(input,l)
    line = f:read("*line")
end

--
-- Part 1
--
-- Finding trailheads
trailheads = {}

for i,p in ipairs(input) do
    for j,n in ipairs(p) do
        if n==0 then
            table.insert(trailheads,{i,j})
        end
    end
end

-- Finding the trails
function stringify(u,v)
    return u.."_"..v
end

function trail(x,y)
    sum = 0
    visited = {}
    toVisit = {{x,y}}
    tableindex=1
    while tableindex <= #toVisit do
        curr = toVisit[tableindex]
        tableindex=tableindex+1
        x,y = curr[1],curr[2]
        if not visited[stringify(x,y)] then
            if(input[x][y] == 9) then
                sum = sum+1
            end
            visited[stringify(x,y)] = "X"
            for i=-1,1 do
                for j=-1,1 do
                    if input[x+i] and input[x+i][y+j] and input[x+i][y+j] == input[x][y]+1 and math.abs(j)~=math.abs(i) then
                        table.insert(toVisit,{x+i,y+j})
                    end
                end
            end
        end
    end
    return sum
end

res = 0
for _,th in ipairs(trailheads) do
    res = res + trail(th[1],th[2])
end
print(res)

--
-- Part 2
--

function trailv2(x,y)
    sum = 0
    toVisit = {{x,y}}
    tableindex=1
    while tableindex <= #toVisit do
        curr = toVisit[tableindex]
        tableindex=tableindex+1
        x,y = curr[1],curr[2]
        if(input[x][y] == 9) then
            sum = sum+1
        end
        for i=-1,1 do
            for j=-1,1 do
                if input[x+i] and input[x+i][y+j] and input[x+i][y+j] == input[x][y]+1 and math.abs(j)~=math.abs(i) then
                    table.insert(toVisit,{x+i,y+j})
                end
            end
        end
    end
    return sum
end

res = 0
for _,th in ipairs(trailheads) do
    res = res + trailv2(th[1],th[2])
end
print(res)
