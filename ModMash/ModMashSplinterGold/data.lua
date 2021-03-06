﻿require ("prototypes.scripts.defines")

require("prototypes.item.gold") 
require("prototypes.recipe.gold") 

data:extend(
{
  {
    type = "achievement",
    name = "gold-rush",
    order = "d[production]-z[gold-rush]",
    icon = "__modmashsplintergold__/gold.png",
    amount = 20000,
    item_product = "gold-ore",
    icon_size = 128
  },
  {
    type = "build-entity-achievement",
    name = "gold-vanity",
    order = "d[production]-z[vanity]",
    icon = "__modmashsplintergold__/vanity.png",
    to_build = "gold-statue",
    limited_to_one_game = true,
    icon_size = 128
  },
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


menu_simulations.gold = {
    checkboard = false,
    save = "__modmashsplintergold__/saves/menu-simulation-gold.zip",
    length = 60 * 15,
    init = [[
    local logo = game.surfaces.nauvis.find_entities_filtered{name = "factorio-logo-11tiles", limit = 1}[1]
    game.camera_position = {
        logo.position.x,
        logo.position.y + 9.75
    }
    game.camera_zoom = 1
    game.tick_paused = false
    game.surfaces.nauvis.daytime = 0.5
    ]] ..
    [[]],
    update = [[]]
}