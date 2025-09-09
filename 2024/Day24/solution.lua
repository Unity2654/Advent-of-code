-- Parsing the input file
f = io.open("puzzle.txt")
line = f:read("*line")
resolved = {}
while line ~= "" do
    local it = line:gmatch("([0-9a-z]+): (%d+)")
    local key,value = it()
    resolved[key] = tonumber(value)
    line = f:read("*line")
end
line = f:read("*line")
wires={}
zs = {}
while line do
    local it = line:gmatch("([0-9a-z]+) (%L+) ([0-9a-z]+) %-> ([0-9a-z]+)")
    op1,func,op2,key = it()
    wires[key] = {op1,func,op2}
    if string.sub(key,1,1) == "z" then table.insert(zs,key) end
    line = f:read("*line")
end


--
-- Part 1
--

functions = {}
functions["XOR"] = function(a,b) if a ~= b then return 1 else return 0 end end
functions["AND"] = function(a,b) if a==b and a==1 then return 1 else return 0 end end
functions["OR"] = function(a,b) if a+b>0 then return 1 else return 0 end end

function resolve(operand)
    if resolved[operand] then
        return resolved[operand]
    end
    local connections = wires[operand]
    resolved[operand] = functions[connections[2]](resolve(connections[1]),resolve(connections[3]))
    return resolved[operand]
end

function zCompare(a,b)
    return tonumber(a:match("(%d+)"))>tonumber(b:match("(%d+)"))
end

table.sort(zs,zCompare)

res = ""
for _,z in pairs(zs) do
    res = res..resolve(z)
end

print(res.." => "..tonumber(res,2))

--
-- Part 2
--

g = io.open("graph.dot","w")
g:write('digraph finite_state_machine {\n\tfontname="Helvetica,Arial,sans-serif"\n\tedge [fontname="Helvetica,Arial,sans-serif"]\n\trankdir=LR;\n\tnode [shape = circle];\n')

labels = {}
labels["XOR"] = "~"
labels["AND"] = "&"
labels["OR"] = "|"

shapes = {}
shapes["XOR"] = "Mdiamond"
shapes["OR"] = "diamond"
shapes["AND"] = "square"

function nodeName(wire,operation)
    return "operation\nwire"
end

for k,v in pairs(wires) do
   g:write("node [shape = "..shapes[v[2]].."];\n\t")
   g:write(k.."\n\t")
end

g:write("node [shape = circle];\n")

for k,v in pairs(wires) do
    g:write("\t")
    g:write(v[1].." -> "..k..";\n\t")
    g:write(v[3].." -> "..k..";\n")
end
g:write("}")

