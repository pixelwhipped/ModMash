require ("prototypes.scripts.defines")
require ("prototypes.categories.them")
require ("prototypes.item")
require ("prototypes.concrete")
require ("prototypes.entity.beams")
require ("prototypes.entity.bot")
require ("prototypes.entity.chest")
require ("prototypes.entity.logistics")
require ("prototypes.entity.pole")
require ("prototypes.entity.port")
require ("prototypes.entity.solar")
require ("prototypes.entity.pinch")
require ("prototypes.entity.them-matter-artillery")
require ("prototypes.entity.blocker")

data:extend(
{
  {
    type = "achievement",
    name = "them_arrival",
    order = "g[secret]-t[them_arrival]",
    icon = "__modmashsplinterthem__/graphics/achievement/them.png",
    icon_size = 128
  },{
    type = "achievement",
    name = "them_end_game",
    order = "g[secret]-t[them_end_game]",
    icon = "__modmashsplinterthem__/graphics/achievement/them.png",
    icon_size = 128
  },{
    type = "achievement",
    name = "them_oppenheimer",
    order = "g[secret]-t[them_oppenheimer]",
    icon = "__modmashsplinterthem__/graphics/achievement/them.png",
    icon_size = 128
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


menu_simulations.them = {
    checkboard = false,
    save = "__modmashsplinterthem__/saves/menu-simulation-them.zip",
    length = 60 * 10,
    init = [[
    local logo = game.surfaces.nauvis.find_entities_filtered{name = "factorio-logo-11tiles", limit = 1}[1]
    logo.force = "enemy"
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