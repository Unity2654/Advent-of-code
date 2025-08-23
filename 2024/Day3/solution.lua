-- Reading the file
f = io.open("puzzle.txt")
program = f:read("*all")

--
-- Part 1
--
sum = 0

for w in program:gmatch("(mul%(%d+,%d+%))") do
	mul = 1
	for n in w:gmatch("(%d+)") do
		mul = mul * tonumber(n)
	end
	sum = sum + mul
end

--print(sum)

--
-- Part 2
--

res = 0

program = string.gsub(program,"(don't%(%).-do%(%))","")
program = string.gsub(program,"(don't%(%).*)$","")
for w in program:gmatch("(mul%(%d+,%d+%))") do
	mul = 1
	for n in w:gmatch("(%d+)") do
		mul = mul * tonumber(n)
	end
	res = res + mul
end
print(res)
