--[[code reviewed 6.10.19]]
if not spaghetti.defines then spaghetti.defines = {} end
if not spaghetti.defines.defaults then spaghetti.defines.defaults = {} end
if not spaghetti.events then spaghetti.events = {} end

--[[defaults]]
spaghetti.defines.defaults.initial_distance = 32
spaghetti.defines.defaults.initial_expected_entitites_in_tiles = 20


--[[events]]
spaghetti.events.on_build = {defines.events.on_built_entity, defines.events.on_robot_built_entity}
spaghetti.events.on_remove = {defines.events.on_entity_died,defines.events.on_robot_pre_mined,defines.events.on_robot_mined_entity,defines.events.on_pre_player_mined_entity,defines.events.on_player_mined_entity}