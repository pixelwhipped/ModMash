data:extend(
{
	{
		type = "fuel-category",
		name = "advanced-alien"
	},
	{
		type = "item",
		name = "super-material",
		localised_name = "Super Material",
		localised_description = "Super Material",
		icon = "__modmash__/graphics/icons/super-material.png",
		icon_size = 32,
		fuel_category = "advanced-alien",
		fuel_value = "2GJ",
		fuel_acceleration_multiplier = 2.5,
		fuel_top_speed_multiplier = 1.15,
		-- fuel_glow_color = {r = 0.1, g = 1, b = 0.1},
		subgroup = "intermediate-product",
		order = "z[super-material]",
		stack_size = 100
	  },
	  {
		type = "recipe",
		name = "super-material",	
		localised_name = "Super Material",
		localised_description = "Super Material",
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
		icon = "__modmash__/graphics/icons/super-to-235.png",
		icon_size = 32,
		localised_name = "Super Material to Uranium 235",
		localised_description = "Super Material to Uranium 235",
		enabled = "false",
		category = "crafting-with-fluid",
		subgroup = "intermediate-product",
		order = "z[zz-super-material]",
		ingredients = {{"super-material", 6},{type="fluid", name="sulfuric-acid", amount=25}},
		result = "uranium-235",
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000}, -- #ffa70000
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000}, -- #cfff0000
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000}, -- #f4cd0000
		},
	  },
	  {
		type = "recipe",
		name = "super-material-crude",	
		icon = "__modmash__/graphics/icons/super-to-crude.png",
		icon_size = 32,
		localised_name = "Super Material to Crude Oil",
		localised_description = "Super Material to Crude Oil",
		enabled = false,
		hide_from_player_crafting = true,
		category = "crafting-with-fluid",
		ingredients = {{"super-material", 2}},
		results =					
		{
			{type="fluid", name="crude-oil", amount=100}
		},
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000}, -- #ffa70000
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000}, -- #cfff0000
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000}, -- #f4cd0000
		},
	  }
  })