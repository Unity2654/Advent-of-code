-- Parsing the input file
numbers = {}
f = io.open("puzzle.txt")
line = f:read("*line")
while line do
    table.insert(numbers,tonumber(line))
    line = f:read("*line")
end

--
-- Part 1
--

function secret(number)
    local number = ((number<<6)~number)
    local r = number&16777215
    local number = ((r>>5)~number)
    r = number&16777215
    return ((r<<11)~number)&16777215
end

function apply(number,n,f)
    local res = number
    for _=1,n do
        res  =f(res)
    end
    return res
end

sum = 0
for _,e in ipairs(numbers) do
    sum = sum + apply(e,2000,secret)
end

print(sum)


--
-- Part 2
--

sequences = {}

function sequenceIndex(seq,i)
    local res = ""
    if i < 1 then i=1 end
    for a=i,i+3 do
        if seq[a] then res = res.."_"..seq[a] else return res end
    end
    return res
end

for _,e in ipairs(numbers) do
    local curr = e
    local prev = nil
    local seq = {}
    local marked = {}
    for _=1,1999 do
        prev = curr
        curr = secret(curr)
        table.insert(seq,curr%10-prev%10)
        if not sequences[sequenceIndex(seq,#seq-3)] then sequences[sequenceIndex(seq,#seq-3)]=0 end
        if not marked[sequenceIndex(seq,#seq-3)] then
            sequences[sequenceIndex(seq,#seq-3)] = sequences[sequenceIndex(seq,#seq-3)]+curr%10
            marked[sequenceIndex(seq,#seq-3)] = true
        end
    end
end

max = 0
for k,v in pairs(sequences) do
    if v>max then max=v end
end
print(max)
