require("prototypes.scripts.defines") 

data:extend(
{
	{
		type = "recipe",
		name = "explorer",
		energy_required = 10,
		enabled = false,
		normal =
		{
			enabled = false,
			ingredients = modmashsplinternewworlds.util.get_item_ingredient_substitutions({"super-material"},
				modmashsplinternewworlds.util.get_item_ingredient_substitutions({"subspace-transport"},
			{
				{"clone", 50},
				{"super-material", 1},
				{"subspace-transport", 1},
			})),
			result = "explorer"
		},
		expensive =
		{
			enabled = false,
			ingredients = modmashsplinternewworlds.util.get_item_ingredient_substitutions({"super-material"},
				modmashsplinternewworlds.util.get_item_ingredient_substitutions({"subspace-transport"},			
			{
				{"clone", 100},
				{"super-material", 1},
				{"subspace-transport", 1},
			})),
			result = "explorer"
		},
		icon = false,
		icon = "__modmashsplinternewworlds__/graphics/icons/explorer.png",
		icon_size = 64,
		icon_mipmaps = 4,
		category = "cloning",
		subgroup = "cloning",
		order = "b",
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "terraformer",
		energy_required = 5.5,
		enabled = false,
		normal =
		{
			enabled = false,
			ingredients = modmashsplinternewworlds.util.get_item_ingredient_substitutions({"titanium-plate"},
			{
				{"assembling-machine-2", 2},
				{"advanced-circuit", 3},
				{"titanium-plate", 5},
			}),
			result = "terraformer"
		},
		expensive =
		{
			enabled = false,
			ingredients = modmashsplinternewworlds.util.get_item_ingredient_substitutions({"titanium-plate"},
			{
				{"assembling-machine-2", 2},
				{"advanced-circuit", 3},
				{"titanium-plate", 5},
			}),
			result = "terraformer"
		},
		icon = false,
		icon = "__modmashsplinternewworlds__/graphics/icons/terraformer.png",
		icon_size = 64,
		icon_mipmaps = 4,
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "royal-jelly",
		energy_required = 3,
		enabled = false,
		category = "chemistry",
		normal =
		{
			enabled = false,
			ingredients =  modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-ooze"},
			modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-artifact"},
			{
				{"alien-artifact", 5},
				{type = "fluid", name = "alien-ooze", amount= 100}
			})),
			result = "royal-jelly"
		},
		expensive =
		{
			enabled = false,
			ingredients =  modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-ooze"},
			modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-artifact"},
			{
				{"alien-artifact", 8},
				{type = "fluid", name = "alien-ooze", amount = 100}
			})),
			result = "royal-jelly"
		},
		icon = false,
		icon = "__modmashsplinternewworlds__/graphics/icons/royal-jelly.png",
		icon_size = 64,
		icon_mipmaps = 4,
		allow_decomposition = false,
		crafting_machine_tint =
		{
		  primary = {r = 0.0, g = 0.0, b = 1.0, a = 0.000},
		  secondary = {r = 0.0, g = 0.0, b = 0.812, a = 0.000},
		  tertiary = {r = 0.0, g = 0.0, b = 0.960, a = 0.000}, 
		},
	},
	{
		type = "recipe",
		name = "creative-royal-jelly-with-pureonium",
		energy_required = 3,
		enabled = false,
		category = "chemistry",
		normal =
		{
			enabled = false,
			ingredients =  modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-ore"},
			{
				{"creative-mod-pureonium", 15},
				{name = "alien-ore", amount= 20}
			}),
			result = "royal-jelly"
		},
		expensive =
		{
			enabled = false,
			ingredients =  modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-ore"},
			{
				{"creative-mod-pureonium", 20},
				{name = "alien-ore", amount = 25}
			}),
			result = "royal-jelly"
		},
		icon = false,
		icon = "__modmashsplinternewworlds__/graphics/icons/royal-jelly.png",
		icon_size = 64,
		icon_mipmaps = 4,
		allow_decomposition = false,
		crafting_machine_tint =
		{
		  primary = {r = 0.0, g = 0.0, b = 1.0, a = 0.000},
		  secondary = {r = 0.0, g = 0.0, b = 0.812, a = 0.000},
		  tertiary = {r = 0.0, g = 0.0, b = 0.960, a = 0.000}, 
		},
	},
	{
		type = "recipe",
		name = "alien-science-pack",
		energy_required = 3,
		enabled = false,
		category = "crafting-with-fluid",
		normal =
		{
			enabled = false,
			ingredients = modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-plate"},
			modmashsplinternewworlds.util.get_item_ingredient_substitutions({"titanium-plate"},
			{
				{"royal-jelly", 10},
				{"alien-plate", 5},
				{"titanium-plate", 5},
			})),
			result = "alien-science-pack"
		},
		expensive =
		{
			enabled = false,
			ingredients = modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-plate"},
			modmashsplinternewworlds.util.get_item_ingredient_substitutions({"titanium-plate"},
			{
				{"royal-jelly", 20},
				{"alien-plate", 5},
				{"titanium-plate", 5},
			})),
			result = "alien-science-pack"
		},
		icon = false,
		icon = "__modmashsplinternewworlds__/graphics/icons/alien-science-pack.png",
		icon_size = 64,
		icon_mipmaps = 4,
		allow_decomposition = false,
	},
})