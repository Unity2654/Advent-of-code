-- Parsing the inputs
shapes = {}

f = io.open("puzzle.txt")
line = f:read("*line")

shape = -1
isShape = false
currShape = {}
while line do
    if line ~= "" then
        if isShape then
            for letter in line:gmatch(".") do
                table.insert(currShape, letter)
            end
        end
        if line:find("^%d:") then
            isShape = true;
            shape = shape + 1
            currShape = {}
        end
        if not isShape then break end
    else
        if #currShape > 0 then
            shapes[shape] = currShape
        end
        isShape = false
    end
    line = f:read("*line")
end

regions = {}

while line do
    local req = {}
    for e in line:gmatch("(%d+)") do
        if not a then
            a = tonumber(e)
        else
            if not b then
                b = tonumber(e)
            else
                table.insert(req, tonumber(e))
            end
        end
    end
    table.insert(regions, {{a,b}, req})
    a = nil
    b = nil
    line = f:read("*line")
end

function printRegion(region)
    for _,e in pairs(regions) do
        for _,j in pairs(e) do
            for _,k in pairs(j) do
                io.write(k.." ")
            end
            print()
        end
        print()
    end
end



--
--- Part 1
--

shapesArea = {}
for i,t in pairs(shapes) do
    local area = 0
    for _,e in pairs(t) do
        if e == "#" then area = area + 1 end
    end
    shapesArea[i] = area
end

function getMinimalArea(requirement)
    local minarea = 0
    for i,e in pairs(requirement[2]) do
        minarea = minarea + e * shapesArea[i-1]
    end
    return minarea
end

function getMaximalArea(requirement)
    local minarea = 0
    for i,j in pairs(requirement[2]) do
        minarea = minarea + j * 9
    end
    return minarea
end

function getRegionArea(region)
    return region[1][1] * region[1][2]
end

validcount = 0
unknown_count = 0
discard_count = 0

for i,e in pairs(regions) do
    rarea = getRegionArea(e)
    if(getMinimalArea(e) > rarea) then -- Discards the region
        discard_count = discard_count + 1
    else if(getMaximalArea(e) <= rarea) then -- Accepts the region
            validcount = validcount + 1
        else   -- Print the region
            unknown_count = unknown_count + 1
        end
    end
end

print(validcount) -- For some reason, no area falls in the "unknown" part.
