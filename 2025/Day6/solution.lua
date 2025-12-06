--
--- Part 1
--

-- Parsing the input
problems = {}
operations = {}

f = io.open("puzzle.txt")
line = f:read("*line")
while line do
    index = 1
    if line:find("(%d+)") then
        for n in line:gmatch("(%d+)") do
            if not problems[index] then
                problems[index] = {}
            end
            table.insert(problems[index], tonumber(n))
            index = index + 1
        end
    else
        for o in line:gmatch("([+*])") do
            operations[index] = o
            index = index + 1
        end
    end
    line = f:read("*line")
end

function printTable(table)
    for _,e in pairs(table) do
        io.write(e.." ")
    end
    print()
end

op = {}
op["+"] = function(a,b) return a+b end
op["*"] = function(a,b) return a*b end

function solve(index)
    local pb = problems[index]
    local operation = operations[index]
    if not operation then
        return 0
    end
    local res = nil
    for _,n in pairs(pb) do
        if res then
            res = op[operation](res, n)
        else
            res = n
        end
    end
    return res
end

res = 0
for i,p in pairs(problems) do
    res = res + solve(i)
end
--print(res)

--
--- Part 2
--

-- Parsing the input
f = io.open("puzzle.txt")
ls = {}
c = f:read(1)
current = {}
while c do
    if c == "\n" then
        table.insert(ls,current)
        current = {}
    else
        table.insert(current,c)
    end
    c = f:read(1)
end
table.insert(ls,current)

function isEmptyColumn(index)
    for _,line in pairs(ls) do
        if line[index] and line[index] ~= " " then
            return false
        end
    end
    return true
end

function isNilColumn(index)
    for _,line in pairs(ls) do
        if line[index] then
            return false
        end
    end
    return true
end

function getNumber(index)
    local number = ""
    for _,line in pairs(ls) do
        local e = line[index]
        if not e or e == " " then
            if number ~= "" then
                return tonumber(number)
            end
        else
            if e == "+" or e == "*" then
                return tonumber(number)
            end
            number = number .. e
        end
    end
    return tonumber(number)
end

problems = {}
problem = {}
i = 1
while not isNilColumn(i) do
    if isEmptyColumn(i) then
        table.insert(problems, problem)
        problem = {}
    else
        table.insert(problem, getNumber(i))
    end
    i = i + 1
end
table.insert(problems, problem)

res = 0
for i,p in pairs(problems) do
    res = res + solve(i)
end
print(res)
