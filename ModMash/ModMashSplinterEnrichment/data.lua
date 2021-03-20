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
		subgroup = "fluid-recipes",
		order = "zz[light-oil-conversion-crude-oil]",
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

local menu_simulations = data.raw["utility-constants"]["default"].main_menu_simulations
--[[
menu_simulations.forest_fire = nil
menu_simulations.solar_power_construction = nil
menu_simulations.lab  = nil
menu_simulations.burner_city = nil
menu_simulations.mining_defense = nil
menu_simulations.biter_base_steamrolled = nil
menu_simulations.biter_base_spidertron = nil
menu_simulations.biter_base_artillery = nil
menu_simulations.biter_base_player_attack = nil
menu_simulations.biter_base_laser_defense = nil
menu_simulations.artillery = nil
menu_simulations.train_junction = nil
menu_simulations.oil_pumpjacks = nil
menu_simulations.oil_refinery = nil
menu_simulations.early_smelting = nil
menu_simulations.train_station = nil
menu_simulations.logistic_robots = nil
menu_simulations.nuclear_power = nil
menu_simulations.chase_player = nil
menu_simulations.big_defense = nil
menu_simulations.brutal_defeat = nil
menu_simulations.spider_ponds = nil
]]


menu_simulations.enrichment = {
    checkboard = false,
    save = "__modmashsplinterenrichment__/saves/menu-simulation-enrichment.zip",
    length = 60 * 15,
    init = [[
    local logo = game.surfaces.nauvis.find_entities_filtered{name = "factorio-logo-11tiles", limit = 1}[1]
    game.camera_position = {
        logo.position.x,
        logo.position.y + 9.75
    }
    game.camera_zoom = 1
    game.tick_paused = false
    game.surfaces.nauvis.daytime = 0
    ]] ..
    [[]],
    update = [[]]
}