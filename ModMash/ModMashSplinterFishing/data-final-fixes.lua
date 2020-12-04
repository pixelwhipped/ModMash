data_final_fixes = true
require("prototypes.scripts.defines")
local get_name_for = modmashsplinterfishing.util.get_name_for
local create_icon =	modmashsplinterfishing.util.create_icon
local create_layered_icon_using = modmashsplinterfishing.util.create_layered_icon_using
local patch_technology = modmashsplinterfishing.util.patch_technology

local icon_pin_topleft = modmashsplinterfishing.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplinterfishing.util.defines.icon_pin_top
local icon_pin_topright = modmashsplinterfishing.util.defines.icon_pin_topright
local icon_pin_right = modmashsplinterfishing.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplinterfishing.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplinterfishing.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplinterfishing.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplinterfishing.util.defines.icon_pin_left


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
			energy_required = 1.5,
			enabled = true,
			category = "fisheries",
			ingredients = {
				{type="fluid", name = "water",amount = 50},
				{"roe", 1}
				{"fishfood", 1}
			},
			icon = false,
			icons = create_local_create_fish_icon(item),
			icon_size = 64,
			subgroup = "fluid-recipes",
			order = "a[fish-harvesting]["..item.name.."]",
			main_product = "",
			results =
			{			
				{
					name = item.name,
					amount = 10,
				}			
			}
			allow_decomposition = false,
		},
		{
			type = "recipe",
			name = "roe-from-"..item.name,
			energy_required = 1.5,
			enabled = false,
			category = "chemistry",
			ingredients = {{item.name, 1}},
			icon = false,
			icon = "__modmashsplinterfishing__/graphics/icons/roe.png",
			icon_size = 64,
			icon_mipmaps = 4,
			subgroup = "intermediate-product",
			order = "c[roe-from-"..item.name.."]",
			main_product = "",
			results =
			{
				{name="row", amount=25},     
			},
			allow_decomposition = false,
		},
	})
	patch_technology("fisheries","fish-harvesting-of-"..item.name)
	patch_technology("fisheries","roe-from-"..item.name)
end

for name,fish in pairs(data.raw["fish"]) do
	if fish.minable ~= nil and fish.minable.result ~= nil then
		local item = data.raw["capsule"][fish.minable.result] 
		if item == nil then log("Nil item "..name) end
		if item.stack_size == nil then log("Nil stack "..name) end
		if item ~= nil then
			local_create_fish_recipes(item)
		end
	end
end