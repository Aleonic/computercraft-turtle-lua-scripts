GridMovementVertPlane = {}
MetaGridMovementVertPlane = {}
MetaGridMovementVertPlane.__index = GridMovementVertPlane

function GridMovementVertPlane.new(x, y)
    local instance = setmetatable({}, MetaGridMovementVertPlane)
    instance.x = x -- x is the horizontal axis (left, right)
    instance.y = y -- y is the vertical axis (down, up)
    return instance
end

function GridMovementVertPlane:move(x, y)

    --Assumes robot faces forward.


    --Turn to direction
    local turn = nil
    if x < self.x then
        turn = "left"
    elseif x > self.x then
        turn = "right"
    end

    if turn == "left" then
        turtle.turnLeft()
    elseif turn == "right" then
        turtle.turnRight()
    end

    --Move towards horizontal direction
    while self.x ~= x do
        local canMove = turtle.forward()
        if not canMove then
            printError("ERROR: Cannot move.")
            return false
        end

        if not canMove then
            printError("ERROR: Cannot move.")
            return false
        else
            if turn == "left" then
                self.x = self.x - 1
            elseif turn == "right" then
                self.x = self.x + 1
            end
        end
    end

    -- move up or down vertically
    local vert = nil
    if y < self.y then
        vert = "down"
    elseif y > self.y then
        vert = "up"
    end

    while self.y ~= y do
        local canMove = nil
        if vert == "down" then
            canMove = turtle.down()
        elseif vert == "up" then
            canMove = turtle.up()
        end

        if not canMove then
            printError("ERROR: Cannot move.")
            return false
        else
            if vert == "down" then
                self.y = self.y - 1
            elseif vert == "up" then
                self.y = self.y + 1
            end
        end
    end

    -- Movements complete, now face forward.
    if turn == "left" then
        turtle.turnRight()
    elseif turn == "right" then
        turtle.turnLeft()
    end

    return true
end