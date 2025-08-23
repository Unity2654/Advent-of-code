--[[
    Small library to handle 2D vectors
    Contains the following functions:
        .new(x,y)      -> Creates a new vector with coordinates x,y
                          If any of these is not given, initialize them as 0 instead
        :sum(v2)       -> Returns the sum of the 2 vectors as a new vector
        :diff(v2)      -> Returns the difference of the 2 vectors as a new vector
                          (= v1 - v2)
        :distance(v2)  -> Returns the euclidian distance of the 2 vectors

]]

Vector={}
Vector.__index = Vector

function Vector.new(x,y)
    local newVector = {}
    setmetatable(newVector, Vector)
    if not x then
        newVector.x = 0
    else
        newVector.x = x
    end
    if not y then
        newVector.y = 0
    else
        newVector.y = y
    end
    return newVector
end

function Vector:Sum(v2)
    return {self.x+v2.x,self.y+v2.y}
end

function Vector:Diff(v2)
    return {self.x-v2.x,self.y-v2.y}
end

function Vector:Distance(v2)
    return math.sqrt((self.x-v2.x)^2 + (self.y-v2.y)^2)
end

function Vector:Print()
	print("("..self.x..","..self.y..")")
end

function Vector:toString()
	return "("..self.x..","..self.y..")"
end
