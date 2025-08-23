require "sets"
-- Reading the input file
f = io.open("puzzle.txt")

graph = {}
graph["content"]={}

function graph:Add(origin,dest)
    if not self.content[origin] then self.content[origin]= Set.new() end
    self.content[origin]:insert(dest)
    if not self.content[dest] then self.content[dest] = Set.new() end
    self.content[dest]:insert(origin)
end

function graph:Print()
    for k,v in pairs(self.content) do
        print("For "..k..": ")
        for _,d in pairs(v) do
            print("\t"..d)
        end
        print()
    end
end

line = f:read("*line")
while line do
    local m = line:gmatch("(%l+)")
    graph:Add(m(),m())
    line = f:read("*line")
end

--
-- Part 1
--

function contains(table,element)
    for _,e in pairs(table) do
        if e == element then return true end
    end
    return false
end

function graph:findTreeSets()
    local res = {}
    for k,v in pairs(self.content) do
        local set = Set.new()
        set:insert(k)
        for v1,_ in pairs(v.content) do
            set:insert(v1)
            for v2 in pairs(self.content[v1].content) do
                if self.content[v2]:contains(k) then
                    set:insert(v2)
                    if not set:isWithin(res) then table.insert(res,set:toTable()) end
                    set:remove(v2)
                end
            end
            set:remove(v1)
        end
    end
    return res
end

set = graph:findTreeSets()

function hasT(table)
    for _,e in pairs(table) do
        if string.sub(e,1,1)=="t" then return true end
    end
    return false
end

res=0
for _,t in ipairs(set) do
    if hasT(t) then res=res+1 end
end
print(res)

--
-- Part 2
--

function graph:findSetFrom(key)
    local lan = Set.new()
    local marked = {}
    local queue = {key}
    local index = 1
    while index <= #queue do
        local curr = queue[index]
        if marked[curr] then goto continue end
        marked[curr]=true
        for k,_ in pairs(lan.content) do
            if not(curr==k or self.content[curr]:contains(k)) then goto continue end
        end
        if self.content[curr] then
            for k,_ in pairs(self.content[curr].content) do
                table.insert(queue,k)
            end
        end
        lan:insert(curr)
        ::continue::
        index=index+1
    end
    return lan
end

function comparator(pc1,pc2)
    if string.sub(pc1,1,1)==string.sub(pc2,1,1) then
        return string.byte(string.sub(pc1,2,2)) < string.byte(string.sub(pc2,2,2))
    end
    return string.byte(string.sub(pc1,1,1)) < string.byte(string.sub(pc2,1,1))
end

function String(input)
    local res=nil
    table.sort(input,comparator)
    for _,e in pairs(input) do
        if not res then res=e
        else res=res..","..e end
    end
    return res
end

function greatestSets(graph)
    local greatest = nil
    for k,_ in pairs(graph.content) do
        local from = graph:findSetFrom(k)
        if (not greatest) or from:size() > greatest:size() then greatest = from end
    end
    return String(greatest:toTable())
end

print(greatestSets(graph))
