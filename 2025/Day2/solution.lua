-- parsing the input
lines = {}
f = io.open("puzzle.txt")
text = f:read("*all")
for a,b in text:gmatch("(%d+)-(%d+)") do
	pair = {tonumber(a),tonumber(b)}
	table.insert(lines,pair)
end

--
--- Part 1
--

function isTwiceTheSame(n)
	local nb = tostring(n)
	if #nb % 2 ~= 0 then
		return false
	end
	local halflen = #nb/2
	return string.sub(n,1,halflen) == string.sub(n,halflen+1)
end

function throughInterval(min,max)
	local res = 0
	for i = min,max do
		if isTwiceTheSame(i) then
			res = res + i
		end
	end
	return res
end

res = 0
for _,j in pairs(lines) do
	res = res + throughInterval(j[1],j[2])
end
print(res)
