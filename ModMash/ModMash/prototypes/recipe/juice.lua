--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
	{
		type = "recipe",
		name = "fish-juice",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"iron-plate", 1},{"glass", 1},{type="fluid", name="fish-oil", amount=60}},
		icon = "__modmashgraphics__/graphics/icons/fish-juice.png",
		icon_size = 32,
		main_product = "",
		subgroup = "capsule",
		results =
		{			
			{
				name = "fish-juice",
				amount = 2,
			}			
		},
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000},
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000},
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000},
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "ooze-juice",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"iron-plate", 1},{"glass", 1},{type="fluid", name="alien-ooze", amount=120}},
		icon = "__modmashgraphics__/graphics/icons/ooze-juice.png",
		icon_size = 32,
		main_product = "",
		subgroup = "capsule",
		results =
		{			
			{
				name = "ooze-juice",
				amount = 2,
			}			
		},
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000},
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000},
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000}, 
		},
		allow_decomposition = false,
	}
})
