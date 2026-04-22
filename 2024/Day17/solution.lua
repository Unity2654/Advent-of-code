-- Parsing the input file
registers = {}
instructions = {}
f = io.open("puzzle.txt")
i = 0
line = f:read("*line")
while line ~= "" do
    for w in line:gmatch("%d+") do
        registers[i] = tonumber(w)
    end
    line = f:read("*line")
    i=i+1
end
line = f:read("*line")
i=0
for w in line:gmatch("%d") do
    instructions[i]=tonumber(w)
    i=i+1
end

--
-- Part 1
--

function combo(operand)
    if operand<=3 then return operand
    else return registers[operand-4] end
end


operations ={}
operations[0]=function(op) --adv
                registers[0] = registers[0]>>combo(op)
              end
operations[1]=function(op) --bxl
                registers[1] = registers[1] ~ op
              end
operations[2]=function(op) --bst
                registers[1] = combo(op)%8
              end
operations[3]=function(op) --jnz
                if registers[0] ~= 0 then return op end
              end
operations[4]=function(op) --bxc
                registers[1] = registers[1] ~ registers[2]
              end
operations[5]=function(op) --out
                io.write(combo(op)%8)
              end
operations[6]=function(op) --bdv
                registers[1] = registers[0]>>combo(op)
              end
operations[7]=function(op) --cdv
                registers[2] = registers[0]>>combo(op)
              end

function exec(program)
    local p = 0
    output = {}
    while program[p] do
        res = operations[program[p]](program[p+1])
        if res then
            p = res
        else
            p = p+2
        end
    end
end

io.write("Part 1 : ")
exec(instructions)
print()

function normalProgram(A,B,C)
    local res = ""
    while A>0 do
        B=A%8
        B=B~7
        C=A>>B
        A=A>>3
        B=B~C
        B=B~7
        res = res .. B%8
    end
    return res
end

function octalToDecimal(o)
    local p = #o-1
    local res = 0
    for e in o:gmatch(".") do
        res = res + tonumber(e) * 8 ^ p
        p = p - 1
    end
    return res
end

function find(target, current)
    if(#current > 0) then
        local currentResult = normalProgram(octalToDecimal(current),0,0)
        if tonumber(currentResult) == tonumber(target) then return {current,true} end -- Found result
        tpos = -(#currentResult - 3)
        if #currentResult >= 4 and currentResult:sub(4,4) ~= target:sub(tpos,tpos) then
            return {current, false}
        end
    end
    if(#current > #target) then return {current, false} end
    for i=0,7 do
        local res = find(target, current..i)
        if(res[2]) then return res end
    end
    return {current, false}
end

function printResult(result)
    for e in result:gmatch(".") do
        io.write(e)
    end
    print()
end

result = find("2417750340175530", "")
print("Part 2 : "..math.tointeger(octalToDecimal(result[1])))
