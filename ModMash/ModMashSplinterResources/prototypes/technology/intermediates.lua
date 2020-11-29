data:extend(
{
  {
    type = "technology",
    name = "alien-conversion-1",
    icon = "__modmashsplinterresources__/graphics/technology/conversion.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "alien-ooze"
      },{
        type = "unlock-recipe",
        recipe = "alien-artifact-enrichment-process-to-ore"
      },{
        type = "unlock-recipe",
        recipe = "alien-enrichment-process-to-artifact"
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
  }
})