

Set = {}
Set.__index = Set

function Set.new()
    local newSet = {}
    newSet.content = {}
    setmetatable(newSet, Set)
    return newSet
end

function Set:clear()
    self.content = {}
end

function Set:toTable()
    local res = {}
    for k,_ in pairs(self.content) do
        table.insert(res,k)
    end
    return res
end

function Set:insert(element)
    if not self.content[element] then
        self.content[element]=true
    end
end

function Set:Print()
    for k,_ in pairs(self.content) do
        io.write(k.." ")
    end
    print()
end

function Set:size()
    local res=0
    for _ in pairs(self.content) do res = res+1 end
    return res
end

function Set:contains(element)
    return not not self.content[element]
end

function Set:equals(table)
    for _,v in pairs(table) do
        if not self.content[v] then return false end
    end
    return true
end

function Set:remove(element)
    self.content[element]=nil
end

function Set:isWithin(table)
    for _,e in pairs(table) do
        if self:equals(e) then return true end
    end
    return false
end

function Set:String()
    local res=nil
    for e,_ in pairs(self.content) do
        if not res then res = e
        else res=res..","..e end
    end
    return res
end
