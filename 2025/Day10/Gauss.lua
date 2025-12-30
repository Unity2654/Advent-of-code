System = {}
System.__index = System

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
        target[i] = target[i] + source[i] * factor
    end
    self.results[index1] = self.results[index1] + self.results[index2] * factor
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

function System:Multiply(index, factor)
    local target = self.coefficients[index]
    for i,_ in pairs(target) do
        target[i] = target[i] * factor
    end
    self.results[index] = self.results[index] * factor
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
