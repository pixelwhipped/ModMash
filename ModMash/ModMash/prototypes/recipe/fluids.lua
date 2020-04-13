--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
	{
		type = "recipe",
		name = "sludge-treatment",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = {{type="fluid", name="sludge", amount=50}},
		icon = "__modmashgraphics__/graphics/icons/sludge-purification.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "d[sludge-treatment]",
		main_product = "",
		results =
		{			
			{
				type = "fluid",
				name = "water",
				amount = 50,
			}			
		},
		crafting_machine_tint =
		{
		   primary = {r = 1.000, g = 0.250, b = 0.0, a = 0.000},
		  secondary = {r = 0.812, g = 0.200, b = 0.0, a = 0.000},
		  tertiary = {r = 0.960, g = 0.180, b = 0.0, a = 0.000}, 
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "fish-conversion",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"raw-fish", 1}},
		icon = "__modmashgraphics__/graphics/icons/fish-conversion.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "d[fish-conversion]",
		main_product = "",
		results =
		{			
			{
				type = "fluid",
				name = "fish-oil",
				amount = 25,
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
		name = "fish-conversion-light-oil",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = {{type="fluid", name="fish-oil", amount=15},{type="fluid", name="steam", amount=50}},
		icon = "__modmashgraphics__/graphics/icons/fish-conversion-light-oil.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "d[sludge-treatment]",
		main_product = "",
		results =
		{			
			{
				type = "fluid",
				name = "light-oil",
				amount = 25,
			}			
		},
		crafting_machine_tint =
		{
			primary = {r = 0.290, g = 0.027, b = 0.000, a = 0.000},
			secondary = {r = 0.722, g = 0.465, b = 0.190, a = 0.000},
			tertiary = {r = 0.870, g = 0.365, b = 0.000, a = 0.000},
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "fish-conversion-lubricant",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = {{type="fluid", name="fish-oil", amount=15},{type="fluid", name="steam", amount=50}},
		icon = "__modmashgraphics__/graphics/icons/fish-conversion-lubricant.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "d[sludge-treatment]",
		main_product = "",
		results =
		{			
			{
				type = "fluid",
				name = "lubricant",
				amount = 20,
			}			
		},
		crafting_machine_tint =
		{
			primary = {r = 0.290, g = 0.027, b = 0.000, a = 0.000},
			secondary = {r = 0.722, g = 0.465, b = 0.190, a = 0.000},
			tertiary = {r = 0.870, g = 0.365, b = 0.000, a = 0.000},
		},
		allow_decomposition = false,
	},
}
)