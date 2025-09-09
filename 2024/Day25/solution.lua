-- Reading the input file

schematics = {}
f= io.open("puzzle.txt")
line = f:read("*line")
while line do
    schematic = {}
    while line and line ~= "" do
        table.insert(schematic,line)
        line = f:read("*line")
    end
    table.insert(schematics,schematic)
    line = f:read("*line")
end

keys = {}
locks = {}

for _,schematic in ipairs(schematics) do
    for i,line in ipairs(schematic) do
        if i==1 then
            if line:sub(1,1)=="#" then
                model = {}
                table.insert(locks,model)
            else
                model = {}
                table.insert(keys,model)
            end
        else
            if i< #schematic then
                index=1
                for c in line:gmatch(".") do
                    if not model[index] then model[index]=0 end
                    if c=="#" then model[index] = model[index]+1 end
                    index=index+1
                end
            end
        end
    end
end

--
-- Partie 1
--

function isMatching(key,lock)
    for i,e in ipairs(lock) do
        if e+key[i] > 5 then return false end
    end
    return true
end

count = 0
for _,lock in pairs(locks) do
    for _,key in pairs(keys) do
        if isMatching(key,lock) then count = count+1 end
    end
end
print(count)
