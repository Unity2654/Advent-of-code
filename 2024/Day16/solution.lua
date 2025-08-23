require "PriorityQueue";
-- Parsing the input file
f = io.open("puzzle.txt")
grid = {}
line = f:read("*line")
while line do
    row = {}
    for w in line:gmatch(".") do
        table.insert(row,w)
    end
    table.insert(grid,row)
    line = f:read("*line")
end

start = {}
dest = {}
for i,s in ipairs(grid) do
    for j,e in ipairs(s) do
        if e == "S" then
            start = {i,j}
        end
        if e == "E" then
            dest = {i,j}
        end
    end
end

--
-- Part 1
--

function makeKey(v2,d2)
    return v2[1].."_"..v2[2].."_"..d2[1].."_"..d2[2]
end

function unmakeKey(key)
    res = {}
    for w in key:gmatch("(-?%d+)") do table.insert(res,tonumber(w)) end
    return {res[1],res[2]},{res[3],res[4]}
end

function sum(v2a,v2b)
    return {v2a[1]+v2b[1],v2a[2]+v2b[2]}
end

function getAdj(node)
    local position,direction = node[1],node[2]
    local res = {}
    for i=-1,1 do
        for j=-1,1 do
            if math.abs(i)~=math.abs(j) and ((not direction) or not(i==-direction[1] and j == -direction[2])) then
                if (i==direction[1] and j==direction[2]) then
                    table.insert(res,{sum(position,{i,j}),{i,j},1})
                else
                    table.insert(res,{sum(position,{i,j}),{i,j},1001})
                end
            end
        end
    end
    return res
end

function Dijkstra(grid,start,dir)
    local startnode = {start,dir}
    local dist,prev = {},{}

    function comparator(a,b)
        if dist[b] == nil then return false end
        if dist[a] == nil then return true end
        return dist[a]>dist[b]
    end

    local Q = PriorityQueue.new(comparator)
    dist[makeKey(start,dir)]=0
    Q:Add(startnode,0)
    while Q:Size()>0 do
        local curr = Q:Pop()
        adj = getAdj(curr)
        for _,node in ipairs(adj) do
            local alt
            local position,direction,edge = node[1],node[2],node[3]
            if not grid[position[1]] or grid[position[1]][position[2]]=="#" then
                goto continue
            end
            alt = dist[makeKey(curr[1],curr[2])] + node[3]
            if not dist[makeKey(position,direction)] then
                add = true
            end
            if (not dist[makeKey(position,direction)]) or alt < dist[makeKey(position,direction)] then
                dist[makeKey(position,direction)] = alt
                prev[makeKey(position,direction)] = makeKey(curr[1],curr[2])
            end
            if add then
                Q:Add(node,makeKey(position,direction))
            end
            ::continue::
            add = false
        end
    end
    return prev,dist
end

prev,dist = Dijkstra(grid,start,{0,1})

print(dist[makeKey(dest,{-1,0})])


--
-- Part 2
--

bestdist = dist[makeKey(dest,{-1,0})]

function isBestPath(node)
    local position = node[1]
    if grid[position[1]][position[2]] == "#" then return false end
    local p,d = Dijkstra(grid,node[1],node[2])
    return d[makeKey(dest,{-1,0})] == (bestdist-dist[makeKey(node[1],node[2])])
end

function countOs(grid)
    local res = 0
    for _,e in ipairs(grid) do
        for _,f in ipairs(e) do
            if f=="O" then res=res+1 end
        end
    end
    return res
end

count = 0
for k,v in pairs(dist) do
    local position,direction = unmakeKey(k)
    if isBestPath({position,direction}) then
        grid[position[1]][position[2]] = "O"
       count = count+1
    end
end

print(countOs(grid))
