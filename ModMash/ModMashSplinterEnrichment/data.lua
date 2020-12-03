require ("prototypes.scripts.defines")
local create_layered_icon_using =	modmashsplinterenrichment.util.create_layered_icon_using
local get_name_for = modmashsplinterenrichment.util.get_name_for

local icon_pin_topleft = modmashsplinterenrichment.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplinterenrichment.util.defines.icon_pin_top
local icon_pin_topright = modmashsplinterenrichment.util.defines.icon_pin_topright
local icon_pin_right = modmashsplinterenrichment.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplinterenrichment.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplinterenrichment.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplinterenrichment.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplinterenrichment.util.defines.icon_pin_left

local create_light_oil_conversion_crude_oil_icon = function()
	local icon = create_layered_icon_using(
	{
		{
			from = data.raw["fluid"]["steam"],
			scale = 0.7,
			pin = icon_pin_top
		},
		{
			from = data.raw["fluid"]["light-oil"],
			scale = 0.6,
			pin = icon_pin_top
		},
		{
			from = data.raw["fluid"]["crude-oil"],
			scale = 0.5,
			pin = icon_pin_bottomleft
		},
		{
			from = data.raw["fluid"]["crude-oil"],
			scale = 0.5,
			pin = icon_pin_bottomright
		}
	})
	return icon
end
data:extend(
{
	{
		type = "recipe",
		name = "light-oil-conversion-crude-oil",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = {{"coal", 15},{type="fluid", name="light-oil", amount=30},{type="fluid", name="steam", amount=50}},
		icon = false,
		icons = create_light_oil_conversion_crude_oil_icon(),
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "intermediate-product",
		order = "c[light-oil-conversion-crude-oil]",
		main_product = "",
		results =
		{
			{type="fluid", name="crude-oil", amount=50},     
		},
		allow_decomposition = false,
	},{
				type = "technology",
				name = "light-oil-conversion-crude-oil",
				icon = "__modmashsplinterenrichment__/graphics/technology/conversion.png",
				icon_size = 128,
				effects =
				{
					{
					type = "unlock-recipe",
					recipe = "light-oil-conversion-crude-oil"
					}
				},
				prerequisites =
				{
					"chemical-science-pack"
				},
				unit =
				{
					count = 75,
					ingredients =
					{
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
					{"chemical-science-pack", 1},
					},
					time = 35
				},
				upgrade = true,
				order = "a-b-d",
			}
})