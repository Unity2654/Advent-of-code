require("Queues")
require("PriorityQueue")
require("Gauss")
-- Parsing the solution
indicators = {}
buttons = {}
requirements = {}

f = io.open("smallPuzzle.txt")
line = f:read("*line")
while line do
    -- indicators
    indicator = {}
    for c in line:gmatch(".") do
        if c == "]" then break end
        if c == "." then table.insert(indicator,false) end
        if c == "#" then table.insert(indicator, true) end
    end
    table.insert(indicators, indicator)

    -- buttons
    buttonList = {}
    for c in line:gmatch("[()%d,]+") do
        if string.sub(c,1,1) == "(" then
            button = {}
            for n in c:gmatch("%d") do
                table.insert(button, tonumber(n))
            end
            table.insert(buttonList, button)
        else
            req = {}
            for n in c:gmatch("%d+") do
                table.insert(req, tonumber(n))
            end
            table.insert(requirements, req)
        end
    end
    table.insert(buttons, buttonList)
    line = f:read("*line")
end

--
--- Part 1
--

function serialize(state)
    local res = ""
    for _,e in pairs(state) do
        if e then res = res .. "#"
        else res = res .. "." end
    end
    return res
end

function shallowCopy(state)
    local res = {}
    for i,e in pairs(state) do
        res[i] = e
    end
    return res
end

function pushButton(state, button)
    local new = shallowCopy(state)
    for _,e in pairs(button) do
        new[e + 1] = not new[e + 1]
    end
    return new
end

function findPath(state, buttons, expected)
    local Q = List.new()
    local prev = {}
    local cache = {}
    List.pushright(Q, state)
    while not List.empty(Q) do
        local curr = List.popleft(Q)
        if not cache[serialize(curr)] then
            cache[serialize(curr)] = true
            if serialize(curr) == serialize(expected) then
                return prev
            end
            for _,button in pairs(buttons) do
                local follow = pushButton(curr, button)
                if not prev[serialize(follow)] then prev[serialize(follow)] = serialize(curr) end
                List.pushright(Q, follow)
            end
        end
    end
    return nil
end

function getSteps(steps, start, stop)
    local c = 1
    local curr = steps[start]
    while curr and curr ~= stop do
        c = c + 1
        curr = steps[curr]
    end
    return c
end

function Part1()
    sum = 0
    for i,ind in pairs(indicators) do
        state = {}
        for _,e in pairs(ind) do table.insert(state, false) end
        steps = findPath(state, buttons[i], ind)
        c = getSteps(steps, serialize(ind), serialize(state))
        if c then sum = sum + c end
    end

    return sum
end

--
--- Part 2
--

function getVector(button, length)
    -- creating the vector
    local v = {}
    for i=1,length do table.insert(v,0) end
    for _,e in pairs(button) do
        v[e+1] = 1
    end
    return v
end

function getVectors(buttons, length)
    local res = {}
    for _,b in pairs(buttons) do
        table.insert(res, getVector(b, length))
    end
    return res
end

function makeSystem(sys, vectors, req)
    for i=1,#(vectors[1]) do
        local line = {}
        for _,v in pairs(vectors) do
            table.insert(line, v[i])
        end
        sys:AddLine(line, req[i])
    end
end

function Part2()
    for i,req in pairs(requirements) do
        local sys = System.new()
        local vec = getVectors(buttons[i], #req)
        makeSystem(sys, vec, req)
        sys:Reduce()
        sys:Print()
        print()
    end
end

print(Part2())
