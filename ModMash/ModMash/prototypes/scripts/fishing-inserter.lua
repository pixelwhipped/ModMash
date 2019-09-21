if not util then require("prototypes.scripts.util") end

local init = function()	
	if global.modmash.fishing_inserters == nil then global.modmash.fishing_inserters = {} end	
	return nil end

local local_try_pickup_fish_at_position = function(inserter,entity)	
	if #inserter.held_stack == 0 and util.distance(inserter.position.x,inserter.position.y,entity.position.x,entity.position.y) <= 2 then
		inserter.pickup_position = {
			x = entity.position.x,
			y = entity.position.y
		}
		inserter.direction = inserter.direction
		if util.distance(inserter.held_stack_position.x,inserter.held_stack_position.y,entity.position.x,entity.position.y) <= 0.2 then
			entity.destroy()
			inserter.held_stack.set_stack({name="raw-fish", count=1})
		end
	end end

local local_fishing_inserter_process = function(entity)    	
	local fish = util.get_entities_around(entity,8)
	local fish_count = 0
	local spawner = nil
	local target = nil
	local current_dist = 0
	local target_dist = 100
	if fish ~= nil then
		for i, ent in pairs(fish) do					
			if ent.prototype.name == "fish" then	
				fish_count = fish_count + 1	
				local dist = util.distance(entity.held_stack_position.x,entity.held_stack_position.y,ent.position.x,ent.position.y)
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
	if spawner ~= nil and fish_count < 10 then
		local r = math.random()
		if r < 0.05 then
			entity.surface.create_entity({name="fish", amount=1, position=spawner.position})
		end
	elseif fish_count == 0 then
		local box = {{entity.pickup_position.x-0.5, entity.pickup_position.y-0.5}, {entity.pickup_position.x+0.5, entity.pickup_position.y+0.5}}
		local tiles = entity.surface.find_tiles_filtered{area=box}
		for _,tile in pairs(tiles) do
			if tile.name == "water" then 
				entity.surface.create_entity({name="fish", amount=1, position=tile.position})
			end
		end
	end end

local local_fishing_inserter_tick = function()
	if init ~= nil then init = init() end	
	if game.tick % 30 == 0 then
		local fishing_inserters = global.modmash.fishing_inserters	
		for index=1, #fishing_inserters do local fishing_inserter = fishing_inserters[index]
			if fishing_inserter.valid and fishing_inserter.energy ~= 0 then
				if not fishing_inserter.to_be_deconstructed(fishing_inserter.force) then					
				    local_fishing_inserter_process(fishing_inserter)				
				end
			end
		end
	end end

local local_fishing_inserter_added = function(entity)
	if entity.type == "inserter" then
		local box = {{entity.pickup_position.x-0.5, entity.pickup_position.y-0.5}, {entity.pickup_position.x+0.5, entity.pickup_position.y+0.5}}
		local tiles = entity.surface.find_tiles_filtered{area=box}
		local water = false
		for _,tile in pairs(tiles) do
			if tile.name == "water" then water = true end
		end
		if water == false then return end
		entity.operable = false
		table.insert(global.modmash.fishing_inserters, entity)
	end
end

local local_fishing_inserter_removed = function(entity)
	if entity.type == "inserter" then		
		for index, fishing_inserter in ipairs(global.modmash.fishing_inserters) do
			if fishing_inserter.valid and fishing_inserter == entity then
				entity.operable = true
				table.remove(global.modmash.fishing_inserters, index)
				return
			end
		end
	end
end

if modmash.ticks ~= nil then			
		table.insert(modmash.ticks,local_fishing_inserter_tick)
		table.insert(modmash.on_added,local_fishing_inserter_added)
		table.insert(modmash.on_remove,local_fishing_inserter_removed)	
end

fishing_inserter_removed = local_fishing_inserter_removed
fishing_inserter_added = local_fishing_inserter_added
