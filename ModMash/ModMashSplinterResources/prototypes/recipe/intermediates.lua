require("prototypes.scripts.defines") 
local titanium_ore_name = modmashsplinterresources.util.get_item_ingredient_substitutions({"titanium-ore"},{{name = "titanium-ore", amount = 1}})[1].name
if titanium_ore_name == nil then titanium_ore_name = "titanium-ore" end
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


local create_titanium_extraction_process_icon = function()
	local icon = create_layered_icon_using(
	{
		{
			icon = "__modmashsplinterresources__/graphics/icons/titanium-ore.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.65,
			pin = icon_pin_top
		},
		{
			from = data.raw["fluid"]["steam"],
			scale = 0.5,
			pin = icon_pin_bottomleft
		},
		{
			from = data.raw["item"]["iron-ore"],
			scale = 0.5,
			pin = icon_pin_bottomright
		}
	})
	return icon
end

local create_alien_ooze_icon = function()
	local icon = create_layered_icon_using(
	{
		{
			icon = "__modmashsplinterresources__/graphics/icons/alien-ore.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.65,
			pin = icon_pin_top
		},
		{
			from = data.raw["fluid"]["alien-ooze"],
			scale = 0.5,
			pin = icon_pin_bottomleft
		},
		{
			from = data.raw["fluid"]["alien-ooze"],
			scale = 0.5,
			pin = icon_pin_bottomright
		}
	})
	return icon
end

local alien_artifact_enrichment_process_to_ore_icon = function()
	local icon = create_layered_icon_using(
	{
		{
			icon = "__modmashsplinterresources__/graphics/icons/alien-ooze.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.33,
			pin = icon_pin_topleft
		},
		{
			icon = "__modmashsplinterresources__/graphics/icons/alien-ooze.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.33,
			pin = icon_pin_top
		},

		{
			icon = "__modmashsplinterresources__/graphics/icons/alien-artifact.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.5,
			pin = icon_pin_bottomleft
		},
		{
			icon = "__modmashsplinterresources__/graphics/icons/alien-ore.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.33,
			pin = icon_pin_right
		},
		{
			icon = "__modmashsplinterresources__/graphics/icons/alien-ore.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.33,
			pin = icon_pin_bottomright
		}
	})
	return icon
end

local alien_enrichment_process_to_artifact_icon = function()
	local icon = create_layered_icon_using(
	{
		{
			icon = "__modmashsplinterresources__/graphics/icons/alien-ore.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.65,
			pin = icon_pin_topleft
		},
		{
			icon = "__modmashsplinterresources__/graphics/icons/sludge.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.65,
			pin = icon_pin_topright
		},
		{
			icon = "__modmashsplinterresources__/graphics/icons/alien-artifact.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 0.65,
			pin = icon_pin_bottom
		}
	})
	return icon
end

data:extend(
{
	{
		type = "recipe",
		name = "titanium-plate",
		category = "smelting",
		normal =
		{
			enabled = true,
			energy_required = 17.5,
			ingredients = {{titanium_ore_name, 5}},
			result = "titanium-plate"
		}
	},
	{
		type = "recipe",
		name = "alien-plate",
		category = "smelting",
		normal =
		{
			enabled = true,
			energy_required = 17.5,
			ingredients = {{"alien-ore", 1}},
			result = "alien-plate"
		},
	},

	{
		type = "recipe",
		name = "titanium-extraction-process",
		energy_required = 1.5,
		enabled = true,
		category = "crafting-with-fluid",
		icon = false,
		icons = create_titanium_extraction_process_icon(),
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "c[titanium-extraction-process]",
		main_product = "",
		normal =
		{
			enabled = true,
			energy_required = 6,
			ingredients =
			{
				{"iron-ore", 6},
				{type="fluid", name="steam", amount=50}
			},
			results =
			{
				{
					name = titanium_ore_name,
					amount = 4,
				}
			},
		},
		expensive =
		{
			enabled = true,
			energy_required = 6,
			ingredients =
			{
				{"iron-ore", 8},
				{type="fluid", name="steam", amount=50}
			},
			results =
			{
				{
					name = titanium_ore_name,
					amount = 4,
				}
			},
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-ooze",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"alien-ore", 75},{type="fluid", name="steam", amount=50}},
		icon = false,
		icons = create_alien_ooze_icon(),
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]",
		main_product = "",
		results =
		{			
			{
				type = "fluid",
				name = "alien-ooze",
				amount = 100
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
		name = "alien-artifact-enrichment-process-to-ore",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{name = "alien-artifact", amount = 2},{type="fluid", name = "alien-ooze",amount = 20}},
		icon = false,
		icons = alien_artifact_enrichment_process_to_ore_icon(),
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-d[alien-artifact-enrichment-process-to-ore]",
		main_product = "",
		results =
		{			
			{
			name = "alien-ore",
			amount = 75,
			}			
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process-to-artifact",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {
			{type="fluid",name = "sludge",amount = 25},
			{type="item",name = "alien-ore",amount = 25}
		},
		icon = false,
		icons = alien_enrichment_process_to_artifact_icon(),
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-e[alien-enrichment-process-to-artifact]",
		main_product = "",
		results =
		{			
			{
			name = "alien-artifact",
			amount = 2,
			}
		},
		allow_decomposition = false,
	}
}
)