--[[dsync checking 
ok only locals are reference to global
]]

--[[code reviewed 13.10.19]]
log("fishing-inserter.lua")
--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end

--[[defines]]
local allow_pickup_rotations = modmash.defines.names.allow_pickup_rotations
local allow_fishing = modmash.defines.names.allow_fishing
local low_priority = modmash.events.low_priority
local medium_priority = modmash.events.medium_priority
local high_priority = modmash.events.high_priority

--[[create local references]]
local fishing = nil
--[[util]]
local starts_with  = modmash.util.starts_with
local is_valid  = modmash.util.is_valid
local distance  = modmash.util.distance
local get_entities_around  = modmash.util.get_entities_around

local local_init = function()	
	if global.modmash.fishing == nil then global.modmash.fishing = {} end	
	if global.modmash.fishing.fishing_inserters == nil then global.modmash.fishing.fishing_inserters = {} end	
	if global.modmash.fishing.fishing_transferers == nil then global.modmash.fishing.fishing_transferers = {} end		
	fishing = global.modmash.fishing
	end

local local_load = function()	
	fishing = global.modmash.fishing
	end

local local_try_pickup_fish_at_position = function(inserter,entity)	
	if inserter.held_stack.valid_for_read == false and distance(inserter.position.x,inserter.position.y,entity.position.x,entity.position.y) <= 2 then
		inserter.pickup_position = {
			x = entity.position.x,
			y = entity.position.y
		}
		inserter.direction = inserter.direction
		if distance(inserter.held_stack_position.x,inserter.held_stack_position.y,entity.position.x,entity.position.y) <= 0.2 then
			entity.destroy()
			inserter.held_stack.set_stack({name="raw-fish", count=1})
		end
	end end

local local_fishing_transferer_process = function(entity)
	
	if entity.held_stack.valid_for_read ~= true then return end
	if entity.held_stack.name ~= "raw-fish" then return end
	if entity.held_stack.count == 0 then return end
	
	if distance(entity.held_stack_position.x,entity.held_stack_position.y,entity.drop_position.x,entity.drop_position.y) <= 0.1 then
		for k = 1, entity.held_stack.count do
			if entity.surface.can_place_entity({name="fish", amount=1, position=entity.drop_position}) then
				entity.surface.create_entity({name="fish", amount=1, position=entity.drop_position})
				entity.held_stack.count = math.max(entity.held_stack.count -1,0)
			end
		end
		
	end

end
--add check for frop position held position and over water
local local_fishing_inserter_process = function(entity)    	

	local fish = get_entities_around(entity,8, "fish")
	
	local fish_count = 0
	local spawner = nil
	local target = nil
	local current_dist = 0
	local target_dist = 100
	if fish ~= nil then
		for i, ent in pairs(fish) do					
			fish_count = fish_count + 1	
			local dist = distance(entity.held_stack_position.x,entity.held_stack_position.y,ent.position.x,ent.position.y)
			if dist > current_dist then
				current_dist = dist
				spawner = ent
			end
			if dist < target_dist then
				target_dist = dist
				target = ent
			end
		end
	end
	if target ~= nil then	
		local_try_pickup_fish_at_position(entity,target)
	end
	if spawner ~= nil and spawner.valid and fish_count < 10 then	
		local r = math.random()
		if r < 0.05 and entity.surface.can_place_entity({name="fish", amount=1, position=spawner.position}) then
			entity.surface.create_entity({name="fish", amount=1, position=spawner.position})
		end
	elseif fish_count == 0 then
		local box = {{entity.pickup_position.x-0.5, entity.pickup_position.y-0.5}, {entity.pickup_position.x+0.5, entity.pickup_position.y+0.5}}
		local tiles = entity.surface.find_tiles_filtered{area=box}
		for _,tile in pairs(tiles) do
			if tile.name == "water" and entity.surface.can_place_entity({name="fish", amount=1, position=spawner.position}) then 
				entity.surface.create_entity({name="fish", amount=1, position=tile.position})
			end
		end
	end end

local local_fishing_inserter_tick = function()	
	if fishing.allow_fishing  == true then 		
		local fishing_inserters = fishing.fishing_inserters	
		for index=1, #fishing.fishing_inserters do local fishing_inserter = fishing.fishing_inserters[index]
			if fishing_inserter.valid and fishing_inserter.energy ~= 0 then
				if not fishing_inserter.to_be_deconstructed(fishing_inserter.force) then					
					local_fishing_inserter_process(fishing_inserter)				
				end
			end
		end 
		for index=1, #fishing.fishing_transferers do local fishing_transferer = fishing.fishing_transferers[index]
			if fishing_transferer.valid and fishing_transferer.energy ~= 0 then
				if not fishing_transferer.to_be_deconstructed(fishing_transferer.force) then					
					local_fishing_transferer_process(fishing_transferer)				
				end
			end
		end
	end
	end

local local_check_fishing_inserter = function(entity)	
	local box = {{entity.pickup_position.x-0.5, entity.pickup_position.y-0.5}, {entity.pickup_position.x+0.5, entity.pickup_position.y+0.5}}
	local tiles = entity.surface.find_tiles_filtered{area=box}
	local water = false
	for _,tile in pairs(tiles) do
		if starts_with(tile.name, "water") then water = true end
	end
	if water == false then return end
	--entity.operable = false
	table.insert(fishing.fishing_inserters, entity)
end

local local_check_fishing_transferer = function(entity)			
	local tile = entity.surface.get_tile(entity.drop_position.x, entity.drop_position.y)
	if starts_with(tile.name, "water") then
		--entity.operable = false
		table.insert(fishing.fishing_transferers, entity)
	end
end

local local_fishing_inserter_added = function(entity)
	if entity.type == "inserter" then	
		local_check_fishing_inserter(entity)
		local_check_fishing_transferer(entity)
	end
	end

local local_fishing_inserter_removed = function(entity)
	if entity.type == "inserter" then		
		for index, fishing_inserter in ipairs(fishing.fishing_inserters) do
			if fishing_inserter.valid and fishing_inserter == entity then
				entity.operable = true
				table.remove(fishing.fishing_inserters, index)
				return
			end
		end
		for index, fishing_transferer in ipairs(fishing.fishing_transferers) do
			if fishing_transferer.valid and fishing_transferer == entity then
				entity.operable = true
				table.remove(fishing.fishing_transferers, index)
				return
			end
		end		
	end
	end

local local_on_selected = function(player,entity)
		if fishing.allow_pickup_rotations and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then
		if settings.startup["modmash-setting-show-adjustable"].value == true then
			entity.surface.create_entity{name="flying-text", position = entity.position, text="Press " .. settings.startup["modmash-setting-adjust-binding"].value .. " to adjust", color={r=1,g=1,b=1}}
		end
	end
	end

local local_pickup_rotations = {
  [0] = -- south
  {
	py = -1, px = 0
  },
  [2] = -- west
  {
	py = 0, px = 1
  },
  [4] = -- north
  {
  py = -1, px = 0
  },
  [6] = -- east
  {
  py = 0, px = 1,
  },}
local local_get_pickup_direction = function(entity)
  -- Returns inverted pickup_position direction to match insert_position direction
  local dy = entity.pickup_position.y - entity.position.y
  if dy > 0.5 then
    return defines.direction.north
  elseif dy < -0.5 then
    return defines.direction.south
  else
    local dx = entity.pickup_position.x - entity.position.x
    if dx < -0.5 then
      return defines.direction.east
    else
      return defines.direction.west
    end
  end end

local local_set_range = function(position_in,range)
  local position = {x = 0, y = 0}  
  if position_in.x > 0.1 then
    position.x = range
  elseif position_in.x < -0.1 then
    position.x = -range
  else
    position.x = 0
  end
  if position_in.y > 0.1 then
    position.y = range
  elseif position_in.y < -0.1 then
    position.y = -range
  else
    position.y = 0
  end
  return position
end

local local_apply_pickup_rotation = function(entity)
  local px = entity.pickup_position.x - entity.position.x
  local py = entity.pickup_position.y - entity.position.y
  local zx = math.abs(entity.drop_position.x - entity.position.x)
  local zy = math.abs(entity.drop_position.y - entity.position.y)
  local dir = local_get_pickup_direction(entity)

  local r  = local_set_range(
  {
    x = local_pickup_rotations[dir].py * py,
    y = local_pickup_rotations[dir].px * px
  },math.max(math.floor(math.abs(px)),math.floor(math.abs(py)),math.floor(zx),math.floor(zy),1))
  entity.pickup_position = { x = entity.position.x+r.x, y = entity.position.y+r.y}
  end



local local_rotate_pickup = function(entity)
  local_apply_pickup_rotation(entity)
  if local_get_pickup_direction(entity) == entity.direction then
    local_apply_pickup_rotation(entity)
  end
  entity.direction = entity.direction end

local local_on_player_rotated_entity = function(entity)
	if fishing.allow_pickup_rotations and is_valid(entity) and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then			
		if fishing.allow_fishing then		
			local_fishing_inserter_removed(entity)
			local_fishing_inserter_added(entity)
		end
	end end

local local_inserter_adjust = function(entity)
	if fishing.allow_pickup_rotations and is_valid(entity) and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then
		if fishing.allow_fishing then
			local_rotate_pickup(entity)	
			local_fishing_inserter_removed(entity)
			local_fishing_inserter_added(entity)
		else
			local_rotate_pickup(entity)	
		end
	end
end

local local_on_research = function(event)		
	if starts_with(event.research.name,allow_pickup_rotations) then
		fishing.allow_pickup_rotations = true
	elseif starts_with(event.research.name,allow_fishing) then
		fishing.allow_fishing = true
    end
	end

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version < "0.17.61" then	
		log("fishing-inserter local_on_configuration_changed")
		--fix entites
		global.modmash.fishing = {}
		global.modmash.fishing.fishing_inserters = {} -- just rebuild	
		global.modmash.fishing.fishing_transferers = {} -- just rebuild
		--fix tech
		for _, tech in pairs(game.players[1].force.technologies) do
			if tech.researched == true and starts_with(tech.name,allow_pickup_rotations) then
				global.modmash.fishing.allow_pickup_rotations = true
			end		
			if tech.researched == true and starts_with(tech.name,allow_fishing) then
				global.modmash.fishing.allow_fishing = true
			end
		end
		

		for _, surface in pairs(game.surfaces) do
			for c in surface.get_chunks() do
				local entities = surface.find_entities_filtered{area = c.area}
				for _, entity in pairs(entities) do
					local_fishing_inserter_added(entity)
				end
			end
		end
	end
	end

local local_on_entity_cloned = function(event)
	local entity = event.source
	if fishing.allow_pickup_rotations and is_valid(entity) and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then			
		if fishing.allow_fishing then		
			local_fishing_inserter_removed(entity)
			local_fishing_inserter_added(entity)
		end
	end
end

modmash.register_script({
	on_tick = {
		priority = high_priority,
		tick = local_fishing_inserter_tick
		},
	on_load = local_load,
	on_init = local_init,
	on_added = local_fishing_inserter_added,
	on_removed = local_fishing_inserter_removed,
	on_selected = local_on_selected,
	on_adjust = local_inserter_adjust,
	on_player_rotated_entity = local_on_player_rotated_entity,
	on_research = local_on_research,
	on_configuration_changed = local_on_configuration_changed,
	on_entity_cloned = local_on_entity_cloned
})
