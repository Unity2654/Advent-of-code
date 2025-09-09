require "vectors"
-- Reading the input file
input = {}
f = io.open("puzzle.txt")
line = f:read("*line")
while line do
    table.insert(input,line)
    line = f:read("*line")
end

-- Positions of the elements
KeyPad = {}
KeyPad["7"] = Vector.new(1,1)
KeyPad["8"]=Vector.new(2,1)
KeyPad["9"]=Vector.new(3,1)
KeyPad["4"]=Vector.new(1,2)
KeyPad["5"]=Vector.new(2,2)
KeyPad["6"]=Vector.new(3,2)
KeyPad["1"]=Vector.new(1,3)
KeyPad["2"]=Vector.new(2,3)
KeyPad["3"]=Vector.new(3,3)
KeyPad["0"]=Vector.new(2,4)
KeyPad["A"]=Vector.new(3,4)

Remote = {}
Remote["^"]=Vector.new(2,1)
Remote["<"]=Vector.new(1,2)
Remote[">"]=Vector.new(3,2)
Remote["v"]=Vector.new(2,2)
Remote["A"]=Vector.new(3,1)

function toKey(curr,prev)
    return curr.." "..prev
end

f1 = io.open("solutions.txt")
routesKeyPad = {}
routesRemote = {}
line = f1:read("*line")
while line ~= "" do
    local m = line:gmatch("(.+) (.+) (.+)")
    curr,prev,val = m()
    routesKeyPad[toKey(curr,prev)] = val
    line = f1:read("*line")
end
line = f1:read("*line")
while line do
    local m = line:gmatch("(.+) (.+) (.+)")
    curr,prev,val = m()
    routesRemote[toKey(curr,prev)] = val
    line = f1:read("*line")
end

-- Movements of the robot
function movements(inputString,routes)
    local res=""
    local prev = nil
    local curr="A"
    for inps in inputString:gmatch(".") do
        prev = curr
        curr = inps
        res=res..routes[toKey(curr,prev)]
    end
    return res
end

function numericPart(inputString)
    return tonumber(inputString:match("(%d+)"))
end

--
-- Part 1
--

res = 0
for _,i in ipairs(input) do
    first = movements(i,routesKeyPad)
    second = movements(first,routesRemote)
    third = movements(second,routesRemote)
    res = res + numericPart(i)*#third
end
print(res)

--
-- Part 2
--

memo = {}

function throughRemotes(input, depth)
    if depth==0 then return #input end
    local res = 0
    --print(input)
    for w in input:gmatch("(.-A)") do
        --print(w)
        if memo[toKey(w,depth)] then res = res+memo[toKey(w,depth)]
        else
            local tmp = throughRemotes(movements(w,routesRemote),depth-1)
            memo[toKey(w,depth)] = tmp
            res = res + tmp
        end
    end
    --print()
    return res
end

res = 0
for _,i in ipairs(input) do
    first = movements(i,routesKeyPad)
    third = throughRemotes(first,25)
    res = res + numericPart(i)*third
end
print(res)
