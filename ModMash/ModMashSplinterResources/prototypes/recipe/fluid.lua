require("prototypes.scripts.defines") 
local get_name_for = modmashsplinterresources.util.get_name_for
local create_icon =	modmashsplinterresources.util.create_icon
local create_layered_icon_using =	modmashsplinterresources.util.create_layered_icon_using

local icon_pin_topleft = modmashsplinterresources.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplinterresources.util.defines.icon_pin_top
local icon_pin_topright = modmashsplinterresources.util.defines.icon_pin_topright
local icon_pin_right = modmashsplinterresources.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplinterresources.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplinterresources.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplinterresources.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplinterresources.util.defines.icon_pin_left

local create_sludge_treatment_icon = function()
	local icon = create_layered_icon_using(
	{
		{
			icon = "__modmashsplinterresources__/graphics/icons/sludge.png",--icon = "__modmashsplinterresources__/graphics/icons/sludge.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.65,
			pin = icon_pin_top
		},
		{
			from = data.raw["fluid"]["water"],
			scale = 0.5,
			pin = icon_pin_bottomleft
		},
		{
			from = data.raw["fluid"]["water"],
			scale = 0.5,
			pin = icon_pin_bottomright
		}
	})
	return icon
end

local create_fish_conversion_lubricant_icon = function()
	local icon = create_layered_icon_using(
	{
		{
			icon = "__modmashsplinterresources__/graphics/icons/fish-oil.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.65,
			pin = icon_pin_top
		},
		{
			from = data.raw["fluid"]["lubricant"],
			scale = 0.5,
			pin = icon_pin_bottomleft
		},
		{
			from = data.raw["fluid"]["lubricant"],
			scale = 0.5,
			pin = icon_pin_bottomright
		}
	})
	return icon
end

local create_fish_conversion_light_oil_icon = function()
	local icon = create_layered_icon_using(
	{
		{
			icon = "__modmashsplinterresources__/graphics/icons/fish-oil.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.65,
			pin = icon_pin_top
		},
		{
			from = data.raw["fluid"]["light-oil"],
			scale = 0.5,
			pin = icon_pin_bottomleft
		},
		{
			from = data.raw["fluid"]["light-oil"],
			scale = 0.5,
			pin = icon_pin_bottomright
		}
	})
	return icon
end

local create_local_create_fish_conversion_icon = function(item)
	local icon = create_layered_icon_using(
	{
		{
			icon = "__modmashsplinterresources__/graphics/icons/fish-oil.png",
			icon_mipmaps = 4,
			icon_size = 64,
		},
		{
			from = item,
			scale = 0.65,
			pin = icon_pin_bottomright
		}
	})
	return icon
end


data:extend(
{
	{
		type = "recipe",
		name = "sludge-treatment",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = {{type="fluid", name="sludge", amount=50}},
		icon = false,
		icons = create_sludge_treatment_icon(),
		icon_size = 64,
		subgroup = "fluid-recipes",
		order = "z[sludge-treatment]",
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
		name = "fish-conversion-light-oil",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = {{type="fluid", name="fish-oil", amount=15},{type="fluid", name="steam", amount=50}},
		icon = false,
		icons = create_fish_conversion_light_oil_icon(),
		icon_size = 64,
		subgroup = "fluid-recipes",
		order = "z[fish-conversion-light-oil]",
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
		icon = false,
		icons = create_fish_conversion_lubricant_icon(),
		icon_size = 64,
		subgroup = "fluid-recipes",
		order = "z[fish-conversion-lubricant]",
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
	}
}
)

local local_create_fish_conversion = function(item)
	data:extend(
	{
		{
			type = "recipe",
			name = "fish-conversion-for-"..item.name,
			energy_required = 1.5,
			enabled = true,
			category = "crafting-with-fluid",
			ingredients = {{item.name, 1}},
			icon = false,
			icons = create_local_create_fish_conversion_icon(item),
			icon_size = 64,
			localised_name = {"fluid.name.fish-oil"},
			localised_description = {"fluid.name.fish-oil"},
			subgroup = "fluid-recipes",
			order = "y[fish-conversion]["..item.name.."]",
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
		}
	})
end

for name,fish in pairs(data.raw["fish"]) do
	if fish.minable ~= nil and fish.minable.result ~= nil then
		local item = data.raw["capsule"][fish.minable.result] 
		if item == nil then log("Nil item "..name) end
		if item.stack_size == nil then log("Nil stack "..name) end
		if item ~= nil then
			local_create_fish_conversion(item)
		end
	end
end
