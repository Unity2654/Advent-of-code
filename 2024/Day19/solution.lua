require "fa"
-- Reading the input file
f = io.open("puzzle.txt")
line = f:read("*line")

automaton = fa.new({"w","u","r","g","b"})
for w in line:gmatch("%l+") do
    automaton:addPattern(w)
end

patterns = {}
line = f:read("*line")
line = f:read("*line")
while line do
    table.insert(patterns,line)
    line = f:read("*line")
end

deter,corresp = createDeterministic(automaton)

--
-- Part 1
--

ValidPatterns= {}
for _,p in ipairs(patterns) do
    if deter:accept(p) then
        table.insert(ValidPatterns,p)
    end
end

print(#ValidPatterns)

--
-- Part 2
--

function invert(array)
    local res={}
    for k,v in pairs(array) do
        res[v]=k
    end
    return res
end

corresp = invert(corresp)

cache = {}
function fa:DFS(state,word)
    if state == nil then
        return 0
    end
    if cache[state.." "..word] then
        return cache[state.." "..word]
    end
    if word == "" then
        if self.states[state] then
            return 1
        end
        return 0
    end
    local transit = self:transition(state,string.sub(word,1,1))
    if not transit then
        cache[state.." "..word] = 0
        return 0
    end
    local res = 0
    for _,i in pairs(transit) do
        res = res + self:DFS(i,string.sub(word,2,#word))
    end
    cache[state.." "..word] = res
    return res
end


possibilities=0
for i,p in ipairs(ValidPatterns) do
    possibilities = possibilities + automaton:DFS(automaton.initial,p)
end

print(possibilities)
