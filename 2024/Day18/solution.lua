require "PriorityQueue";
-- Reading the input file
input = {}

f = io.open("puzzle.txt")
SIZE = 70

line = f:read("*line")
while line do
    pair = {}
    for w in line:gmatch("(%d+)") do
        table.insert(pair,tonumber(w))
    end
    table.insert(input,pair)
    line = f:read("*line")
end

--Creating the map
map = {}
for i=1,SIZE+1 do
    map[i] = {}
    for j=1,SIZE+1 do
        map[i][j] = "."
    end
end

lastfell = 0
function fall(bits)
    lastfell = lastfell+1
    local i = bits[lastfell]
    map[i[2]+1][i[1]+1] = "#"
end

for a=1,1024 do
    fall(input)
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

function Dijkstra(grid,start,dir)
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
            if not grid[node[1]] or not grid[node[1]][node[2]] or grid[node[1]][node[2]]=="#" then
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

origin = {1,1}
dest = {SIZE+1,SIZE+1}

_,dist = Dijkstra(map,origin)

print(dist[makeKey(dest)])

--
-- Part 2
--

while dist[makeKey(dest)] do
    fall(input)

    _,dist = Dijkstra(map,origin)
end
sol = input[lastfell]
print(sol[1]..","..sol[2])
