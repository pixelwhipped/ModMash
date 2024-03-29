﻿data_final_fixes = true
require("prototypes.scripts.defines")
require("prototypes.scripts.types")
local patch_technology = modmashsplinternewworlds.util.tech.patch_technology

if mods["Krastorio2"] then
	require("prototypes.technology.newworlds")
	require("prototypes.technology.launch-platform") 
end

local local_create_clone= function(item)
	data:extend(
	{
		{
			type = "recipe",
			name = "clone-using-"..item.name,
			localised_name = {
				"item-name.clone"
			},
			localised_description = {
				"item-description.clone"
			},
			energy_required = 4.5,
			enabled = false,
			normal =
			{
				enabled = false,
				ingredients = modmashsplinternewworlds.util.get_item_ingredient_substitutions({"sludge"},
				modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-artifact"},
				{
					{item.name, 10},
					{"alien-artifact", 1},
					{type = "fluid", name = "sludge", amount = 100},
					{type = "fluid", name = "water", amount = 100},
				})),
				result = "clone"
			},
			expensive =
			{
				enabled = false,
				ingredients = modmashsplinternewworlds.util.get_item_ingredient_substitutions({"sludge"},
				modmashsplinternewworlds.util.get_item_ingredient_substitutions({"alien-artifact"},
				{
					{item.name, 20},
					{"alien-artifact", 2},
					{type = "fluid", name = "sludge", amount = 100},
					{type = "fluid", name = "water", amount = 100},
				})),
				result = "clone"
			},
			icon = false,
			icon = "__modmashsplinternewworlds__/graphics/icons/clone.png",
			icon_size = 64,
			icon_mipmaps = 4,
			category = "cloning",
			subgroup = "cloning",
			order = "a",
			allow_decomposition = false,
		}
	})
	patch_technology("terraformer","clone-using-"..item.name)
	if data.raw["module"]["clone"].limitation == nil then data.raw["module"]["clone"].limitation = {} end
	table.insert(data.raw["module"]["clone"].limitation,"clone-using-"..item.name)
end

for name,fish in pairs(data.raw["fish"]) do
	if fish.minable ~= nil and fish.minable.result ~= nil then
		local item = data.raw["capsule"][fish.minable.result] 
		if item == nil then item = data.raw["tool"][fish.minable.result] end
		if item == nil then item = data.raw["module"][fish.minable.result] end
		if item == nil then log("Nil item "..name) end
		if item ~= nil and item.stack_size == nil then log("Nil stack "..name) end
		if item ~= nil and item.stack_size ~= nil then
			local_create_clone(item)
		end
	end
end

if settings.startup["setting-lab-mod"].value == "Experimental" then
	for name, value in pairs(data.raw["lab"]) do
		if modmashsplinternewworlds.util.table.contains(data.raw["lab"][name].inputs,"alien-science-pack") ~= true then
			table.insert(data.raw["lab"][name].inputs,"alien-science-pack")
		end
	end
else
	if modmashsplinternewworlds.util.table.contains(data.raw["lab"]["lab"].inputs,"alien-science-pack") ~= true then
		table.insert(data.raw["lab"]["lab"].inputs,"alien-science-pack")
	end
end

table.insert(data.raw["module"]["clone"].limitation,"explorer")
table.insert(data.raw["module"]["clone"].limitation,"royal-jelly")
if mods["modmashsplintergold"] and data.raw["resource"]["gold-ore"] == nil then
data:extend(
{	
	{
		type = "resource",
		name = "gold-ore",
		icon = "__modmashsplintergold__/graphics/icons/gold-ore.png",
		icon_mipmaps = 4,
		icon_size = 64,
		flags = {"placeable-neutral"},
		order="a-b-z",
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
		  mining_particle = "stone-particle",
		  mining_time = 2.5,
		  result = "gold-ore"
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = 
		{
			create = false,
			starting_area = false,
			richness = 0.0,
			size = 0.0
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
		  sheet =
		  {
			filename = "__modmashsplinternewworlds__/graphics/entity/gold/gold.png",
			priority = "extra-high",
			size = 64,
			frame_count = 8,
			variation_count = 8,
			hr_version =
			{
			  filename = "__modmashsplinternewworlds__/graphics/entity/gold/hr-gold.png",
			  priority = "extra-high",
			  size = 128,
			  frame_count = 8,
			  variation_count = 8,
			  scale = 0.5
			}
		  }
		},
		map_color = {r=1.0, g=0.45, b=0.0},
		mining_visualisation_tint = {
			a = 1,
			b = 0.0,
			g = 0.45,
			r = 1.0
		}
	}
})
end