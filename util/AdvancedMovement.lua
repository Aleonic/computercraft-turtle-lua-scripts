require("Stack")

AdvancedMovement = {}
MetaAdvancedMovement = {}
MetaAdvancedMovement.__index = AdvancedMovement

--[[
    The intention of this script is to make it possible to return move the robot while
    being aware of backtracking. Each step will keep track of how much fuel would be
    necessary to move back to the origin.
--]]

-- Movement scripts
function AdvancedMovement.new()
    local instance = setmetatable({}, MetaAdvancedMovement)
    instance._stack = Stack:Create()
    instance._steps = 0
    return instance
end

-- private functions
function AdvancedMovement:_reverse(obj)
    if obj._steps > 0 or obj._stack:_getn(obj._stack) > 0 then
        local choice = obj._stack:_pop(obj._stack,1)

        case = {

            ["f"] = function()
                turtle.forward()
                obj._steps = obj._steps - 1
            end,

            ["b"] = function()
                turtle.back()
                obj._steps = obj._steps - 1
            end,

            ["u"] = function()
                turtle.up()
                obj._steps = obj._steps - 1
            end,

            ["d"] = function()
                turtle.down()
                obj._steps = obj._steps - 1
            end,

            ["tl"] = function()
                turtle.turnLeft()
            end,

            ["tr"] = function()
                turtle.turnRight()
            end,

            ["default"] = function()
                printError("ERROR: Invalid input value for reverse statement")
            end,
        }

        -- execution section
        if case[choice] then
            case[choice]()
        else
            case["default"]()
        end
    end
end

function AdvancedMovement:_checkFuelReserve(obj)
    if obj._steps < turtle.getFuelLevel() then
        return true
    end
    return false
end

-- public functions
function AdvancedMovement:getMovementCount()
    return self._stack:_getn(self._stack)
end

function AdvancedMovement:getStepsTaken()
    return self._steps
end

function AdvancedMovement:getStepsTaken(optionalSteps)
    return self._steps + optionalSteps
end

function AdvancedMovement:checkFuelReserve()
    return AdvancedMovement:_checkFuelReserve(self)
end

function AdvancedMovement:up()
    if AdvancedMovement:_checkFuelReserve(self) and then
        self._stack:_push(self._stack, "d")
        self._steps = self._steps + 1
        return turtle.up()
    end
    return false
end

function AdvancedMovement:down()
    if AdvancedMovement:_checkFuelReserve(self) and then
        self._stack:_push(self._stack, "u")
        self._steps = self._steps + 1
        return turtle.down()
    end
    return false
end

function AdvancedMovement:left()
    self._stack:_push(self._stack, "tr")
    return turtle.turnLeft()
end

function AdvancedMovement:right()
    self._stack:_push(self._stack, "tl")
    return turtle.turnRight()
end

function AdvancedMovement:forward()
    if AdvancedMovement:_checkFuelReserve(self) and then
        self._stack:_push(self._stack, "b")
        self._steps = self._steps + 1
        return turtle.forward()
    end
    return false
end

function AdvancedMovement:backward()
    if AdvancedMovement:_checkFuelReserve(self) and then
        self._stack:_push(self._stack, "f")
        self._steps = self._steps + 1
        return turtle.back()
    end
    return false
end

function AdvancedMovement:reverse()
    return AdvancedMovement:_reverse(self)
end

function AdvancedMovement:fullReverse()
    while self._steps > 0 or self._stack:_getn(self._stack) > 0
    do
        AdvancedMovement:_reverse(self)
    end
end