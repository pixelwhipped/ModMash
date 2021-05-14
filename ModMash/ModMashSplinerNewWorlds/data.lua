require ("prototypes.scripts.defines")

require("prototypes.categories.cloning") 
require("prototypes.categories.groups") 

require("prototypes.item.newworlds") 
require("prototypes.item.launch-platform") 
require("prototypes.entity.newworlds") 
require("prototypes.entity.launch-platform") 
require("prototypes.entity.gui") 
require("prototypes.recipe.newworlds") 
require("prototypes.recipe.launch-platform") 

if not mods["Krastorio2"] then
	require("prototypes.technology.newworlds")
	require("prototypes.technology.launch-platform") 
end

data:extend(
{
	{
		type = "shortcut",
		name = "planet-explorer",
		localised_name = {"", {"Shortcuts.planet-explorer-tooltip"}},
		order = "a[modmashsplinter]-[planet-explorer]",
		action = "lua",
		style = "green",
		icon =
		{
			filename = "__modmashsplinternewworlds__/graphics/toggle-x32.png",
			priority = "extra-high-no-scale",
			size = 32,
			scale = 1,
			flags = {"icon"}
		},
		small_icon =
		{
			filename = "__modmashsplinternewworlds__/graphics/toggle-x24.png",
			priority = "extra-high-no-scale",
			size = 24,
			scale = 1,
			flags = {"icon"}
		},
		disabled_icon =
		{
			filename = "__modmashsplinternewworlds__/graphics/toggle-x32-white.png",
			priority = "extra-high-no-scale",
			size = 32,
			scale = 1,
			flags = {"icon"}
		},
		disabled_small_icon =
		{
			filename = "__modmashsplinternewworlds__/graphics/toggle-x24-white.png",
			priority = "extra-high-no-scale",
			size = 24,
			scale = 1,
			flags = {"icon"}
		},
	}
})