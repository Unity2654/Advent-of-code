require("moreMath")

System = {}
System.__index = System

local function sanitizeValue(value)
    local e = value
    if math.abs(math.abs(e) - math.abs(math.floor(e))) < 0.1 then
        e = math.floor(e)
    end
    if math.abs(math.abs(math.ceil(e)) -  math.abs(e)) < 0.1 then
        e = math.ceil(e)
    end
    return e
end

function System.new()
	local newSystem = { }
	setmetatable(newSystem, System)

	newSystem.coefficients = { }
	newSystem.results = { }

	return newSystem
end

function System:LineAsArray(index)
    local res = {}
    for _,e in pairs(self.coefficients[index]) do
        table.insert(res, index)
    end
    table.insert(res,self.results[index])
    return res
end

function System:AddLine(coefficients, result)
    table.insert(self.coefficients, coefficients)
    table.insert(self.results, result)
end

function System:Add(index1, index2, factor)
    if not factor then factor = 1 end
    local target = self.coefficients[index1]
    local source = self.coefficients[index2]
    for i,_ in pairs(source) do
        target[i] = sanitizeValue(target[i] + source[i] * factor)
    end
    self.results[index1] = sanitizeValue(self.results[index1] + self.results[index2] * factor)
end

function System:Swap(index1, index2)
    -- coefficients
    local tmp = self.coefficients[index1]
    self.coefficients[index1] = self.coefficients[index2]
    self.coefficients[index2] = tmp

    -- results
    local tmp = self.results[index1]
    self.results[index1] = self.results[index2]
    self.results[index2] = tmp
end

function System:SwapColumns(index1, index2)
    for _,e in pairs(self.coefficients) do
        e[index1],e[index2] = e[index2],e[index1]
    end
end

function System:Multiply(index, factor)
    local target = self.coefficients[index]
    for i,_ in pairs(target) do
        target[i] = sanitizeValue(target[i] * factor)
    end
    self.results[index] = sanitizeValue(self.results[index] * factor)
end

function System:Divide(index, factor)
    local target = self.coefficients[index]
    for i,_ in pairs(target) do
        if target[i] ~= 0 then
            target[i] = sanitizeValue(target[i] / factor)
        end
    end
    self.results[index] = sanitizeValue(self.results[index] / factor)
end

function System:Print()
    for i,e in pairs(self.coefficients) do
        for _,c in pairs(e) do
            io.write(c .. " ")
        end
        io.write("| ")
        print(self.results[i])
    end
end

local function findPivot(coefficients, startingrow, column)
    local max = nil
    local imax = nil
    for i=startingrow,#coefficients do
        if max == nil or math.abs(coefficients[i][column]) > math.abs(max) then
            max = coefficients[i][column]
            imax = i
        end
    end
    return max, imax
end

local function findConstraint(coefficients)
    for i=1,#coefficients do
        if coefficients[i] ~= 0 then
            return i, coefficients[i]
        end
    end
    return nil
end

function System:ReduceRow(index)
    local _,value = findConstraint(self.coefficients[index])
    if value then
        self:Divide(index, value)
    end
end

-- Reduces the system as much as possible
function System:Reduce()
    local coefficients = self.coefficients
    local row = 1
    local column = 1
    local m = #coefficients
    local n = #(coefficients[1])

    -- Gaussian reduction
    --print("-- Part 1 --\n")
    while row <= m and column <= n do
        local pivot, index = findPivot(coefficients, row ,column)
        if pivot == 0 then
            column = column + 1
        else
            self:Swap(row, index)
            for i = (row+1),m do
                local c = coefficients[i][column]
                if c ~= 0 then
                    local mul = mm.ppcm(pivot, c)
                    self:Multiply(i, mul)
                    local f = coefficients[i][column] / pivot
                    self:Add(i, row, -f)
                end
            end
            row = row + 1
            column = column + 1
        end
        --self:Print()
        --print()
    end

    --print("-- Part 2 --\n")
    -- Reducing the result as much as possible, to end up with as much constraints as possible
    row = m
    while row >= 1 do
        --print("row : "..row)
        local index,value = findConstraint(coefficients[row])
        if value then
            --print("found constraint "..value.." at index "..index)
            -- Removing the coefficient from all the other lines
            for i = (row-1), 1, -1 do
                local c = coefficients[i][index]
                if c ~= 0 then
                    local mul = mm.ppcm(value, c)
                    self:Multiply(i, mul)
                    local f = coefficients[i][index] / value
                    self:Add(i, row, -f)
                    self:ReduceRow(i)
                end
            end
            -- Reducing the value on the line of the constraint to be minimal
            self:Divide(row, value)
        end
        row = row - 1
        --self:Print()
        --print()
    end

    --print("-- Part 3 --\n")
    -- Putting the non-constraints to the end
    column = 1
    row = 1
    while row <= m do
        local index,value = findConstraint(coefficients[row])
        if value then
            self:SwapColumns(column, index)
            column = column + 1
        else
            table.remove(coefficients, row)
            table.remove(self.results, row)
            row = row - 1
            m = m-1
        end
        row = row + 1
        --self:Print()
        --print()
    end
    return column
end

local function copy(array)
    local res = {}
    for _,e in pairs(array) do
        table.insert(res, e)
    end
    return res
end

function System:FindRemainer(index, values)
    local acc = 0
    --io.write("At line "..index.." with [ ")
    for i,e in pairs(self.coefficients[index]) do
        acc = acc + values[i] * e
        --io.write(values[i].."*"..e.." ")
    end
    --print("] found sum of "..acc.." with reminder of "..self.results[index] - acc)
    return self.results[index] - acc
end

local function sum(array)
    local acc = 0
    for _,e in pairs(array) do
        acc = acc + e
    end
    return acc
end

---
-- Solving the system using a DFS
--
-- variables : variables already defined
-- variablesIndex : index of the variables in the coefficients array
-- index : current variable being treated
-- lenght : number of variables in total
function System:DeepSolve(variables, variablesIndex, index, length)
    -- All variables have been defined
    if (index+variablesIndex-1) > length then
        local result = {}
        for i=1,length do
            if i < variablesIndex then
                table.insert(result,0)
            else
                table.insert(result, variables[i - variablesIndex+1])
            end
        end
        --[[io.write("initial result : ")
        for _,e in pairs(result) do
            io.write(e.." ")
        end
        print()]]

        for i,e in pairs(self.coefficients) do
            local value = self:FindRemainer(i, result) / e[i]
            --print("row "..i.." found reminder of "..value)
            if value < 0 or sanitizeValue(value) ~= value then return nil end
            result[i] = value
        end

        --[[for _,e in pairs(result) do
            io.write(e.." ")
        end
        io.write("=> "..sum(result))
        print()
        print()]]
        return result
    end
    -- Recursive calls
    local maximum = nil
    for i,e in pairs(self.results) do
        if (not maximum) or math.abs(e) > maximum and self.coefficients[i][index + variablesIndex-1] ~= 0 then
            maximum = math.abs(e)
        end
    end
    --maximum = math.max(maximum, 100)
    --print("index "..index.." found maximum of |"..maximum.."| = "..math.abs(maximum).." possibilities")

    local result = nil
    local sresult = 0
    for i = 0,math.abs(maximum) do
        local varcopy = copy(variables)
        varcopy[index] = i
        local res = self:DeepSolve(varcopy, variablesIndex, index + 1, length)
        if res then
            local s = sum(res)
            if ((not result) or s < sresult) then
                sresult = s
                result = res
            end
        end
    end
    return result
end

function System:Solve(variablesIndex)
    local vars = {}
    local length = #(self.  coefficients[1])
    for i=1,(length-variablesIndex) do
        table.insert(vars,0)
    end
    return self:DeepSolve(vars, variablesIndex, 1, length)
end

function System:Verify(solution)
    for i,_ in pairs(self.coefficients) do
        if not (self:FindRemainer(i, solution) == 0) then return false end
    end
    return true
end
