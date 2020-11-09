local base_water_icon = {
		{
			icon = "__base__/graphics/icons/fluid/water.png",
			icon_mipmaps = 4,
			icon_size = 64
		}
	}

data:extend(
{
	{
		type = "recipe",
		name = modmashsplinterairpurifier.defines.names.air_purifier,
		energy_required = 10,
		enabled = false,
		normal =
		{
			enabled = false,
			ingredients =
			{
				{"assembling-machine-1", 1},
				{"engine-unit", 2},
				{"steel-plate", 5},
				{"pipe", 10},
			},
			result = modmashsplinterairpurifier.defines.names.air_purifier
		},
		expensive =
		{
			enabled = false,
			ingredients =
			{
				{"assembling-machine-1", 1},
				{"engine-unit", 3},
				{"steel-plate", 10},
				{"pipe", 15},
			},
			result = modmashsplinterairpurifier.defines.names.air_purifier
		}
	},{
		type = "recipe",
		name = modmashsplinterairpurifier.defines.names.advanced_air_purifier,
		energy_required = 10,
		enabled = false,
		normal =
		{
			enabled = false,
			ingredients = modmashsplinterairpurifier.util.get_item_ingredient_substitutions({"titanium-plate"},
			{
				{"assembling-machine-2", 2},
				{"effectivity-module", 2},
				{"engine-unit", 2},
				{"titanium-plate", 5},
			}),
			result = modmashsplinterairpurifier.defines.names.advanced_air_purifier
		},
		expensive =
		{
			enabled = false,
			ingredients = modmashsplinterairpurifier.util.get_item_ingredient_substitutions({"titanium-plate"},
			{
				{"assembling-machine-2", 1},
				{"effectivity-module", 4},
				{"engine-unit", 4},
				{"titanium-plate", 10},
			}),
			result = modmashsplinterairpurifier.defines.names.advanced_air_purifier
		}
	},{
		type = "recipe",
		name = "sludge-treatment",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = modmashsplinterairpurifier.util.get_item_ingredient_substitutions({"sludge"},
			{
				{type="fluid", name="sludge", amount=50}
			}),
		icon = false,
		icons = modmashsplinterairpurifier.util.create_icon(base_water_icon, nil, {from = modmashsplinterairpurifier.util.get_item_substitution("sludge"), rescale = .5}),
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "d[sludge-treatment]",
		main_product = "",
		results = modmashsplinterairpurifier.util.get_item_ingredient_substitutions({"sludge-by-product"},
		{			
			{
				type = "fluid",
				name = "water",
				amount = 25,
			},{
				name = "sludge-by-product",
				amount = 1,
				probability = 0.75
			}
			
		}),
		crafting_machine_tint =
		{
		   primary = {r = 0.0, g = 0.250, b = 1.0, a = 0.000},
		  secondary = {r = 0.0, g = 0.200, b = 0.812, a = 0.000},
		  tertiary = {r = 0.0, g = 0.180, b = 0.960, a = 0.000}, 
		},
		allow_decomposition = false,
	}
})