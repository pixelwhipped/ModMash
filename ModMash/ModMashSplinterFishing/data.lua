require ("prototypes.scripts.defines")
local get_name_for = modmashsplinterfishing.util.get_name_for

data:extend(
{
	{
		type = "item",
		name = "fishfood",
		icon = "__modmashsplinterfishing__/graphics/icons/fishfood.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "production-machine",
		order = "h[a]",
		place_result = "fishfood",
		stack_size = 100
	},
	{
		type = "item",
		name = "roe",
		icon = "__modmashsplinterfishing__/graphics/icons/row.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "production-machine",
		order = "h[a]",
		place_result = "roe",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "fishfood",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = {{"stone", 5},{type="fluid", name="water", amount=50}},
		icon = false,
		icon = "__modmashsplinterfishing__/graphics/icons/fishfood.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "intermediate-product",
		order = "c[fishfood]",
		main_product = "",
		results =
		{
			{name="fishfood", amount=50},     
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "roe",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = {{"alien-ore", 5},{"alien-artifact", 2},{"fishfood", 10}},
		icon = false,
		icon = "__modmashsplinterfishing__/graphics/icons/roe.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "intermediate-product",
		order = "c[roe]",
		main_product = "",
		results =
		{
			{name="row", amount=25},     
		},
		allow_decomposition = false,
	},
	{
		type = "technology",
		name = "fisheries",
		icon = "__modmashsplinteresources__/graphics/technology/fish.png",
		icon_size = 128,
		effects =
		{
			{
			type = "unlock-recipe",
			recipe = "fishfood"
			},{
			type = "unlock-recipe",
			recipe = "roe"
			},{
			type = "unlock-recipe",
			recipe = "nursery"
			}
		},
		prerequisites =
		{
			"fish1"
		},
		unit =
		{
			count = 75,
			ingredients =
			{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			},
			time = 35
		},
		upgrade = true,
		order = "a-b-d",
	}
})