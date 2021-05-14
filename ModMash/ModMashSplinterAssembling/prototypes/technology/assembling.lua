
local local_add_technology_if_missing = function(technology,recipe_name)
    for technology_name, tech in pairs(data.raw["technology"]) do
        if tech~= nil and tech.effects ~= nil then
            for k=1, #tech.effects do 
                local effect = tech.effects[k]         
                if effect ~= nil and effect.type == "unlock-recipe" and effect.recipe == recipe_name then return technology_name end
            end
        end
    end
    data:extend({technology})    
    return technology.name
end

modmashsplinterassembling.util.tech.patch_technology("automation","assembling-machine-f")

if settings.startup["setting-assembling-machine-burner-only"].value == "No" then
    local t = local_add_technology_if_missing(
        {
            type = "technology",
            name = "automation-4",
            icon = "__modmashsplinterassembling__/graphics/technology/automation-4.png",
            icon_size = 128,
            effects =
            {
              {
                type = "unlock-recipe",
                recipe = "assembling-machine-4"
              }
            },
            prerequisites =
            {
              "automation-3"
            },
            unit =
            {
              count = 150,
              ingredients =
              {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1}
              },
              time = 60
            },
            upgrade = true,
            order = "a-b-d",
        },
        "assembling-machine-4")
    local t2 = "automation-5"
    if t ~= "automation-4" then t2 = "automation-4" end
    local_add_technology_if_missing(
        {
            type = "technology",
            name = t2,
            icon = "__modmashsplinterassembling__/graphics/technology/automation-5.png",
            icon_size = 128,
            effects =
            {
              {
                type = "unlock-recipe",
                recipe = "assembling-machine-5"
              }
            },
            prerequisites =
            {
              t,
            },
            unit =
            {
              count = 150,
              ingredients =
              {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1}
              },
              time = 60
            },
            upgrade = true,
            order = "a-b-e"
        },
        "assembling-machine-5")
end