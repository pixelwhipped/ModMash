    
data:extend(
{
    {
		type = "recipe",
		name = "launch-platform",
		energy_required = 5.5,
		enabled = false,
		normal =
		{
			enabled = false,
			ingredients = 
			{
				{"solar-panel", 4},
				{"rocket-control-unit", 6},
				{"steel-chest", 10},
			},
			result = "launch-platform"
		},
		expensive =
		{
			enabled = false,
			ingredients = 
			{
				{"solar-panel", 6},
				{"rocket-control-unit", 8},
				{"steel-chest", 20},
			},
			result = "launch-platform"
		},
		icon = false,
		icon = "__modmashsplinternewworlds__/graphics/icons/launch-platform-icon.png",
		icon_size = 64,
		icon_mipmaps = 4,
		allow_decomposition = false,
	},
})