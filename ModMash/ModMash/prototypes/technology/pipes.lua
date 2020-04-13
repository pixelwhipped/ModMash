data:extend(
{
  {
    type = "technology",
    name = "fluid-handling-3",
	localised_name = "Fluid Handling 3",
    icon_size = 128,
    icon = false,
	icons = {
		{
			icon = "__base__/graphics/technology/fluid-handling.png"
		},
		{
			icon = "__modmashgraphics__/graphics/technology/super-material.png",
			scale = 0.5,
			shift = {48,48}
		}},
    prerequisites = {"fluid-handling-2"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "titanium-pipe-to-ground"
      },
      {
        type = "unlock-recipe",
        recipe = "titanium-pipe"
      },{
        type = "unlock-recipe",
        recipe = "steam-engine-mk2"
      },{
        type = "unlock-recipe",
        recipe = "modmash-super-boiler-valve"
      },{
        type = "unlock-recipe",
        recipe = "super-material"
      },{
        type = "unlock-recipe",
        recipe = "super-material-235"
      },{
        type = "unlock-recipe",
        recipe = "super-material-crude"
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
})
