--[[dsync checking No Changes]]

--[[code reviewed 6.10.19]]
if not modmash.defines then modmash.defines = {} end
if not modmash.defines.names then modmash.defines.names = {} end
if not modmash.defines.defaults then modmash.defines.defaults = {} end
if not modmash.events then modmash.events = {} end

--[[names]]
modmash.defines.names.titanium_ore_name = "titanium-ore" 
if settings.startup["modmash-bob-support"].value == "Yes" then
	modmash.defines.names.titanium_ore_name = "rutile-ore" 
end
 

modmash.defines.names.force_player = "player"
modmash.defines.names.force_enemy = "enemy"
modmash.defines.names.force_neutral = "neutral"
modmash.defines.names.biter_neuro_toxin_cloud = "biter-neuro-toxin-cloud"
modmash.defines.names.enhance_biter_neuro_toxin_range = "enhance-biter-neuro-toxin-range"
modmash.defines.names.discharge_water_pump = "mm-discharge-water-pump"
modmash.defines.names.loot_science_prefix = "loot_science_"
modmash.defines.names.loot_science_a = modmash.defines.names.loot_science_prefix .. "a"
modmash.defines.names.loot_science_b = modmash.defines.names.loot_science_prefix .. "b"
modmash.defines.names.crash_site_prefix = "crash-site-chest-"
modmash.defines.names.allow_pickup_rotations = "allow-pickup-rotations"
modmash.defines.names.allow_fishing = "allow-fishing"
modmash.defines.names.recycling_machine = "recycling-machine"
modmash.defines.names.subspace_transport = "subspace-transport"
modmash.defines.names.underground_access = "underground-access"
modmash.defines.names.underground_access2 = "underground-access2"
modmash.defines.names.underground_accumulator = "underground-accumulator"

modmash.defines.names.wind_trap = "wind-trap"
modmash.defines.names.wind_trap_action_prefix = "wind-trap-action-"

--[[defaults]]
modmash.defines.defaults.biter_nero_toxin_research_modifier = 26
modmash.defines.defaults.biter_nero_toxin_research_modifier_increment = 1.1
modmash.defines.defaults.loot_probability = 13
modmash.defines.defaults.loot_tech_probability = 39
modmash.defines.defaults.loot_min_stack = 3
modmash.defines.defaults.loot_max_stack = 10
modmash.defines.defaults.loot_exclude_distance_from_origin = 224
modmash.defines.defaults.pollution_chunks_per_tick  = 10
modmash.defines.defaults.pollution_min_evolution_factor  = 0.025
modmash.defines.defaults.pollution_reduce_evolution_factor  = 0.0001
modmash.defines.defaults.super_container_stack_size = 5


--[[events]]
modmash.events.on_build = {defines.events.on_built_entity, defines.events.on_robot_built_entity}
modmash.events.on_remove = {defines.events.on_entity_died,defines.events.on_robot_pre_mined,defines.events.on_robot_mined_entity,defines.events.on_player_mined_entity}
modmash.events.on_pick_up_item = {defines.events.on_picked_up_item,defines.events.on_player_mined_item,defines.events.on_robot_mined}

modmash.events.low_priority = 44
modmash.events.medium_priority = 30
modmash.events.high_priority = 9