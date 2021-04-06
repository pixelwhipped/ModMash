require ("prototypes.scripts.defines")
local is_valid  = modmashsplinterfishing.util.is_valid
local starts_with  = modmashsplinterfishing.util.starts_with
local is_valid  = modmashsplinterfishing.util.is_valid
local distance  = modmashsplinterfishing.util.distance
local get_entities_around  = modmashsplinterfishing.util.entity.get_entities_around
local print = modmashsplinterfishing.util.print
local contains = modmashsplinterfishing.util.table.contains

local allow_fishing = modmashsplinterfishing.defines.names.allow_fishing

local fish_names = nil
local fish_entity_names = nil
local fish_item_names = nil


local get_fish_names = function()
	if fish_names ~= nil and fish_entity_names ~= nil then return fish_names end
	fish_names = {}
	fish_entity_names = {}
	fish_item_names = {}
	for name,fish in pairs(game.entity_prototypes) do		
		
		if fish ~= nil and fish.type == "fish" then
			if fish.mineable_properties ~= nil and fish.mineable_properties.products ~=  nil then
				for k=1, #fish.mineable_properties.products do local prod = fish.mineable_properties.products[k]
					local item = game.item_prototypes[prod.name] 
					if item == nil then log("Nil item "..name) end
					log(item.name)
					if item.stack_size == nil then log("Nil stack "..name) end
					if item ~= nil then
						fish_names[item.name] = fish.name
						fish_item_names[fish.name] = item.name
						table.insert(fish_entity_names,fish.name)
					end
				end
			end
		end
	end
	return fish_names
end
local get_fish_entity_names = function()
	if fish_entity_names ~= nil then return fish_entity_names end
	get_fish_names()
	return fish_entity_names
end

local get_fish_item_names = function()
	if fish_item_names ~= nil then return fish_item_names end
	get_fish_names()
	return fish_item_names
end

--[[create local references]]
local fishing = nil
--[[util]]


local local_init = function()	
	if global.modmashsplinterfishing.fishing == nil then global.modmashsplinterfishing.fishing = {} end	
	if global.modmashsplinterfishing.fishing.fishing_inserters == nil then global.modmashsplinterfishing.fishing.fishing_inserters = {} end	
	if global.modmashsplinterfishing.fishing.fishing_transferers == nil then global.modmashsplinterfishing.fishing.fishing_transferers = {} end	
	if global.modmashsplinterfishing.fishing.fishing_fish_cache == nil then global.modmashsplinterfishing.fishing.fishing_fish_cache = {} end
	fishing = global.modmashsplinterfishing.fishing
	fishing_inserters = fishing.fishing_inserters
	fishing_transferers = fishing.fishing_transferers
	fishing_fish_cache = fishing.fishing_fish_cache
	end

local local_load = function()	
	fishing = global.modmashsplinterfishing.fishing
	fishing_inserters = fishing.fishing_inserters
	fishing_transferers = fishing.fishing_transferers
	fishing_fish_cache = fishing.fishing_fish_cache
	end

local local_fishing_transferer_process = function(entity)
	
	if entity.held_stack.valid_for_read ~= true then return end
	if get_fish_names()[entity.held_stack.name] == nil then return end
	if entity.held_stack.count == 0 then return end
	
	if distance(entity.held_stack_position.x,entity.held_stack_position.y,entity.drop_position.x,entity.drop_position.y) <= 0.1 then
		for k = 1, entity.held_stack.count do
			if entity.surface.can_place_entity({name=get_fish_names()[entity.held_stack.name], amount=1, position=entity.drop_position}) then
				entity.surface.create_entity({name=get_fish_names()[entity.held_stack.name], amount=1, position=entity.drop_position})
				entity.held_stack.count = math.max(entity.held_stack.count -1,0)
			end
		end
		
	end

end

local local_try_pickup_fish_at_position = function(inserter,entity)	
	if inserter.held_stack.valid_for_read == false and distance(inserter.position.x,inserter.position.y,entity.position.x,entity.position.y) <= 2 then
		inserter.pickup_position = {
			x = entity.position.x,
			y = entity.position.y
		}
		inserter.direction = inserter.direction
		if distance(inserter.held_stack_position.x,inserter.held_stack_position.y,entity.position.x,entity.position.y) <= 0.2 then			
			
			if entity.type == "fish" then
				local result = get_fish_item_names()[entity.name]
				if result ~= nil then
				--for k=1, #entity.mineable_properties.products do local prod = entity.mineable_properties.products[k]
					entity.destroy()
					inserter.held_stack.set_stack({name=result, count=1})
				--end
				end
			end
			
		end
	end end


local local_fishing_inserter_process = function(entity)    	
	local fish = nil
	local fish_tbl = fishing_fish_cache[entity]
	if fish_tbl == nil then
		fishing_fish_cache[entity] = 
			{
				fish = entity.surface.find_entities_filtered{area = {{entity.position.x-8, entity.position.y-8}, {entity.position.x+8, entity.position.y+8}}, type = "fish"},
				--get_entities_around(entity,8,"fish"),
				coundown = 200
			}
	else
		fish_tbl.coundown = fish_tbl.coundown - 1
		if fish_tbl.coundown <=0 then
			fishing_fish_cache[entity] = 
			{
				fish = entity.surface.find_entities_filtered{area = {{entity.position.x-8, entity.position.y-8}, {entity.position.x+8, entity.position.y+8}}, type = "fish"},
				coundown = 200
			}
		end		
	end
	fish = fishing_fish_cache[entity].fish

	local fish_count = #fish

	local target = nil
	local current_dist = 0
	local target_dist = 100
	if fish ~= nil then
		for i=1, #fish do local ent = fish[i]		
			if is_valid(ent) then
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
	end
	if target ~= nil then	
		local_try_pickup_fish_at_position(entity,target)
	end
	if fish_count < 10 and spawner ~= nil and spawner.valid then	
		local r = math.random()
		local pfish = fish_entity_names[math.random(1,#get_fish_entity_names())]
		if r < 0.05 and entity.surface.can_place_entity({name=pfish, amount=1, position=spawner.position}) then
			entity.surface.create_entity({name=pfish, amount=1, position=spawner.position})
		end
	elseif fish_count == 0 then
		local box = {{entity.pickup_position.x-0.5, entity.pickup_position.y-0.5}, {entity.pickup_position.x+0.5, entity.pickup_position.y+0.5}}
		local tiles = entity.surface.find_tiles_filtered{area=box}
		for i = 1, #tiles do local tile = tiles[i]
			local r = math.random()
			local pfish = fish_entity_names[math.random(1,#get_fish_entity_names())]
			if tile.name == "water" and tile.surface.can_place_entity({name=pfish, amount=1, position={tile.position.x+.5, tile.position.y+.5}}) then
				tile.surface.create_entity({name=pfish, amount=1, position={tile.position.x+.5, tile.position.y+.5}})
			end
			fishing_fish_cache[entity] = 
			{
				fish = entity.surface.find_entities_filtered{area = {{entity.position.x-4, entity.position.y-4}, {entity.position.x+4, entity.position.y+4}}, type = "fish"},
				coundown = 200
			}
			return
		end
	end end

local update_index = 1	
local local_fishing_inserter_tick = function()	
	if fishing.allow_fishing  == true then 		
		local fishing_inserters = fishing.fishing_inserters	
		local numiter = 0
		local updates = math.min(#fishing_inserters,10)

		for index=update_index, #fishing_inserters do local fishing_inserter = fishing_inserters[index]
			if fishing_inserter.valid and fishing_inserter.energy ~= 0 then
				if not fishing_inserter.to_be_deconstructed(fishing_inserter.force) then					
					local_fishing_inserter_process(fishing_inserter)				
				end
			end
			if index >= #fishing_inserters then index = 1 end
			numiter = numiter + 1
			if numiter >= updates then 
				update_index = index
				break
			end
		end 

		if game.tick % 30 then
			for index=1, #fishing_transferers do local fishing_transferer = fishing_transferers[index]
				if fishing_transferer.valid and fishing_transferer.energy ~= 0 then
					if not fishing_transferer.to_be_deconstructed(fishing_transferer.force) then					
						local_fishing_transferer_process(fishing_transferer)				
					end
				end
			end
		end
	end
	end

local local_check_fishing_inserter = function(entity)	
	local box = {{entity.pickup_position.x-0.5, entity.pickup_position.y-0.5}, {entity.pickup_position.x+0.5, entity.pickup_position.y+0.5}}
	local tiles = entity.surface.find_tiles_filtered{area=box}
	for _,tile in pairs(tiles) do
		if starts_with(tile.name, "water") then
			table.insert(fishing_inserters, entity)
			return true
		end
	end
	return false	
end

local local_check_fishing_transferer = function(entity)			
	local tile = entity.surface.get_tile(entity.drop_position.x, entity.drop_position.y)
	if starts_with(tile.name, "water") then
		table.insert(fishing_transferers, entity)
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
		for index, fishing_inserter in ipairs(fishing_inserters) do
			if fishing_inserter.valid and fishing_inserter == entity then
				entity.operable = true
				table.remove(fishing_inserters, index)
				return
			end
		end
		for index, fishing_transferer in ipairs(fishing_transferers) do
			if fishing_transferer.valid and fishing_transferer == entity then
				entity.operable = true
				table.remove(fishing_transferers, index)
				return
			end
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
	if is_valid(entity) and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then			
		if fishing.allow_fishing then		
			local_fishing_inserter_removed(entity)
			local_fishing_inserter_added(entity)
		end
	end end

local local_inserter_adjust = function(entity)
	if is_valid(entity) and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then
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
	if starts_with(event.research.name,allow_fishing) then
		fishing.allow_fishing = true
    end
	end

local local_on_entity_cloned = function(event)
	local entity = event.source
	if is_valid(entity) and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then			
		if fishing.allow_fishing then		
			local_fishing_inserter_removed(entity)
			local_fishing_inserter_added(entity)
		end
	end
end

script.on_init(local_init)
script.on_load(local_load)
script.on_event(defines.events.on_research_finished, local_on_research)
script.on_event(defines.events.on_robot_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_fishing_inserter_removed(event.entity) end 
	end)
script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_fishing_inserter_removed(event.entity) end 
	end)

script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_fishing_inserter_added(event.entity,event) end 
	end)
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_fishing_inserter_added(event.created_entity) end 
	end)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_fishing_inserter_added(event.created_entity) end 
	end)
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_fishing_inserter_added(event.entity) end 
	end)


if settings.startup["setting-fishing-inserters"].value == "Enabled" then
	script.on_nth_tick(9, local_fishing_inserter_tick)

	local inserter_setting = settings.startup["setting-adjust-inserter-pickup"]
    if inserter_setting and inserter_setting.value == "Enabled" then
        script.on_event("adjust-inserter-pickup",local_inserter_adjust) -- only aplicable if there is the event defined in logistics
    end

	script.on_event(defines.events.on_player_rotated_entity,function(event) 
		if is_valid(event.entity) then local_on_player_rotated_entity(event.entity) end 
	end)
	script.on_event(defines.events.on_entity_cloned,
	function(event) 
		if is_valid(event.source) then local_on_entity_cloned(event) end 
	end)
end