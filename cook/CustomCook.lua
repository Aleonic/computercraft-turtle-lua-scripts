require("GridMovementVertPlane")
require("InventoryManager")
require("cookConfigData")

CustomCook = {}
MetaCustomCook = {}
MetaCustomCook.__index = CustomCook

function CustomCook.new()
    local instance = setmetatable({}, MetaCustomCook)
    instance._movement = GridMovementVertPlane.new(self._movement,startCoords.x, startCoords.y)
    instance._invManager = InventoryManager.new()
    return instance
end

function CustomCook:listMissingIngredients(recipeList)
    -- Look into the recipe and check what ingredients cannot be found within the cooker.
    -- Return a list with only the missing ingredients.

    local missingIngredients = {}
    for index, value in ipairs(recipeList) do
        if not self._invManager:chestContains(value) then
            table.insert(missingIngredients, value)
        end
    end

    if #missingIngredients == 0 then
        return nil
    else
        return missingIngredients
    end
end

function CustomCook:getIngredients(ingredientArr)
    -- Use the ingredients list to determine what to grab from known inventory locations.
    -- If an ingredient could not be found, return to origin and close program (return false for failure).

    -- Create an indicator to check if an ingredient was found
    foundIngredient = {}
    for i = 1, #ingredientArr do
        foundIngredient[i] = false
    end

    --Go through each chest to find the ingredients
    for index, chestLocation in ipairs(sourceChestCoords) do

        --Go to current chest storage location
        self._movement.move(self._movement,chestLocation.x, chestLocation.y)

        for j, value in ipairs(foundIngredient) do

            if foundIngredient[j] == false then
                success = self._invManager:getItem(ingredientArr[j])

                if success then
                    foundIngredient[j] = true
                end
            end
        end
    end

    -- Check if all ingredients were found.
    for index, value in ipairs(foundIngredient) do
        -- If we are missing an ingredient, return false
        if value == false then
            return false
        end
    end

    -- All ingredients were found
    return true
end

function CustomCook:addIngredients(ingredientArr)
    -- Use the ingredients in the robot's inventory and add them to the cooker.

    self._movement.move(self._movement, startCoords.x, startCoords.y)

    for index, itemName in ingredientArr do
        local slot = self._invManager:turtleContains(itemName)

        if not slot then return false end

        local success = self._invManager:deposit(slot)

        if not success then return false end
    end

    return true
end

function CustomCook:cook(foodName)
    -- Wait for a specified amount of time and check if a product is created. If so, grab the product and assume cooking continues.
    -- Cooking ends when nothing is found after the specified timeframe.
    -- At this point, restart the process by searching for missing ingredients.

    cooking = true

    while cooking do
        sleep(15)

        success = self._invManager:getItem(productNameTranslation[chosenFood])

        if not success then
            cooking = false
        else
            --Deposit at a chest and return to cooking location
            self._movement:move(self._movement, depositChestCoords.x, depositChestCoords.y)
            self._invManager:deposit(self._invManager:turtleContains(productNameTranslation[chosenFood]))
            self._movement:move(self._movement, startCoords.x, startCoords.y)
        end
    end

    return false
end

function CustomCook:reset()
    -- Return to starting position.
    self._movement:move(self._movement, startCoords.x, startCoords.y)
end

-- main program
function main()
    local cookScript = CustomCook.new()

    while true do
        cookScript:reset()

        local cooking = cookScript:cook()

        if not cooking then

            local missingIngredients = cookScript:listMissingIngredients(recipes[chosenFood])
            if missingIngredients == nil then
                cookScript:reset()
                return
            end

            -- Determines if the robot/turtle grabbed the missingIngredients
            local foundIngredients = cookScript:getIngredients(missingIngredients)
            if foundIngredients == false then
                cookScript:reset()
                return
            end

            local depositedingredients = cookScript:addIngredients(missingIngredients)
            if depositedingredients == false then
                cookScript:reset()
                return
            end
        end
    end
end