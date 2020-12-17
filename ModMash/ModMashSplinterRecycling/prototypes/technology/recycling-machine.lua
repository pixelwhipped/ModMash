data:extend(
{
  {
    type = "technology",
    name = "recycling-machine",
    icon = "__modmashsplinterrecycling__/graphics/item-group/recycling.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "recycling-machine"
      }
    },
    prerequisites =
    {
      "automation-2",	
	  "fluid-handling",
    },
    unit =
    {
      count = 120,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 60
    },
    upgrade = true,
    order = "a-b-f"
  }
}
)