mm = {}

function mm.pgcd(a,b)
    if b == 0 then return a end
    --if a < 0 and b < 0 then return -mm.pgcd(math.abs(a), math.abs(b)) end
    if a < 0 or b < 0 then return mm.pgcd(math.abs(a), math.abs(b)) end
    if b > a then return mm.pgcd(b,a) end
    local r = a % b
    return mm.pgcd(b,r)
end

function mm.arrayGCD(array)
    if #array < 2 then return 1 end
    local acc = mm.pgcd(array[1], array[2])
    for i,e in pairs(array) do
        if i > 2 then
            acc = mm.pgcd(acc, e)
        end
    end
    return acc
end

function mm.ppcm(a,b)
    return a * b / mm.pgcd(a,b)
end

function mm.arrayPCM(array)
    local acc = 1
    for _,e in pairs(array) do
        if e ~= 0 then
            acc = acc * e
        end
    end
    return acc / mm.arrayGCD(array)
end
