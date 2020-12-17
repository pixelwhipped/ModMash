data:extend(
{
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
  }
}
)