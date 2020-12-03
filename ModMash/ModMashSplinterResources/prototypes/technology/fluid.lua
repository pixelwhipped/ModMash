data:extend(
{
  {
    type = "technology",
    name = "fish1",
    icon = "__modmashsplinterresources__/graphics/technology/fish.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "fish-conversion-light-oil"
      }
    },
    prerequisites =
    {
      "oil-processing"
    },
    unit =
    {
      count = 75,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 35
    },
    upgrade = true,
    order = "a-b-d",
  },{
    type = "technology",
    name = "fish2",
    icon = "__modmashsplinterresources__/graphics/technology/fish.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "fish-conversion-lubricant"
      }
    },
    prerequisites =
    {
      "fish1"
    },
    unit =
    {
      count = 75,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 35
    },
    upgrade = true,
    order = "a-b-d",
  }
})