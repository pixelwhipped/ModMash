--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
	{
		type = "fuel-category",
		name = "advanced-alien"
	},
	{
		type = "item",
		name = "super-material",
		icon = "__modmashgraphics__/graphics/icons/super-material.png",
		icon_size = 32,
		fuel_category = "advanced-alien",
		fuel_value = "1GJ",
		fuel_acceleration_multiplier = 2.5,
		fuel_top_speed_multiplier = 1.15,
		subgroup = "intermediate-product",
		order = "z[super-material]",
		stack_size = 100
	  },
	  {
		type = "recipe",
		name = "super-material",	
		enabled = "false",
		subgroup = "intermediate-product",
		order = "z[z-super-material]",
		category = "crafting-with-fluid",
		ingredients = {{"uranium-238", 2},{type="fluid", name="alien-ooze", amount=100}},
		result = "super-material"
	  },
	  {
		type = "recipe",
		name = "super-material-235",	
		icon = "__modmashgraphics__/graphics/icons/super-to-235.png",
		icon_size = 32,
		enabled = "false",
		category = "crafting-with-fluid",
		subgroup = "intermediate-product",
		order = "z[zz-super-material]",
		ingredients = {{"super-material", 6},{type="fluid", name="sulfuric-acid", amount=25}},
		result = "uranium-235",
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000},
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000},
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000},
		},
	  },
	  {
		type = "recipe",
		name = "super-material-crude",	
		icon = "__modmashgraphics__/graphics/icons/super-to-crude.png",
		icon_size = 32,
		enabled = false,
		hide_from_player_crafting = true,
		category = "crafting-with-fluid",
		ingredients = {{"super-material", 4}},
		results =					
		{
			{type="fluid", name="crude-oil", amount=500}
		},
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000},
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000},
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000},
		},
	  }
  })