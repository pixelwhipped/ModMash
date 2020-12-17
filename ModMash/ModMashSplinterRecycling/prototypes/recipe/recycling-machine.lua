data:extend(
{
  {
    type = "recipe",
    name = "recycling-machine",    
    normal =
	{
        enabled = false,
		ingredients = {
          {"assembling-machine-2", 1},
          {"steel-plate", 5},
          {"iron-gear-wheel", 5}
        },
		result = "recycling-machine"
	},
	expensive =
	{
        enabled = false,
		ingredients = {
          {"assembling-machine-2", 1},
          {"steel-plate", 8},
          {"iron-gear-wheel", 15}
        },
		result = "recycling-machine"
	}  
  }
}
)