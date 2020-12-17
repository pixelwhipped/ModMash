data:extend(
{
  {
    type = "technology",
    name = "fluid-handling-2",
	localised_name = "Fluid Handling 2",
    icon = "__base__/graphics/technology/fluid-handling.png",
    icon_mipmaps = 4,
    icon_size = 256,
    prerequisites = {"fluid-handling"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "titanium-pipe-to-ground"
      },
      {
        type = "unlock-recipe",
        recipe = "titanium-pipe"
      }
    },
    unit =
    {
      count = 100,
	  
      ingredients = {
	    {"automation-science-pack", 1},
        {"logistic-science-pack", 1}},
      time = 30
    },
    order = "d-a-a"
  },
  {
    type = "technology",
    name = "fluid-handling-3",
	localised_name = "Fluid Handling 3",
    icon = "__base__/graphics/technology/fluid-handling.png",
    icon_mipmaps = 4,
    icon_size = 256,
    prerequisites = {"fluid-handling-2"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "condenser-valve"
      },
      {
        type = "unlock-recipe",
        recipe = "mini-boiler"
      }
    },
    unit =
    {
      count = 100,
	  
      ingredients = {
	    {"automation-science-pack", 1},
        {"logistic-science-pack", 1}},
      time = 30
    },
    order = "d-a-a"
  }
})
