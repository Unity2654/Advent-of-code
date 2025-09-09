-- Parsing the input file
f = io.open("smallPuzzle.txt")
input = {}
line = f:read("*line")

function prt(table)
    for _,i in ipairs(table) do
        io.write(i.." ")
    end
    print()
end

for w in line:gmatch("(%d+)") do
    table.insert(input,tonumber(w))
end

--
-- Part 1
--

function firstrule(table, stone)
    table[stone] = 1
    return table
end

function secondRule(table,stone)
    st = ""..table[stone]
    first = string.sub(st,1,#st//2)
    second = string.sub(st,#st//2+1,#st)
    table[stone] = tonumber(first)
    table[#table+1] = tonumber(second)
    return table
end

function thirdRune(table,stone)
    table[stone] = table[stone]*2024
    return table
end

function copy(table)
    res = {}
    for i,e in ipairs(table) do
        res[i] = e
    end
    return res
end

inp = copy(input)

for i=1,25 do
    res = copy(inp)
    for j,e in ipairs(inp) do
        if e == 0 then
            res = firstrule(res,j)
        else if #(e.."")%2==0 then
                res = secondRule(res,j)
            else
                res = thirdRune(res,j)
            end
        end
    end
    inp = res
end

print(#inp)

--
-- Part 2
--

inp2 = copy(input)
memo = {}
treshold = 75

function count(number,t)
    if t == treshold then
        memo[number.."_"..t] = 1
        return 1
    end
    if memo[number.."_"..t] then
       return  memo[number.."_"..t]
    end
    if number==0 then
        memo[number.."_"..t] = count(1,t+1)
        return memo[number.."_"..t]
    end
    if #(""..number)%2==0 then
        local stone = ""..number
        local first = string.sub(stone,1,#stone//2)
        local second = string.sub(stone,#stone//2+1,#stone)
        memo[number.."_"..t] = count(tonumber(first),t+1) + count(tonumber(second),t+1)
        return memo[number.."_"..t]
    end
    memo[number.."_"..t] = count(number*2024,t+1)
    return memo[number.."_"..t]
end

sum = 0

for _,a in ipairs(inp2) do
    sum = sum + count(a,0)
end
print(sum)
