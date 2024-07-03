require("../util/GridMovementVertPlane")
require("../util/InventoryManager")
-- require("cookConfigData")

CustomCook = {}
MetaCustomCook = {}
MetaCustomCook.__index = CustomCook

function CustomCook.new()
    local instance = setmetatable({}, MetaCustomCook)
    instance._movement = GridMovementVertPlane.new(nil, nil) --TODO
    instance._invManager = InventoryManager.new()
    return instance
end

function CustomCook:listMissingIngredients(recipeList)
    -- Look into the recipe and check what ingredients cannot be found within the cooker.
    -- Return a list with only the missing ingredients.


end

function CustomCook:getIngredients(ingredientArr)
    -- Use the ingredients list to determine what to grab from known inventory locations.
    -- If an ingredient could not be found, return to origin and close program (return false for failure).


end

function CustomCook:addIngredients(ingredientArr)
    -- Use the ingredients in the robot's inventory and add them to the cooker.


end

function CustomCook:cook(foodName)
    -- Wait for a specified amount of time and check if a product is created. If so, grab the product and assume cooking continues.
    -- Cooking ends when nothing is found after the specified timeframe.
    -- At this point, restart the process by searching for missing ingredients.


end

function CustomCook:reset(foodName)
    -- Return to starting position. Most likely meant to end program.

end
