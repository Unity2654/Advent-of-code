require("moreMath")

System = {}
System.__index = System

local function sanitizeValue(value)
    local e = value
    if math.abs(e) - math.abs(math.floor(e)) < 0.1 then
        e = math.floor(e)
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
    self.results[index] = sanitizeValue(self.results[index] * factor)
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

-- Reduces the system as much as possible
function System:Reduce()
    local coefficients = self.coefficients
    local row = 1
    local column = 1
    local m = #coefficients
    local n = #(coefficients[1])

    -- Gaussian reduction
    print("-- Part 1 --\n")
    while row <= m and column <= n do
        local pivot, index = findPivot(coefficients, row ,column)
        if pivot == 0 then
            column = column + 1
        else
            self:Swap(row, index)
            for i = (row+1),m do
                local c = coefficients[i][column]
                if c ~= 0 then
                    local f = pivot / c
                    print(f)
                    self:Add(i, row, -f)
                end
            end
            row = row + 1
            column = column + 1
        end
        self:Print()
        print()
    end

    print("-- Part 2 --\n")
    -- Reducing the result as much as possible, to end up with as much constraints as possible
    row = m
    while row > 1 do
        local index,value = findConstraint(coefficients[row])
        if value then
            -- Removing the coefficient from all the other lines
            for i = (row-1), 1, -1 do
                local c = coefficients[i][index]
                if c ~= 0 then
                    local f = c / value
                    self:Add(i, row, -f)
                end
            end

            -- Reducing the value on the line of the constraint to be minimal
            self:Divide(row, value)
        end
        row = row - 1
        self:Print()
        print()
    end

    print("-- Part 3 --\n")
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
            row = row - 1
            m = m-1
        end
        row = row + 1
        self:Print()
        print()
    end
    return column
end


