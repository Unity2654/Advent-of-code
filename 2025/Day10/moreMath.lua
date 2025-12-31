function mm.pgcd(a,b)
    if b > a then return mm.pgcd(b,a) end
    if b == 0 then return a end
    local r = a % b
    return mm.pgcd(b,r)
end

function mm.ppcm(a,b)
    return a * b / mm.pgcd(a,b)
end
