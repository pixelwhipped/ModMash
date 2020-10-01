data:extend(
{
	--[[{
		type = "recipe",
		name = "coffee-low-grade-from-barrel",
		enabled = true,
		normal =
		{
		  enabled = true,
		  ingredients =
		  {
			{name="water-barrel", amount=1},
			{"coffee-beans", 5},
		  },
		  result = "coffee-low-grade"
		},
		expensive =
		{
		  enabled = true,
		  ingredients =
		  {
			{name="water-barrel", amount=50},
			{"coffee-beans", 10},
		  },
		  result = "coffee-low-grade"
		}
	},]]
	{
		type = "recipe",
		name = "coffee-low-grade",
		energy_required = 1.5,
		enabled = true,
		category = "crafting-with-fluid",
		icon = "__coffee__/graphics/icons/coffee-low-grade.png",
		icon_size = 32,
		main_product = "",
		subgroup = "capsule",
		allow_decomposition = false,
		normal =
		{
		  enabled = true,
		  ingredients =
		  {
			{type="fluid", name="water", amount=50},
			{"coffee-beans", 5},
		  },
		  result = "coffee-low-grade"
		},
		expensive =
		{
		  enabled = true,
		  ingredients =
		  {
			{type="fluid", name="water", amount=50},
			{"coffee-beans", 10},
		  },
		  result = "coffee-low-grade"
		}
	},
	{
		type = "recipe",
		name = "coffee-high-grade",
		energy_required = 1.5,
		enabled = true,
		category = "crafting-with-fluid",
		icon = "__coffee__/graphics/icons/coffee-high-grade.png",
		icon_size = 32,
		main_product = "",
		subgroup = "capsule",
		allow_decomposition = false,
		normal =
		{
		  enabled = true,
		  ingredients =
		  {
			{type="fluid", name="steam", amount=50},
			{"coffee-beans", 10},
		  },
		  result = "coffee-high-grade"
		},
		expensive =
		{
		  enabled = true,
		  ingredients =
		  {
			{type="fluid", name="steam", amount=50},
			{"coffee-beans", 20},
		  },
		  result = "coffee-high-grade"
		}
	},
	{
		type = "recipe",
		name = "coffee-tree",
		energy_required = 1.5,
		enabled = true,
		category = "crafting-with-fluid",
		icon = "__base__/graphics/icons/tree-01.png",
		icon_mipmaps = 4,
		icon_size = 64,
		main_product = "",
		subgroup = "capsule",
		allow_decomposition = false,
		normal =
		{
		  enabled = true,
		  ingredients =
		  {
			{type="fluid", name="water", amount=50},
			{"coffee-beans", 1},
			{"stone", 10},
		  },
		  result = "coffee-tree"
		}
	}
})