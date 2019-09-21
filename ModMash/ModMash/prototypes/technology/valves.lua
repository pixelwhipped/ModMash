data:extend(
{
 {
	type = "technology",
    name = "fluid-handling-2",
    icon_size = 128,
    icon = "__base__/graphics/technology/fluid-handling.png",    	
	localised_name = "Fluid Handling 2",
	localised_description = "Adds Valves that can be used to better control Fluid",
    icon_size = 128,
    effects = {
	{
        type = "unlock-recipe",
        recipe = "modmash-overflow-valve"
      },
      {
        type = "unlock-recipe",
        recipe = "modmash-underflow-valve"
      }
	  ,
      {
        type = "unlock-recipe",
        recipe = "condenser-valve"
      },
	  {
        type = "unlock-recipe",
        recipe = "mini-boiler"
      }
	},
    prerequisites = {"fluid-handling"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},	
      },
      time = 30
    },
    order = "a-f-d"
  },
})