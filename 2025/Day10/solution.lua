require("Queues")
-- Parsing the solution
indicators = {}
buttons = {}
requirements = {}

f = io.open("puzzle.txt")
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

function pushButton2(state, button)
    local new = shallowCopy(state)
    for _,e in pairs(button) do
        new[e + 1] = new[e + 1] + 1
    end
    return new
end

function serialize2(state)
    local res = ""
    for _,e in pairs(state) do
        res = res .. e .. "_"
    end
    return res
end

function sup(state1, state2)
    for i=1,#state1 do
        if state1[i] > state2[i] then return true end
    end
    return false
end

function findPath2(state, buttons, expected)
    local Q = List.new()
    local prev = {}
    local cache = {}
    List.pushright(Q, state)
    while not List.empty(Q) do
        local curr = List.popleft(Q)
        if not cache[serialize2(curr)] and not sup(curr, expected) then
            cache[serialize2(curr)] = true
            if serialize2(curr) == serialize2(expected) then
                return prev
            end
            for _,button in pairs(buttons) do
                local follow = pushButton2(curr, button)
                if not prev[serialize2(follow)] then prev[serialize2(follow)] = serialize2(curr) end
                List.pushright(Q, follow)
            end
        end
    end
    return nil
end

function Part2()
    sum = 0
    for i,req in pairs(requirements) do
        state = {}
        for _,e in pairs(req) do table.insert(state, 0) end
        steps = findPath2(state, buttons[i], req)
        c = getSteps(steps, serialize2(req), serialize2(state))
        if c then sum = sum + c end
        print(i)
    end

    return sum
end

print(Part2())


