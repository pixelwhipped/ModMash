--[[dsync checking No Changes]]

--[[code reviewed 6.10.19]]
if not heroturrets.defines then heroturrets.defines = {} end
if not heroturrets.defines.names then heroturrets.defines.names = {} end
if not heroturrets.defines.defaults then heroturrets.defines.defaults = {} end
if not heroturrets.events then heroturrets.events = {} end

--[[names]]
heroturrets.defines.names.force_player = "player"
heroturrets.defines.names.force_enemy = "enemy"
heroturrets.defines.names.force_neutral = "neutral"

heroturrets.defines.turret_initial_one_value = 50
heroturrets.defines.turret_initial_two_value = 250
heroturrets.defines.turret_initial_three_value = 500
heroturrets.defines.turret_initial_four_value = 5000


--[[defaults]]
local percent = settings.startup["heroturrets-setting-level-up-modifier"].value/100
heroturrets.defines.turret_levelup_one = heroturrets.defines.turret_initial_one_value + (math.floor((heroturrets.defines.turret_initial_one_value*percent)/10)*100)
heroturrets.defines.turret_levelup_two = heroturrets.defines.turret_initial_two_value + (math.floor((heroturrets.defines.turret_initial_two_value*percent)/10)*100)
heroturrets.defines.turret_levelup_three = heroturrets.defines.turret_initial_three_value + (math.floor((heroturrets.defines.turret_initial_three_value*percent)/10)*100)
heroturrets.defines.turret_levelup_four = heroturrets.defines.turret_initial_four_value + (math.floor((heroturrets.defines.turret_initial_four_value*percent)/10)*100)

--[[events]]
heroturrets.events.on_build = {defines.events.on_built_entity, defines.events.on_robot_built_entity,defines.events.script_raised_built,defines.events.script_raised_revive}
heroturrets.events.on_remove = {defines.events.on_entity_died,defines.events.on_robot_pre_mined,defines.events.on_robot_mined_entity,defines.events.on_player_mined_entity,defines.events.script_raised_destroy}
heroturrets.events.on_pick_up_item = {defines.events.on_picked_up_item,defines.events.on_player_mined_item,defines.events.on_robot_mined}

heroturrets.events.low_priority = 44
heroturrets.events.medium_priority = 30
heroturrets.events.high_priority = 9
