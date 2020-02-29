--[[Code check 29.2.20
no changes
--]]
data:extend(
{
  {
    type = "technology",
    name = "automation-5",
    icon = "__base__/graphics/technology/automation.png",
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
      "automation-4",
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
  }
}
)