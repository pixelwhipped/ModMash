data_final_fixes = true
require("prototypes.scripts.defines")
local get_name_for = modmashsplinterfishing.util.get_name_for
local create_icon =	modmashsplinterfishing.util.create_icon
local create_layered_icon_using = modmashsplinterfishing.util.create_layered_icon_using
local patch_technology = modmashsplinterfishing.util.tech.patch_technology

local icon_pin_topleft = modmashsplinterfishing.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplinterfishing.util.defines.icon_pin_top
local icon_pin_topright = modmashsplinterfishing.util.defines.icon_pin_topright
local icon_pin_right = modmashsplinterfishing.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplinterfishing.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplinterfishing.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplinterfishing.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplinterfishing.util.defines.icon_pin_left

local half_icon = function(initial_icons)
	if initial_icons == nil or type(initial_icons) ~= "table" or #initial_icons == 0 then 
		return initial_icons 
	end
	local icons = {}
	for k = 1, #initial_icons do local icon = initial_icons[k]
		if icon ~= nil then
			local current_icon = {}
			current_icon.icon = icon.icon
			current_icon.icon_size = icon.icon_size
			current_icon.icon_mipmaps = icon.icon_mipmaps
			current_icon.tint = icon.tint
			if icon.scale  ~= nil then
				current_icon.scale  = icon.scale *0.5
			else
				current_icon.scale = 0.5
			end
			if icon.shift~= nil then
				current_icon.shift = {icon.shift[1]*0.5, icon.shift[2]*0.5}
			end

			table.insert(icons,current_icon)
		end
	end
	return icons
end

local create_local_create_fish_icon = function(item)
	local icon = create_layered_icon_using(
	{
		{
			from = item,
		}
	})
	return icon
end

local local_create_fish_recipes = function(item)
	data:extend(
	{
		{
			type = "recipe",
			name = "fish-harvesting-of-"..item.name,
			energy_required = 15.5,
			enabled = true,
			category = "fisheries",
			ingredients = {
				{type="fluid", name = "water",amount = 50},
				{"roe", 2},
				{"fishfood", 20}
			},
			localised_name = get_name_for(item,""),
			localised_description = get_name_for(item,""),
			icon = false,
			icons = half_icon(create_local_create_fish_icon(item)),
			icon_size = 64,
			subgroup = "fisheries",
			order = "a[fish-harvesting]["..item.name.."]",
			main_product = "",
			result = item.name,
			result_count = 8,
			allow_decomposition = false
		},
		{
			type = "recipe",
			name = "roe-from-"..item.name,
			localised_name = {"recipe-name.defaultstring",{"item-name.roe"}} ,
			localised_description = {"recipe-name.defaultstring",{"item-name.roe"}} ,
			energy_required = 2.5,
			enabled = false,
			category = "crafting-with-fluid",
			ingredients = {{type="fluid", name = "water",amount = 50},{item.name, 1}},
			icon = false,
			icon = "__modmashsplinterfishing__/graphics/icons/roe.png",
			icon_size = 64,
			icon_mipmaps = 4,
			subgroup = "fisheries",
			order = "c[roe-from-"..item.name.."]",
			main_product = "",
			result = "roe",
			result_count = 3,
			allow_decomposition = false
		},
	})
	patch_technology("fisheries","fish-harvesting-of-"..item.name)
	patch_technology("fisheries","roe-from-"..item.name)
end

for name,fish in pairs(data.raw["fish"]) do
	if fish.minable ~= nil and fish.minable.result ~= nil then
		local item = data.raw["capsule"][fish.minable.result] 
		if item == nil then item = data.raw["tool"][fish.minable.result] end
		if item == nil then item = data.raw["module"][fish.minable.result] end
		if item == nil then log("Nil item "..name) end
		if item ~= nil and item.stack_size == nil then log("Nil stack "..name) end
		if item ~= nil and item.stack_size ~= nil then
			local_create_fish_recipes(item)
		end
	end
end