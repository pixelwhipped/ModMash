data:extend(
{
  {
    type = "technology",
    name = "wind-trap",
	--localised_name = "Air Purifier",
	--localised_description = "Reduces polution and produces water and sludge as byproducts.",

    icon = "__base__/graphics/technology/automation.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "wind-trap"
      }
    },
    prerequisites =
    {
      "automation-2",	
	  "fluid-handling",
    },
    unit =
    {
      count = 60,
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