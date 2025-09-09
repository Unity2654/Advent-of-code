-- Reading the input file
machines = {}
f = io.open("puzzle.txt")
line = true
while line do
    machine = {}
    for _=1,3 do
        line = f:read("*line")
        vector = {}
        for w in line:gmatch("%d+") do
            table.insert(vector,tonumber(w))
        end
        table.insert(machine,vector)
    end
    table.insert(machines,machine)
    line = f:read("*line")
end

-- Calculating the solution of an equation
function getFactors(machine)
    X,Y,M = machine[1],machine[2],machine[3]
    if Y[1]==0 or (X[2]-X[1]*(Y[2]/Y[1])) == 0 then
        return nil,nil
    end
    e = (Y[2]/Y[1])
    a = (M[2]-e*M[1])/(X[2]-X[1]*e)
    b = (M[1]-a*X[1])/Y[1]
    if #tostring(a) == #tostring(math.floor(a))+2 and #tostring(b) == #tostring(math.floor(b))+2 then
        return a,b
    end
    return nil,nil
end


--
-- Part 1
--
tokens = 0

for i,m in ipairs(machines) do
    a,b = getFactors(m)
    if a and b then
        tokens = tokens + 3*a + b
    end
end
print(math.floor(tokens))

--
-- Part 2
--

function conversionErrorFix(machine)
    machine[3][1] = machine[3][1]+ 10000000000000
    machine[3][2] = machine[3][2]+ 10000000000000
    return machine
end

moreTokens = 0

for i,m in ipairs(machines) do
    a,b = getFactors(conversionErrorFix(m))
    if a and b then
        moreTokens = moreTokens + 3*a + b
    end
end

print(math.floor(moreTokens))
