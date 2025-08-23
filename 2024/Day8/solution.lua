-- Reading the input file

input = {}

f = io.open("puzzle.txt")
line = f:read("*line")

while line do
    l = {}
    for w in line:gmatch(".") do
        table.insert(l,w)
    end
    table.insert(input,l)
    line = f:read("*line")
end

-- Finding the antennae
antennae = {}
for i,part in ipairs(input) do
    for j,w in ipairs(part) do
        if w ~= "." then
            if not antennae[w] then
                antennae[w] = {}
            end
            table.insert(antennae[w],{i,j})
        end
    end
end

--
-- Part 1
--

function distance(v1,v2)
    return {v1[1]-v2[1],v1[2]-v2[2]}
end

function sum(v1,v2)
    return {v1[1]+v2[1],v1[2]+v2[2]}
end

function findAntiNodes(antennae)
    for i,c in ipairs(antennae) do
        for j,c2 in ipairs(antennae) do
            if(c2[1]~= c[1] and c2[2] ~= c[2]) then
                d = distance(c,c2)
                antinode = sum(c,{d[1],d[2]})
                if input[antinode[1]] and input[antinode[1]][antinode[2]] then
                    input[antinode[1]][antinode[2]] = "#"
                end
            end
        end
    end
end

function countAntinodes()
    sum = 0
    for _,e in ipairs(input) do
        for _,f in ipairs(e) do
            if(f == "#") then
                sum = sum+1
            end
        end
    end
    return sum
end

--for _,a in pairs(antennae) do
--    findAntiNodes(a)
--end

--print(countAntinodes())

--
-- Part 2
--
function PGCD(a,b)
    if b==0 then
        return a
    end
    if a<0 or b<0 then
        return PGCD(math.abs(b),math.abs(a))
    end
    if(a<b) then
        return PGCD(b,a)
    end
    return PGCD(b,a%b)
end

function colinearFactor(v1,v2)
    d = distance(v1,v2)
    m = PGCD(d[1],d[2])
    return {d[1]/m,d[2]/m}
end

function findAntiNodesv2(antennae)
    for i,c in ipairs(antennae) do
        for j,c2 in ipairs(antennae) do
            if(c2[1]~= c[1] and c2[2] ~= c[2]) then
                d = colinearFactor(c,c2)
                antinode = sum(c,{d[1],d[2]})
                while input[antinode[1]] and input[antinode[1]][antinode[2]] do
                    input[antinode[1]][antinode[2]] = "#"
                    antinode = sum(antinode,{d[1],d[2]})
                end
                antinode = sum(c,{-d[1],-d[2]})
                while input[antinode[1]] and input[antinode[1]][antinode[2]] do
                    input[antinode[1]][antinode[2]] = "#"
                    antinode = sum(antinode,{-d[1],-d[2]})
                end
            end
        end
    end
end

for _,a in pairs(antennae) do
    findAntiNodesv2(a)
end

print(countAntinodes())
