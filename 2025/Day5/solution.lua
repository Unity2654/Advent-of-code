-- Reading the input file
f = io.open("puzzle.txt")
ranges = {}
ingredients = {}
line = f:read("*line")

hasmet = false

while line do
    if line == "" then
        hasmet = true
    else
        if line:find("(%d+)-(%d+)") then
            range = {}
            for e in line:gmatch("(%d+)") do
                table.insert(range, tonumber(e))
            end
            table.insert(ranges, range)
        else
            table.insert(ingredients, tonumber(line))
        end
    end
    line = f:read("*line")
end

--
--- Part 1
--

function isWithinRange(number)
    for _,r in pairs(ranges) do
        if number >= r[1] and number <= r[2] then
            return r
        end
    end
    return nil
end

--
--- Part 2
--

function computeAllRanges()
    local pois = {}
    for _,r in pairs(ranges) do
        table.insert(pois,r[1])
        table.insert(pois,r[2]+1)
    end
    table.sort(pois)
    return pois
end


function iterateOnPois(pois)
    local sum = 0
    local prev = nil
    for _,poi in pairs(pois) do
        if prev then
            if isWithinRange(prev) then
                sum = sum + (poi - prev)
            end
        end
        prev = poi
    end
    return sum
end

print(iterateOnPois(computeAllRanges()))
