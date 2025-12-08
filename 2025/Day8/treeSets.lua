UniqSet = {}
UniqSet.__index = UniqSet

function UniqSet.new()
	local newSet = { }
	setmetatable(newSet, UniqSet)

    newSet.Size = {}

	return newSet
end

function UniqSet.members(set)
    local c = 0
    for _,_ in pairs(set.Size) do
        c = c + 1
    end
    return c
end

function UniqSet.maxSize(set)
    local max = 0
    for _,e in pairs(set.Size) do
        if e > max then max = e end
    end
    return max
end

function UniqSet.newSet(set, element)
    set[element] = element
    set.Size[element] = 1
end

function UniqSet.addElement(set, element, other)
    local referent = set:getReferent(other)
    set[element] = referent
    set.Size[referent] = set.Size[referent] + 1
end

function UniqSet.merge(set, e1, e2)
    local ref1 = set:getReferent(e1)
    local ref2 = set:getReferent(e2)
    if ref1 == ref2 then
        return false
    end
    set[ref1] = ref2
    set.Size[ref2] = set.Size[ref2] + set.Size[ref1]
    set.Size[ref1] = 1
    return true
end

function UniqSet.getReferent(set, element)
    local curr = element
    if not set[curr] then
        return nil
    end
    while set[curr] ~= curr do
        curr = set[curr]
    end
    return curr
end

function UniqSet.isSameSet(set, e1, e2)
    return e1 and e2 and set:getReferent(e1) == set:getReferent(e2)
end
