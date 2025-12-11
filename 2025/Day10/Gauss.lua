local function swap(table, i, i2)
    local ati2 = table[i2]
    table[i2] = table[i]
    table[i] = ati2
end

local function substract(table, i, i2, factor)
    for j = 1,#table[i] do
        table[i][j] = table[i][j] - table[i2][j] * factor
    end
end

local function divide(table, i, factor)
    for j = 1,#table[i] do
        table[i][j] = table[i][j] / factor
    end
end

local function findMax(table, row, min)
    local max = nil
    local imax = 0
    for i=min,#table[row] do
        if max == nil and math.abs(table[row][i]) > max then
            imax = i
            max = math.abs(table[row][i])
        end
    end
    return imax
end

--[[
h := 1 /* Initialization of the pivot row */
k := 1 /* Initialization of the pivot column */

while h ≤ m and k ≤ n:
    /* Find the k-th pivot: */
    i_max := argmax (i = h ... m, abs(A[i, k]))
    if A[i_max, k] = 0:
        /* No pivot in this column, pass to next column */
        k := k + 1
    else:
        swap rows(h, i_max)
        /* Do for all rows below pivot: */
        for i = h + 1 ... m:
            f := A[i, k] / A[h, k]
            /* Fill with zeros the lower part of pivot column: */
            A[i, k] := 0
            /* Do for all remaining elements in current row: */
            for j = k + 1 ... n:
                A[i, j] := A[i, j] - A[h, j] * f
        /* Increase pivot row and column */
        h := h + 1
        k := k + 1

]]

function Solve(lm, rm)
    local n = #lm      -- n equations of m unknown
    local m = #(lm[1])

    local h = 1
    local k = 1
    while h<=m and k<=n do
        local i_max = findMax(lm, k, h)

    end

    return lm
end

