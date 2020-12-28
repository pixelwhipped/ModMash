require ("prototypes.scripts.defines")

local create_layered_icon_using =	modmashsplintersubspacelogistics.util.create_layered_icon_using

local icon_pin_topleft = modmashsplintersubspacelogistics.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplintersubspacelogistics.util.defines.icon_pin_top
local icon_pin_topright = modmashsplintersubspacelogistics.util.defines.icon_pin_topright
local icon_pin_right = modmashsplintersubspacelogistics.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplintersubspacelogistics.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplintersubspacelogistics.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplintersubspacelogistics.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplintersubspacelogistics.util.defines.icon_pin_left

local super_material = 
	{
		type = "item",
		name = "super-material",
		icon = "__modmashsplintersubspacelogistics__/graphics/icons/super-material.png",
		icon_size = 64,
		icon_mipmaps = 4,
		fuel_category = "advanced-alien",
		fuel_value = "1GJ",
		fuel_acceleration_multiplier = 2.5,
		fuel_top_speed_multiplier = 1.15,
		subgroup = "intermediate-product",
		order = "z[super-material]",
		stack_size = 100
	}

local crude = data.raw["fluid"]["crude-oil"]
local uranium = data.raw["item"]["uranium-235"]

data:extend(
{
	{
		type = "fuel-category",
		name = "advanced-alien"
	},
	super_material,
	{
		type = "recipe",
		name = "super-material",	
		enabled = "false",
		subgroup = "super-material",
		category = "crafting-with-fluid",
		order = "a[super-material]",
		
		ingredients = {{"uranium-238", 2},{type="fluid", name="alien-ooze", amount=100}},
		result = "super-material"
	},
	{
		type = "recipe",
		name = "super-material-235",	
		icons = create_layered_icon_using({
			{
				from = super_material
			},
			{
				from = uranium,
				scale = 0.5,
				pin = icon_pin_bottomright
			}
		}),
		icon_size = 64,
		icon_mipmaps = 4,
		enabled = false,
		--hide_from_player_crafting = true,
		subgroup = "super-material",
		category = "crafting-with-fluid",
		order = "b[super-material]",
		ingredients = {{"super-material", 6},{type="fluid", name="sulfuric-acid", amount=25}},
		result = "uranium-235",
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000},
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000},
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000},
		},
	},
	{
		type = "recipe",
		name = "super-material-crude",	
		icons = create_layered_icon_using({
			{
				from = super_material
			},
			{
				from = crude,
				scale = 0.5,
				pin = icon_pin_bottomright
			}
		}),
		icon_size = 64,
		icon_mipmaps = 4,
		enabled = false,
		--hide_from_player_crafting = true,
		subgroup = "super-material",
		category = "crafting-with-fluid",
		order = "c[super-material]",
		ingredients = {{"super-material", 4}},
		results =					
		{
			{type="fluid", name="crude-oil", amount=500}
		},
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000},
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000},
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000},
		},
	}
  })