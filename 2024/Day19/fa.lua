fa={states={},
    transitions={},
    alphabet={},
    initial=nil}
fa.__index = fa

function fa.new(alphabet)
	local newfa = {}
	setmetatable(newfa, fa)
	newfa.states={}
	newfa.alphabet=alphabet
	newfa.transitions={}
	newfa.initial=nil
	return newfa
end

function fa:addSymbol(symbol)
    table.insert(self.alphabet,symbol)
end

function fa:addState(initial,final)
    table.insert(self.states,final)
    if initial then self.initial = #self.states end
    return #self.states
end

function fa:makeFinal(state)
    self.states[state]=true
end

function fa:transitionKey(state,letter)
    return state..letter
end

function fa:transition(state,character)
    return self.transitions[self:transitionKey(state,character)]
end

function fa:addTransition(origin,symbol,dest)
    if not self.transitions[self:transitionKey(origin,symbol)] then
        self.transitions[self:transitionKey(origin,symbol)] = {}
    end
    table.insert(self.transitions[self:transitionKey(origin,symbol)],dest)
end

function fa:hasTransition(origin,symbol)
    return self:transition(origin,symbol) ~= nil
end

function contains(element,array)
    for _,e in ipairs(array) do
        if e==element then return true end
    end
    return false
end

function union(table1,table2)
    local res={}
    if not table1 then return table2 end
    if not table2 then return table1 end
    for _,e in pairs(table1) do
        table.insert(res,e)
    end
    for _,e in pairs(table2) do
        if not contains(e,res) then table.insert(res,e) end
    end
    return res
end

function fa:addPattern(pattern)
    local curr = self.initial
    if not curr then
        curr=self:addState(true,true)
    end
    for i=1,#pattern do
        local letter = string.sub(pattern,i,i)
        if i==#pattern then
            if not self.transitions[self:transitionKey(curr,letter)] then
                self.transitions[self:transitionKey(curr,letter)] = {}
            end
           table.insert(self.transitions[self:transitionKey(curr,letter)],self.initial)
        else
            local new = self:addState(false,false)
            if not self.transitions[self:transitionKey(curr,letter)] then
                self.transitions[self:transitionKey(curr,letter)] = {}
            end
            table.insert(self.transitions[self:transitionKey(curr,letter)],new)
            curr = new
        end
    end
end

function fa:accept(word)
    local curr = {self.initial}
    local visited = {curr}
    for w in word:gmatch(".") do
        if not curr or #curr==0 then
            return false
        end
        local n = {}
        for _,e in ipairs(curr) do
            n = union(self:transition(e,w),n)
        end
        curr = n
        table.insert(visited,curr)
    end
    if not curr then
        return false
    end
    for _,e in ipairs(curr) do
        if self.states[e] then
            return true,visited
        end
    end
    return false
end

function fa:prettyPrint()
    io.write("Initial state : ")
    print(self.initial)
    io.write("Final states : ")
    for i,e in pairs(self.states) do
        if e then
            io.write(i.." ")
        end
    end
    print()
    print("States :")
    io.write("\t")
    for i,_ in pairs(self.states) do
        io.write(i.." ")
    end
    print()
    print("Transitions : ")
    for o,d in pairs(self.transitions) do
        io.write("\t")
        for w in o:gmatch("(%d+)") do
            io.write(w..",")
        end
        for w in o:gmatch("(%l+)") do
            io.write(w.." -> ")
        end
        for _,e in ipairs(d) do
            io.write(e.." ")
        end
        print()
    end
end

function toKey(set)
    local res=""
    for _,state in pairs(set) do
        res=res.."_"..state
    end
    return res
end

function fromKey(set)
    local res={}
    for w in set:gmatch("%d+") do
        table.insert(res,tonumber(w))
    end
    return res
end

function createDeterministic(other)
    local deter = fa.new(other.alphabet)
    local startingset = {other.initial}
    local index,queue = 1,{startingset}
    local corresp = {}
    corresp[toKey(startingset)] = deter:addState(true,false)
    while index<=#queue do
        local curr = queue[index]
        index=index+1
        for _,letter in ipairs(other.alphabet) do
            local dest = {}
            for _,state in ipairs(curr) do
                dest = union(dest,other:transition(state,letter))
            end
            if not corresp[toKey(dest)] then
                corresp[toKey(dest)] = deter:addState(false,false)
                table.insert(queue,dest)
            end
        end
    end
    -- Adding transitions
    for k,v in pairs(corresp) do
        for _,letter in ipairs(other.alphabet) do
            local dest = {}
            for _,state in ipairs(fromKey(k)) do
                dest = union(dest,other:transition(state,letter))
            end
            deter:addTransition(v,letter,corresp[toKey(dest)])
        end
    end
    --Final states
    for k,v in pairs(corresp) do
        for _,state in ipairs(fromKey(k)) do
            if other.states[state] then
                deter:makeFinal(v)
                break
            end
        end
    end
    return deter,corresp
end

return fa
