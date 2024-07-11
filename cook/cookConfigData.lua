
--Recipe that will be cooked.
chosenFood = "NoodleSoup"


productNameTranslation = {
    ["NoodleSoup"] = ""
}

-- Recipe list for each food product.
recipes = {
    ["NoodleSoup"] = {
        "farmersdelight:bacon",
        "minecraft:dried_kelp",
        "farmersdelight:raw_pasta"
        --TODO: egg info
    }
}








 -- Movement data --


-- Starting and reset area of robot:
startCoords = {
    x = 5,
    y = 2
}

--Chests locations where ingredients can be found:
sourceChestCoords = {
    {
        x = 1,
        y = 1
    },
    {
        x = 2,
        y = 1
    },
    {
        x = 2,
        y = 1
    }
}

depositChestCoords = {
    x = 2,
    y = 3,
}