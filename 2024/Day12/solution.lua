-- Parsing puzzle
f = io.open("puzzle.txt")
gardens = {}

line=f:read("line")
while line do
    l = {}
    for c in line:gmatch(".") do
        table.insert(l,c)
    end
    table.insert(gardens,l)
    line=f:read("line")
end

function deepCopy(array)
    local garden = {}
    for _,parcel in ipairs(array) do
        local g = {}
        for _,plants in ipairs(parcel) do
            table.insert(g,plants)
        end
        table.insert(garden,g)
    end
    return garden
end
--
-- Part 1
--

function str(vec2)
    return vec2[1].."_"..vec2[2]
end

function str2(vec4)
    return vec4[1].."_"..vec4[2].."_"..vec4[3].."_"..vec4[4]
end

function getAdj(i,j)
    res = {}
    for u=-1,1 do
        for v=-1,1 do
            if math.abs(u) ~= math.abs(v) then
                table.insert(res,{i+u,j+v})
            end
        end
    end
    return res
end

function parsestr(str)
    res = {}
    for n in str:gmatch("%-?%d+") do
        table.insert(res,tonumber(n))
    end
    return res
end

function countEntries(table)
    local res = 0
    for _,_ in pairs(table) do
        res = res+1
    end
    return res
end

function DFS(start)
    local i,j = start[1],start[2]
    local plant = gardens[i][j]
    local visited = {}
    local index = 1
    local toVisit = {{i,j}}
    local perimeter = 0
    while toVisit[index] do
        local curr = toVisit[index]
        if not visited[str(curr)] then
            visited[str(curr)]=true
            local adj = getAdj(curr[1],curr[2])
            for _,p in ipairs(adj) do
                if gardens[p[1]] and gardens[p[1]][p[2]] == plant then
                    table.insert(toVisit,p)
                else
                    perimeter = perimeter+1
                end
            end
        end
        index = index+1
    end
    return perimeter,visited
end

price = 0
gardens2 = deepCopy(gardens)

for i,g in ipairs(gardens) do
    for j,f in ipairs(g) do
        if f ~= "#" then
            p,visit = DFS({i,j})
            price = price + p*(countEntries(visit))
            for vec2,_ in pairs(visit) do
                vec = parsestr(vec2)
                gardens[vec[1]][vec[2]] = "#"
            end
        end
    end
end
print(price)

--
-- Part 2
--

function subvec(v1,v2)
    return {v1[1]-v2[1],v1[2]-v2[2]}
end

function addvec(v1,v2)
    return {v1[1]+v2[1],v1[2]+v1[2]}
end

function DFS2(start)
    local i,j = start[1],start[2]
    local plant = gardens2[i][j]
    local visited = {}
    local index = 1
    local toVisit = {{i,j}}
    local edges = {}
    while toVisit[index] do
        local curr = toVisit[index]
        if not visited[str(curr)] then
            visited[str(curr)]=true
            local adj = getAdj(curr[1],curr[2])
            for _,p in ipairs(adj) do
                if gardens2[p[1]] and gardens2[p[1]][p[2]] == plant then
                    table.insert(toVisit,p)
                else
                    local substract = subvec(curr,p)
                    edges[str2({curr[1],curr[2],substract[1],substract[2]})] = true
                end
            end
        end
        index = index+1
    end
    return edges,visited
end

function countEdges(edges)
    local count = 0
    local marked = {}
    for edge,_ in pairs(edges) do
        if not marked[edge] then
            marked[edge] = true
            local curr = parsestr(edge)
            count = count+1
            -- If the barrier is on the y axis
            if curr[3]==0 then
                -- On the right
                local offset = 1
                local adj = str2({curr[1]+offset,curr[2],curr[3],curr[4]})
                while edges[adj] do
                    offset = offset + 1
                    marked[adj] = true
                    adj = str2({curr[1]+offset,curr[2],curr[3],curr[4]})
                end
                -- On the left
                local offset = -1
                local adj = str2({curr[1]+offset,curr[2],curr[3],curr[4]})
                while edges[adj] do
                    offset = offset - 1
                    marked[adj] = true
                    adj = str2({curr[1]+offset,curr[2],curr[3],curr[4]})
                end
            else
                -- On the top
                local offset = 1
                local adj = str2({curr[1],curr[2]+offset,curr[3],curr[4]})
                while edges[adj] do
                    offset = offset + 1
                    marked[adj] = true
                    adj = str2({curr[1],curr[2]+offset,curr[3],curr[4]})
                end
                -- On the left
                local offset = -1
                local adj = str2({curr[1],curr[2]+offset,curr[3],curr[4]})
                while edges[adj] do
                    offset = offset - 1
                    marked[adj] = true
                    adj = str2({curr[1],curr[2]+offset,curr[3],curr[4]})
                end
            end
        end
    end
    return count
end

bulkprice = 0
for i,g in ipairs(gardens2) do
    for j,f in ipairs(g) do
        if f ~= "#" then
            local edges,visit = DFS2({i,j})
            bulkprice = bulkprice + countEdges(edges)*(countEntries(visit))
            for vec2,_ in pairs(visit) do
                vec = parsestr(vec2)
                gardens2[vec[1]][vec[2]] = "#"
            end
        end
    end
end
print(bulkprice)
