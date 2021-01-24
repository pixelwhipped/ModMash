require("prototypes.scripts.defines") 
data:extend(
{
	{
		type = "recipe",
		name = "mining-explosive",
		energy_required = 10,
		enabled = true,
		normal =
		{
			enabled = true,
			ingredients =
			{
				{"coal", 2},
				{"stone", 1},
				{"iron-ore", 2},
			},
			result = "mining-explosive"
		},
		expensive =
		{
			enabled = true,
			ingredients =
			{
				{"coal", 4},
				{"stone", 2},
				{"iron-ore", 2},
			},
			result = "mining-explosive"
		}
	}
})