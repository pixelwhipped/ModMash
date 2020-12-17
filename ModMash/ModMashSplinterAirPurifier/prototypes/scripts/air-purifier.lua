local air_purifier  = modmashsplinterairpurifier.defines.names.air_purifier
local advanced_air_purifier  = modmashsplinterairpurifier.defines.names.advanced_air_purifier 
local air_purifier_prefix  = modmashsplinterairpurifier.defines.names.air_purifier_action_prefix 


--[[create local references]]
--[[util]]
local print  = modmashsplinterairpurifier.util.print
local is_valid  = modmashsplinterairpurifier.util.is_valid
local get_biome  = modmashsplinterairpurifier.util.get_biome
local try_set_recipe  = modmashsplinterairpurifier.util.entity.try_set_recipe
local is_valid  = modmashsplinterairpurifier.util.is_valid
local fail_place_entity  = modmashsplinterairpurifier.util.fail_place_entity

local local_air_purifier_pump_added = function(entity,event)
	
	local r = 10
	local aabb = entity.prototype.collision_box
    local box = { { entity.position.x - r - aabb.left_top.x, entity.position.y - r - aabb.left_top.y }, { entity.position.x + r + aabb.right_bottom.x, entity.position.y + r + aabb.right_bottom.y } }
	local cbox = { { entity.position.x + aabb.left_top.x, entity.position.y + aabb.left_top.y }, { entity.position.x + aabb.right_bottom.x, entity.position.y + aabb.right_bottom.y } }
	local tiles = entity.surface.find_tiles_filtered{area=cbox}
	local total = 0
	for _,tile in pairs(tiles) do
		if tile.prototype.emissions_per_second <= 0 then
			fail_place_entity(entity,event,{"modmashsplinterairpurifier.placement-disallowed"})
			return
		end		
    end

	--try_set_recipe(entity,air_purifier_prefix .. "hi")
	entity.operable = false
	--return
	
	tiles = entity.surface.find_tiles_filtered{area=box}
	for _,tile in pairs(tiles) do
		total = total + tile.prototype.emissions_per_second
    end

	if total<0.0024 then
		try_set_recipe(entity,air_purifier_prefix .. "low")
	elseif total < 0.0026 then
		try_set_recipe(entity,air_purifier_prefix .. "medium")
	else
		try_set_recipe(entity,air_purifier_prefix .. "hi")
	end
	
end

script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_air_purifier_pump_added(event.created_entity,event) end 
	end,
	{{filter = "type", type = "assembling-machine"}, {filter = "name", name = air_purifier, mode = "and"}, {filter = "name", name = advanced_air_purifier}})

script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_air_purifier_pump_added(event.created_entity,event) end 
	end,
	{{filter = "type", type = "assembling-machine"}, {filter = "name", name = air_purifier, mode = "and"}, {filter = "name", name = advanced_air_purifier}})

script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.entity) then local_air_purifier_pump_added(event.entity,event) end 
	end,
	{{filter = "type", type = "assembling-machine"}, {filter = "name", name = air_purifier, mode = "and"}, {filter = "name", name = advanced_air_purifier}})

script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_air_purifier_pump_added(event.entity,event) end 
	end,
	{{filter = "type", type = "assembling-machine"}, {filter = "name", name = air_purifier, mode = "and"}, {filter = "name", name = advanced_air_purifier}})

script.on_event(defines.events.on_entity_cloned,
	function(event) 
		if is_valid(event.source) then local_air_purifier_pump_added(event.source, nil) end 
	end,
	{{filter = "type", type = "assembling-machine"}, {filter = "name", name = air_purifier, mode = "and"}, {filter = "name", name = advanced_air_purifier}})