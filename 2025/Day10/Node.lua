Node = {}
Node.__index = Node

function Node.new(coordinates)
	local newNode = { }
	setmetatable(newNode, Node)

	newNode.coordinates = { }

	for k,v in pairs(coordinates) do
        newNode.coordinates[k] = v
	end

	return newNode
end

function Node:Serialize()
    local res = ""
    for _,e in pairs(self.coordinates) do
        if res ~= "" then res = res .. "_" end
        res = res .. e
    end
    return res
end

function Node:ToString()
    local res = "{"
    for _,e in pairs(self.coordinates) do
        if res ~= "{" then res = res .. "," end
        res = res .. e
    end
    res = res .. "}"
    return res
end

function Node:Distance(otherNode)
    local res = 0
    for i,e in pairs(self.coordinates) do
        res = res + (otherNode.coordinates[i] - e) * (otherNode.coordinates[i] - e)
    end
    return math.sqrt(res)
end

function Node:Equals(otherNode)
    for i,e in pairs(self.coordinates) do
        if e ~= otherNode.coordinates[i] then return false end
    end
    return true
end

function Node:IsBeyond(otherNode)
    for i,e in pairs(self.coordinates) do
        if e > otherNode.coordinates[i] then return true end
    end
    return false
end

function Node:Copy()
    return Node.new(self.coordinates)
end

function Node:Add(vector)
    for k,v in pairs(vector) do
        if self.coordinates[k] then
            self.coordinates[k] = self.coordinates[k] + v
        end
    end
end

function Node:GetNeighbors(edges)
    local res = {}
    for _,e in pairs(edges) do
        local n = self:Copy()
        n:Add(e)
        table.insert(res, n)
    end
    return res
end
