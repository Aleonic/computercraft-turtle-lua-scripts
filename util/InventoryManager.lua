InventoryManager = {}
MetaInventoryManager = {}
MetaInventoryManager.__index = InventoryManager

function InventoryManager.new()
    local instance = setmetatable({}, MetaInventoryManager)
    return instance
end

-- TODO: Check if block in front of robot is a chest.
-- function InventoryManager:verifyChest()
--     print("TODO")
-- end

function InventoryManager:chestContains(itemName)
    local inv = peripheral.wrap("front")
    local size = inv.size()

    local foundItemSlot = nil
    for i = 1, size
    do
        local item = inv.getItemDetail(i)

        if not item then
            goto continue
        end

        if item.name == item_search_name then
            foundItemSlot = i
            break
        end

        ::continue::
    end

    return foundItemSlot
end

function InventoryManager:turtleContains(itemName)
    local slot = 1
    local foundSlot = nil
    while slot <= 16 and foundSlot == nil do

    local data = turtle.getItemDetail()
        if data.name == itemName then
            foundSlot = slot
        end
    end

    return foundSlot
end

function InventoryManager:deposit(slot)
    if not turtle.select(slot) then
        return false
    end
    return turtle.drop()
end

function InventoryManager:deposit(slot, itemCount)
    if not turtle.select(slot) then
        return false
    end
    return turtle.drop(itemCount)
end

function InventoryManager:prepItemGrab(periph, itemSlot, emptySlot)
    local itemToMove = periph.getItemDetail(1)

    if itemToMove then
        periph.pushItems("front", 1, nil, emptySlot)
    end

    periph.pushItems("front", itemSlot, nil, 1)

    return true
end

function InventoryManager:getItem(item_search_name)
    local inv = peripheral.wrap("front")
    local size = inv.size()

    local foundEmptySlot = nil
    local foundItemSlot = nil
    for i = 1, size
    do
        local item = inv.getItemDetail(i)

        if not item then
            if not foundEmptySlot then
                foundEmptySlot = i
            end
            goto continue
        end

        if item.name == item_search_name then
            foundItemSlot = i
        end

        if foundItemSlot and foundEmptySlot then
            break
        end

        ::continue::
    end

    if not foundItemSlot then
        printError("ERROR: Item not found.")
        return false
    end

    if not foundEmptySlot and foundItemSlot ~= 1 then
        printError("ERROR: An empty slot is required to swap items.")
        return false
    end


    if foundItemSlot ~= 1 then
        InventoryManager:prepItemGrab(inv, foundItemSlot, foundEmptySlot)
    end

    local newFoundDetailLocation = inv.getItemDetail(1)
    turtle.suck(newFoundDetailLocation.count)

    return true
end