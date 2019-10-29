data:extend(
{
  {
    type = "technology",
    name = "recycling-machine",
	--localised_name = "Recycling Machine",
	--localised_description = "Recycling Machine",
    icon = "__modmash__/graphics/item-group/recycling.png",
    icon_size = 64,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "recycling-machine"
      },{
        type = "unlock-recipe",
        recipe = "sludge-treatment"
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