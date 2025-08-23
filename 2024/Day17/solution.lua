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

exec(instructions)
print()

function normalProgram(A,B,C,comp)
    while A>0 do
        B=A%8
        B=B~7
        C=A>>B
        A=A>>3
        B=B~C
        B=B~7
        io.write(B%8)
    end
end

function ci(n)
    i=0
    while true do
        if (((i%8)~7)~(i>>((i%8)))~7) == n then
            return i
        end
        i = i+1
    end
end

function nNumbers(n)
    for i=8^(n-1),8^(n)-1 do
        io.write(math.floor(i)..": ")
        normalProgram(i,0,0)
        print()
    end
end

nNumbers(1)

normalProgram(2711734577143437)
print()

