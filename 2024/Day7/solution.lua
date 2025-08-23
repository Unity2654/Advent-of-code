-- Reading the file

summables = {}
testValues = {}

f = io.open("puzzle.txt")
line = f:read("*line")

while line do
    key = tonumber(line:match("(%d+):"))
    table.insert(testValues,key)
    values = {}
    for n in line:gmatch(" (%d+)") do
        table.insert(values,tonumber(n))
    end
    table.insert(summables,values)
    line = f:read("*line")
end

--
-- Part 1
--

function mul(a,b)
    return a*b
end

function add(a,b)
    return a+b
end

function through(vals, test, op, pos, acc, ops)
    if not vals[pos] then
        return acc == test
    end
    acc = op(acc,vals[pos])
    return through(vals,test,mul,pos+1,acc) or through(vals,test,add,pos+1,acc)
end

res = 0
for i,t in ipairs(testValues) do
    if through(summables[i],t,mul,1,1,"") or through(summables[i],t,add,0,1,"") then
        res = res+t
    end
end

print(res)

--
-- Part 2
--

function cat(a,b)
    return tonumber(a..b)
end

function throughv2(vals, test, op, pos, acc, ops)
    if not vals[pos] then
        return acc == test
    end
    acc = op(acc,vals[pos])
    return throughv2(vals,test,mul,pos+1,acc) or throughv2(vals,test,add,pos+1,acc) or throughv2(vals,test,cat,pos+1,acc)
end

res2 = 0
for i,t in ipairs(testValues) do
    if throughv2(summables[i],t,mul,1,1,"") or throughv2(summables[i],t,add,0,1,"") or throughv2(summables[i],t,cat,0,0,"") then
        res2 = res2+t
    end
end

print(res2)
