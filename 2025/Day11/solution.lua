-- Parsing the input
connexions = {}

f = io.open("puzzle.txt")
line = f:read("*line")
while line do
    dev = nil
    for device in line:gmatch("(%l%l%l)") do
        if not dev then
            dev = device
            connexions[dev] = {}
        else
            table.insert(connexions[dev], device)
        end
    end
    line = f:read("*line")
end

--
--- Part 1
--

cache = {}
function findPath(start, dest)
    if cache[start] then return cache[start] end
    if start == dest then
        cache[start] = 1
        return 1
    end
    local outputs = connexions[start]
    if not outputs then return 0 end
    local totalPaths = 0
    for _,o in pairs(outputs) do
        totalPaths = totalPaths + findPath(o, dest)
    end
    cache[start] = totalPaths
    return totalPaths
end

--
--- Part 2
--

function findSegmentedPath(steps)
    local res = 1
    for i=1,(#steps-1) do
        cache = {}
        res = res * findPath(steps[i], steps[i+1])
    end
    return res
end

print(findSegmentedPath({"svr", "fft", "dac", "out"}) + findSegmentedPath({"svr", "dac", "fft", "out"}))
