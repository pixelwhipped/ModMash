data_final_fixes = true
require("prototypes.scripts.defines")
local patch_technology = modmashsplinternewworlds.util.tech.patch_technology

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

if modmashsplinternewworlds.util.table.contains(data.raw["lab"]["lab"].inputs,"alien-science-pack") ~= true then
	table.insert(data.raw["lab"]["lab"].inputs,"alien-science-pack")
end

table.insert(data.raw["module"]["clone"].limitation,"explorer")
table.insert(data.raw["module"]["clone"].limitation,"royal-jelly")
