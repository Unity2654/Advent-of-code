-- Input parsing
f = io.open("puzzle.txt")
robots = {}

line = f:read("*line")
while line do
    robot = {}
    for w in line:gmatch("(-?%d+)") do
        table.insert(robot,tonumber(w))
    end
    table.insert(robots,robot)
    line = f:read("*line")
end


--
-- Part 1
--

gridSize = {101,103}
repetitions = 100

function sum(v1,v2)
    return {v1[1]+v2[1],v1[2]+v2[2]}
end

function newPositions(robot,times)
    local p = {robot[1],robot[2]}
    local v = {robot[3],robot[4]}
    p[1] = (p[1]+v[1]*times)%gridSize[1]
    p[2] = (p[2]+v[2]*times)%gridSize[2]
    return p
end

function findQuadrant(robot)
    local middle1 = gridSize[1]//2
    local middle2 = gridSize[2]//2
    if robot[1]==middle1 or robot[2]==middle2 then
        return nil
    end
    if robot[1]<middle1 then
        if robot[2]<middle2 then
            return 1
        else
            return 2
        end
    else
        if robot[2]<middle2 then
            return 3
        else
            return 4
        end
    end
end

quadrants = {0,0,0,0}

for _,r in ipairs(robots) do
    quad = findQuadrant(newPositions(r,repetitions))
    if quad then
        quadrants[quad] = quadrants[quad]+1
    end
end

print(quadrants[1]*quadrants[2]*quadrants[3]*quadrants[4])

--
-- Part 2
--

function average(robots)
    local avg1 = 0
    local avg2 = 0
    for _,r in ipairs(robots) do
        avg1 = avg1 + r[1]
        avg2 = avg2 + r[2]
    end
    return avg1/#robots,avg2/#robots
end

function variance(robots)
    local avg1,avg2 = average(robots)
    local v1,v2 = 0,0
    for _,r in ipairs(robots) do
        v1 = v1 + (r[1]-avg1)*(r[1]-avg1)
        v2 = v2 + (r[2]-avg2)*(r[2]-avg2)
    end
    return v1/(#robots-1),v2/(#robots-1)
end

function newPositionsAll(robots,times)
    res = {}
    for _,r in ipairs(robots) do
        pos = newPositions(r,times)
        table.insert(res,{pos[1],pos[2],r[3],r[4]})
    end
    return res
end

variances = {}
for i=1,10000 do -- Let's assume that the easterEgg happens before the 10000th iteration
    robots = newPositionsAll(robots,1)
    v1,v2 = variance(robots)
    variances[i] = (v1+v2)/2
end

min = variances[1]
minindex = 1
for index,val in ipairs(variances) do
    if val < min then
        min = val
        minindex = index
    end
end

print(minindex)
