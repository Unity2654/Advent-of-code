require "PriorityQueue";
--Reading the input file
race={}
f = io.open("puzzle.txt")
line = f:read("*line")
while line do
    row = {}
    for w in line:gmatch(".") do
        table.insert(row,w)
    end
    table.insert(race,row)
    line = f:read("*line")
end

-- Finding the start and end position
start,dest=nil,nil
for i,s in ipairs(race) do
    for j,e in ipairs(s) do
        if e=="S" then
            start = {i,j}
            race[i][j]="."
        end
        if e=="E" then
            dest = {i,j}
            race[i][j]="."
        end
    end
end

--
-- Part 1
--

function makeKey(v2)
    return v2[1].."_"..v2[2]
end

function unmakeKey(key)
    res = {}
    for w in key:gmatch("(-?%d+)") do table.insert(res,tonumber(w)) end
    return {res[1],res[2]}
end

function sum(v2a,v2b)
    return {v2a[1]+v2b[1],v2a[2]+v2b[2]}
end

function getAdj(position)
    local res = {}
    for i=-1,1 do
        for j=-1,1 do
            if math.abs(i)~=math.abs(j) then
                table.insert(res,sum(position,{i,j}))
            end
        end
    end
    return res
end

function Dijkstra(grid,start,walls)
    local dist,prev = {},{}

    function comparator(a,b)
        if dist[b] == nil then return false end
        if dist[a] == nil then return true end
        return dist[a]>dist[b]
    end

    local Q = PriorityQueue.new(comparator)
    dist[makeKey(start)]=0
    Q:Add(start,0)
    while Q:Size()>0 do
        local curr = Q:Pop()
        adj = getAdj(curr)
        for _,node in ipairs(adj) do
            local alt

            if not grid[node[1]] or not grid[node[1]][node[2]] or grid[node[1]][node[2]]==walls then
                goto continue
            end
            alt = dist[makeKey(curr)] + 1
            if not dist[makeKey(node)] then
                add = true
            end
            if (not dist[makeKey(node)]) or alt < dist[makeKey(node)] then
                dist[makeKey(node)] = alt
                prev[makeKey(node)] = makeKey(curr)
            end
            if add then
                Q:Add(node,makeKey(node))
            end
            ::continue::
            add = false
        end
    end
    return prev,dist
end

function distance(v1,v2)
    return math.sqrt((v1[1]-v2[1])^2 + (v1[2]-v2[2])^2)
end

function inBetween(v1,v2)
    return {(v1[1]+v2[1])//2,(v1[2]+v2[2])//2}
end

function isNodiagonal(v1,v2)
    local v = {v2[1]-v1[1],v2[2]-v1[2]}
    return (v[1]==0 or v[2]==0)
end

function findShortCut(path,shortCutLength,distances,minGain)
    local shortcuts = {}
    for i,p1 in pairs(path) do
        for j,p2 in pairs(path) do
            local pmid = inBetween(p1,p2)
            if j<i and isNodiagonal(p1,p2) and
               distance(p1,p2)<=shortCutLength and
               race[pmid[1]][pmid[2]]=="#" and
               (math.abs(distances[makeKey(p1)]-distances[makeKey(p2)])-2) >= minGain then
                table.insert(shortcuts,{{p1,p2},math.abs(distances[makeKey(p1)]-distances[makeKey(p2)])-2})
            end
        end
    end
    return shortcuts
end

prev,dist = Dijkstra(race,start,"#")
path = {}

curr = makeKey(dest)
while curr do
    n = unmakeKey(curr)
    table.insert(path,n)
    curr = prev[curr]
end

shortcuts = findShortCut(path,2,dist,100)

print(#shortcuts)

--
-- Part 2
--

function distance2(v1,v2)
    local v = {math.abs(v2[1]-v1[1]),math.abs(v2[2]-v1[2])}
    return (v[1]+v[2])
end

function substract(v1,v2)
    return {v2[1]-v1[1],v2[2]-v1[2]}
end

function isValidCheat(v1,v2,maxLength)
    return distance2(v1,v2)<=maxLength
end

function findShortCutv2(path,shortCutLength,distances,minGain)
    local shortcuts = {}
    for i,p1 in pairs(path) do
        for j,p2 in pairs(path) do
            local pmid = inBetween(p1,p2)
            if j<i and isValidCheat(p1,p2,shortCutLength) and
               (math.abs(distances[makeKey(p1)]-distances[makeKey(p2)])) > distance2(p1,p2) and
               (math.abs(distances[makeKey(p1)]-distances[makeKey(p2)])-distance2(p1,p2)) >= minGain then
                table.insert(shortcuts,{{p1,p2},math.abs(distances[makeKey(p1)]-distances[makeKey(p2)])-distance2(p1,p2)})
            end
        end
    end
    return shortcuts
end

longcuts = findShortCutv2(path,20,dist,100)

print(#longcuts)
