--[[Code check 29.2.20
removed old comments
fix string to type
--]]
data:extend(
{
	{
		type = "recipe",
		name = "wind-trap",
		energy_required = 10,
		enabled = false,
		ingredients =
		{
			{"assembling-machine-2", 1},
			{"steel-plate", 5},
			{"pipe", 10},
		},
		result = "wind-trap"
	},
})