log("coffee-harvester.lua")
--[[check and import utils]]
if coffee == nil or coffee.util == nil then require("prototypes.scripts.util") end
if not coffee.defines then require ("prototypes.scripts.defines") end

--[[defines]]
local allow_pickup_rotations = coffee.defines.names.allow_pickup_rotations
local allow_fishing = coffee.defines.names.allow_fishing
local low_priority = coffee.events.low_priority
local medium_priority = coffee.events.medium_priority
local high_priority = coffee.events.high_priority

--[[create local references]]
local harvester = nil
--[[util]]
local starts_with  = coffee.util.starts_with
local is_valid  = coffee.util.is_valid
local distance  = coffee.util.distance
local get_entities_around  = coffee.util.get_entities_around

local local_init = function()	
	if global.coffee.harvester == nil then global.coffee.harvester = {} end	
	if global.coffee.harvester.harvester_inserters == nil then global.coffee.harvester.harvester_inserters = {} end	
	harvester = global.coffee.harvester
	end

local local_load = function()	
	harvester = global.coffee.harvester
	end

local local_try_pickup_coffee_at_position = function(inserter,entity)	
	if inserter.held_stack.valid_for_read == false and distance(inserter.position.x,inserter.position.y,entity.position.x,entity.position.y) <= 2 then
		inserter.pickup_position = {
			x = entity.position.x,
			y = entity.position.y
		}
		inserter.direction = inserter.direction
		if distance(inserter.held_stack_position.x,inserter.held_stack_position.y,entity.position.x,entity.position.y) <= 0.2 then
			--entity.destroy()--add check and remove
			inserter.held_stack.set_stack({name="coffee-beans", count=1})
		end
	end end


--change required tree
local local_harvester_inserter_process = function(entity)    	
	local tree = get_entities_around(entity,8, "tree")
	local tree_count = 0
	local target = nil
	local current_dist = 0
	local target_dist = 100
	if tree ~= nil then
		for i, ent in pairs(tree) do					
			tree_count = tree_count + 1	
			local dist = distance(entity.held_stack_position.x,entity.held_stack_position.y,ent.position.x,ent.position.y)
			if dist > current_dist then
				current_dist = dist
			end
			if dist < target_dist then
				target_dist = dist
				target = ent
			end
		end
	end
	if target ~= nil then	
		local_try_pickup_coffee_at_position(entity,target)
	end
	end

local local_harvester_inserter_tick = function()		
	local harvester_inserters = harvester.harvester_inserters	
	for index=1, #harvester_inserters do local harvester_inserter = harvester_inserters[index]
		if harvester_inserter.valid and harvester_inserter.energy ~= 0 then
			if not harvester_inserter.to_be_deconstructed(harvester_inserter.force) then					
				local_harvester_inserter_process(harvester_inserter)				
			end
		end
	end 
	end

local local_check_harvester_inserter = function(entity)	
	local box = {{entity.pickup_position.x-0.5, entity.pickup_position.y-0.5}, {entity.pickup_position.x+0.5, entity.pickup_position.y+0.5}}
	local entities = entity.surface.find_entities_filtered{area=box, type = "tree"}
	if #entities == 0 then return end
	--entity.operable = false
	table.insert(harvester.harvester_inserters, entity)
end

local local_harvester_inserter_added = function(entity)
	if entity.type == "inserter" then	
		local_check_harvester_inserter(entity)
	end
	end

local local_harvester_inserter_removed = function(entity)
	if entity.type == "inserter" then		
		for index, harvester_inserter in ipairs(harvester.harvester_inserters) do
			if harvester_inserter.valid and harvester_inserter == entity then
				entity.operable = true
				table.remove(harvester.harvester_inserters, index)
				return
			end
		end	
	end
	end

local local_on_player_rotated_entity = function(entity)
	if is_valid(entity) and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then			
		local_harvester_inserter_removed(entity)
		local_harvester_inserter_added(entity)
	end 
	end

local local_on_configuration_changed = function(f)
	if f.mod_changes["coffee"].old_version < "0.18.00" then	
		log("fishing-inserter local_on_configuration_changed")
		--fix entites
		global.coffee.harvester = {}	
		global.coffee.harvester.harvester_inserters = {}	
		for _, surface in pairs(game.surfaces) do
			for c in surface.get_chunks() do
				local entities = surface.find_entities_filtered{area = c.area}
				for _, entity in pairs(entities) do
					local_harvester_inserter_added(entity)
				end
			end
		end
	end
	end

local local_on_entity_cloned = function(event)
	local entity = event.source
	if is_valid(entity) and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then				
		local_harvester_inserter_removed(entity)
		local_harvester_inserter_added(entity)
	end
	end

coffee.register_script({
	on_tick = {
		priority = high_priority,
		tick = local_harvester_inserter_tick
		},
	on_load = local_load,
	on_init = local_init,
	on_added = local_harvester_inserter_added,
	on_removed = local_harvester_inserter_removed,
	on_player_rotated_entity = local_on_player_rotated_entity,
	on_configuration_changed = local_on_configuration_changed,
	on_entity_cloned = local_on_entity_cloned
})
