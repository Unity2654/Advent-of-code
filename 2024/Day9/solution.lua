-- Reading the input file
f = io.open("puzzle.txt")
line = f:read("*line")
input = {}
for w in line:gmatch(".") do
    table.insert(input,tonumber(w))
end


--
-- Part 1
--

function parse(cmps)
    isFile = true
    out = {}
    id = 0
    for _,i in ipairs(cmps) do
        if i~=0 then
            for a=1,i do
                if isFile then
                    table.insert(out,id)
                else
                    table.insert(out,".")
                end
            end
        end
        if isFile then
            id = id+1
        end
        isFile = not isFile
    end
    return out
end

function decalage(full)
    first= 1
    last = #full
    while last > first and full[first] and full[last] do
        while full[first] and full[first] ~= "." do
            first = first+1
        end
        while full[last] and full[last] =="." do
            last = last-1
        end
        if last > first then
            full[first],full[last] = full[last],full[first]
        end
    end
    return full
end

function checksum(table)
    sum = 0
    for i,e in ipairs(table) do
        if e~="." then
            sum = sum + e*(i-1)
        end
    end
    return sum
end

print("Part 1 : "..checksum(decalage(parse(input))))

--
-- Part 2
--

function findEmptySpace(n,table, thresh)
    substring = ""
    for i=1,n do
        substring = substring.."%."
    end
    tabled = stringify(table)
    startindex = string.find(tabled, substring)
    if startindex and startindex < thresh then return startindex else return nil end
end

function fullBlock(table,i,j)
    offset = 0
    id = table[j]
    while j+offset <= #table and table[j+offset] == id do
        table[i+offset],table[j+offset] = table[j+offset],table[i+offset]
        offset = offset +1
    end
    return table
end

function stringify(table)
    res = ""
    for _,e in ipairs(table) do
        if e == "." then
            res = res..e
        else
            res = res.."_"
        end
    end
    return res
end

function decalagev2(full)
    last = #full
    size = 0
    while last > 1 do
        if full[last] ~= "." then
            curr = full[last]
            size = 0
            while full[last] == curr and full[last] do
                last = last-1
                size = size+1
            end
            emptySpace = findEmptySpace(size,full, last+1)
            if emptySpace then
                fullBlock(full,emptySpace,last+1)
            end
        else
            last = last-1
        end
    end
    return full
end

print("Part 2 : "..checksum(decalagev2(parse(input))))
