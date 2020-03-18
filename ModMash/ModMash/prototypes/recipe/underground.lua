data:extend(
{
  {
		type = "recipe",
		name = "underground-access",
		energy_required = 10,
		enabled = true,
		ingredients =
		{
			{"assembling-machine-burner", 1},
			{"steel-chest", 5},
			{"pipe", 10},
		},
		result = "underground-access"
	},
	{
		type = "recipe",
		name = "underground-accumulator",
		energy_required = 10,
		enabled = false,
		ingredients =
		{
		  {"iron-plate", 10},
		  {"battery", 5}
		},
		result = "underground-accumulator"
	}
})
