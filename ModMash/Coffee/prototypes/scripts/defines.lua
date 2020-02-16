if not coffee.defines then coffee.defines = {} end
if not coffee.defines.names then coffee.defines.names = {} end
if not coffee.defines.defaults then coffee.defines.defaults = {} end
if not coffee.events then coffee.events = {} end

--[[names]]
coffee.defines.names.force_player = "player"
coffee.defines.names.force_enemy = "enemy"
coffee.defines.names.force_neutral = "neutral"

--[[defaults]]
coffee.defines.defaults.coffee_decrease_per_nth_tick = 60*5
coffee.defines.defaults.coffee_max_tree_chest = 50
coffee.defines.defaults.coffee_chest_growth_rate_per_nth_tick = 60*2   --every 2 seconds

--[[events]]
coffee.events.on_build = {defines.events.on_built_entity, defines.events.on_robot_built_entity}
coffee.events.on_remove = {defines.events.on_entity_died,defines.events.on_robot_pre_mined,defines.events.on_robot_mined_entity,defines.events.on_player_mined_entity}
coffee.events.on_pick_up_item = {defines.events.on_picked_up_item,defines.events.on_player_mined_item,defines.events.on_robot_mined}

coffee.events.low_priority = coffee.defines.defaults.coffee_decrease_per_nth_tick
coffee.events.medium_priority = coffee.defines.defaults.coffee_chest_growth_rate_per_nth_tick
coffee.events.high_priority = 44