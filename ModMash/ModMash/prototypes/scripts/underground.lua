log("underground-access.lua")
--[[check and import utils]]
--if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end

local low_priority = modmash.events.low_priority
local teleport_cooldown = 0
local last_pos = nil

--[[defines]]
local underground_accumulator  = modmash.defines.names.underground_accumulator
local underground_access  = modmash.defines.names.underground_access
local underground_access2  = modmash.defines.names.underground_access2
local force_neutral = modmash.defines.names.force_neutral
local force_enemy = modmash.defines.names.force_enemy

local spawn_radius = 10

--[[create local references]]
--[[util]]
local is_valid = modmash.util.is_valid
local starts_with = modmash.util.starts_with
local table_contains = modmash.util.table.contains
local is_valid_and_persistant = modmash.util.entity.is_valid_and_persistant
local distance = modmash.util.distance

local rock_names = {
  "mm_rock-huge",
  "mm_rock-big",
  "mm_sand-rock-big"
}

local rock_names2 = {
  "mm_dark-rock-huge",
  "mm_dark-rock-big",
  "mm_dark-sand-rock-big"
}

local enemy_spawns = {
  "biter-spawner",
  "spitter-spawner"
}


--[[unitialized globals]]
local accumulators = nil
local accesses = nil
local accesses2 = nil
local underground_origins = nil
--[[ensure globals]]
local local_init = function() 
	log("underground.local_init")
	if global.modmash.underground_accumulators == nil then global.modmash.underground_accumulators = {} end
	if global.modmash.underground_accesses == nil then global.modmash.underground_accesses = {} end
	if global.modmash.underground_accesses2 == nil then global.modmash.underground_accesses2 = {} end
	if global.modmash.underground_origins == nil then global.modmash.underground_origins = {} end
	accumulators = global.modmash.underground_accumulators
	accesses = global.modmash.underground_accesses
	accesses2 = global.modmash.underground_accesses2
	underground_origins = global.modmash.underground_origins 
	end

local local_load = function() 
	log("underground.local_load")
	accumulators = global.modmash.underground_accumulators
	accesses = global.modmash.underground_accesses
	accesses2 = global.modmash.underground_accesses2
	underground_origins = global.modmash.underground_origins 
	end

local get_circle_lines = function( centerX, centerY, radius)
	local points = {}
	local radStep = 1/(1.5*radius)
	for angle = 1, math.pi+radStep, radStep do
	local pX = math.cos( angle ) * radius * 1.5
	local pY = math.sin( angle ) * radius
	for i=-1,1,2 do
		for j=-1,1,2 do
			local y = math.floor((centerY + j*pY)+0.5)
			local x = math.floor((centerX + i*pX)+0.5)
			if points[y] == nil then
			points[y]={x,x}
			else
			local s = math.min(x,points[y][1],points[y][2])
			local e = math.max(x,points[y][1],points[y][2])
			points[y]={s,e}
			end
		end
		end
	end
	return points
	end

local get_sorted_lines = function(circle)
	local tkeys = {}
	local ret = {}
	for k in pairs(circle) do table.insert(tkeys, k) end
		table.sort(tkeys)
		local min = nil
		local max = nil
		for _, k in ipairs(tkeys) do 
			ret[k]=circle[k] 
			if min == nil then
				min = math.min(circle[k][1],circle[k][2])
				max = math.max(circle[k][1],circle[k][2])
			else
				min = math.min(min,circle[k][1])
				max = math.min(max,circle[k][2])
			end
		end
		return {ret,tkeys[1],tkeys[#tkeys],min,max}
	end

local resources = nil
local local_build_resources = function()
	if resources == nil then
		resources = {}
		for k, v in pairs(game.entity_prototypes) do 
			if v.type == "resource" and starts_with(v.name,"creative") == false then
				if v.mineable_properties ~= nil and v.mineable_properties.minable == true and v.mineable_properties.mining_particle ~= nil then
					local pass = 0
					for _, product in pairs(v.mineable_properties.products) do
						if product.type == "fluid" then pass = 2 end
						if product.type == "item" and pass ~= 2 then
							pass = 1
						end
					end
					--log("resource "..k.. " "..pass)
					if pass == 1 then
						if v.map_color ~= nil then
							log("Resource identified "..k)
							table.insert(resources,k)
						end
					end
				end
			end					
		end
	end 
	end
		
local local_is_valid_autoplace = function(surface,name,pos)
	if resources == nil then local_build_resources() end
	return table_contains(resources,name)
	end

local generate_surface_area = function(x,y,r,surface, force_gen, force_ore)	
	if force_gen == nil then
	  surface.request_to_generate_chunks({x, y}, r*2)
	  surface.force_generate_chunk_requests()
	end
	local p = get_circle_lines(x,y,r)
	local d = get_sorted_lines(p)
	local rnd = math.random(1, 50)
    local amt = math.random(500, 1200)

	p = d[1]
	for i=d[2],d[3] do
	  local str = ""
	  if p[i] ~= nil then
		local s = p[i][1]
		local e = p[i][2]
		for j =s,e do
		  local pos = {x = j, y = i }
		  local tile = "dirt-" .. math.random(1, 7)
		  local current_tile = surface.get_tile(pos)		  
		  local m = math.max((1-(distance(x,y,j,i)/r)),0.25)
		  m = ((math.random(40,100)/200)+0.5)*m
		  if j>s and j<e then
			if i == d[2] or i == d[3] then
			  --edge
			  if current_tile.name == "out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				surface.create_entity({ name = rock_names[math.random(#rock_names)], position = pos })
			  end			  			  
			else
			  --inside
			  if current_tile.name == "out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				local create = nil
				if force_ore ~= nil then
					create = {name=force_ore, amount=amt*m, position=pos}
				elseif rnd<6 and x == j and y == i then	
					create = { name = enemy_spawns[math.random(#enemy_spawns)], position = pos }					
				elseif rnd<12 then
					create = {name="uranium-ore", amount=amt*m, position=pos}
				elseif rnd<17 then
					create = {name="iron-ore", amount=amt*m, position=pos}
				elseif rnd<23 then
					create = {name="copper-ore", amount=amt*m, position=pos}
				elseif rnd<27 then
					create = {name="coal", amount=amt*m, position=pos}
				elseif rnd<30 then
					create = {name="alien-ore", amount=amt*m, position=pos}
				end
				if create ~= nil and local_is_valid_autoplace(surface,create.name,create.position) then surface.create_entity(create) end
			  end
			end
		  elseif j==s or j == e then
		    --edge
			  if current_tile.name == "out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				surface.create_entity({ name = rock_names[math.random(#rock_names)], position = pos })
			  end	
		  else 
			--nothing
		  end
		end
	  end
	end
	end


local generate_surface_area2 = function(x,y,r,surface, force_gen, force_ore)	
	if force_gen == nil then
	  surface.request_to_generate_chunks({x, y}, r*2)
	  surface.force_generate_chunk_requests()
	end
	local p = get_circle_lines(x,y,r)
	local d = get_sorted_lines(p)
	
    local amt = math.random(800, 3200)
	if resources == nil then
		local_build_resources()
	end
	local rnd = math.random(1, #resources+8)

	p = d[1]
	for i=d[2],d[3] do
	  local str = ""
	  if p[i] ~= nil then
		local s = p[i][1]
		local e = p[i][2]
		for j =s,e do
		  local pos = {x = j, y = i }
		  local tile = "mm_dark-dirt-" .. math.random(1, 7)
		  local current_tile = surface.get_tile(pos)		  
		  local m = math.max((1-(distance(x,y,j,i)/r)),0.25)
		  m = ((math.random(40,100)/200)+0.5)*m
		  if j>s and j<e then
			if i == d[2] or i == d[3] then
			  --edge
			  if current_tile.name == "out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				surface.create_entity({ name = rock_names2[math.random(#rock_names2)], position = pos })
			  end			  			  
			else
			  --inside
			  if current_tile.name == "out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				local create = nil
				if force_ore ~= nil then
					create = {name=force_ore, amount=amt*m, position=pos}
				elseif rnd <= #resources then
					create = {name=resources[rnd], amount=amt*m, position=pos}
				elseif rnd<(#resources+5) and x == j and y == i then	
					create = { name = enemy_spawns[math.random(#enemy_spawns)], position = pos }					
				end
				if create ~= nil and local_is_valid_autoplace(surface,create.name,create.position) then surface.create_entity(create) end
			  end
			end
		  elseif j==s or j == e then
		    --edge
			  if current_tile.name == "out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				surface.create_entity({ name = rock_names2[math.random(#rock_names2)], position = pos })
			  end	
		  else 
			--nothing
		  end
		end
	  end
	end
	end

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version <= "0.18.19" or global.modmash.underground_accumulators == nil then		
		local_init()
	end
	if f.mod_changes["modmash"].old_version <= "0.18.24"then		
		local surface = game.surfaces["underground"]
		if surface then
			surface.daytime = 0.3
			for c in surface.get_chunks() do
				local pos = {x = c.area.left_top.x+16, y = c.area.left_top.y+16 }
				local current_tile = surface.get_tile(pos)
				if current_tile.name == "out-of-map" then 
					local rnd = math.random(1,10)
					if rnd <= 3 then
						generate_surface_area(pos.x,pos.y,math.random(5,8),surface, false,"alien-ore")
					end
				end
			end			
		end
	end	
	if global.modmash.underground_accesses2 == nil then global.modmash.underground_accesses2 = {} end
	accesses2 = global.modmash.underground_accesses2
	end

local local_chunk_generated = function(event)
  
  local area = event.area
  local surface = event.surface   
  if surface.name == "underground" or surface.name == "underground2"  then
	  for py = 0, 31, 1 do 
		for px = 0, 31, 1 do 
		  local tile = "out-of-map"
		  y = py + area.left_top.y
		  x = px + area.left_top.x
		  local pos = { x = x, y = y }
		  surface.set_tiles({{ name = tile, position = pos }})	  
		end
	  end  
	  local rnd = math.random(1,7)
	  if rnd <= 3 then
		if surface.name == "underground" then
			generate_surface_area(area.left_top.x+16,area.left_top.y+16,math.random(5,8),surface, false)
		else
			generate_surface_area2(area.left_top.x+16,area.left_top.y+16,math.random(5,8),surface, false)
		end
	  end
  end
  end

local init_surface = function(surface,parent)
	surface.map_gen_settings = {
		autoplace_controls = {--[[
			["enemy-base"] = { frequency = "none" },
			["iron-ore"] = { richness = "none"},
			["copper-ore"] = { richness = "none"},
			["stone"] = { richness = "none"},
			["coal"] = { richness = "none"},
			["uranium-ore"] = { richness = "none"},
			["crude-oil"] = { richness = "none"},
			--["alien-ore"] = { richness = "none"}]]
		},
		default_enable_all_autoplace_controls = false,
		autoplace_settings = {
			entity = { frequency = "none" },
			tile = { frequency = "none" },
			decorative = { frequency = "none" }
		},
		water = "none",
		peaceful_mode = false,
		starting_area = "none",
		terrain_segmentation = "none",
		width = parent.map_gen_settings.width,
		height = parent.map_gen_settings.height,
		starting_points = {},
		research_queue_from_the_start = parent.map_gen_settings.research_queue_from_the_start,
		property_expression_names = {
			cliffiness = 0,
			["tile:water:probability"] = -1000,
			["tile:deep-water:probability"] = -1000
		}
	}
	surface.peaceful_mode = parent.map_gen_settings.peaceful_mode	
	surface.daytime = 0.34
	surface.freeze_daytime = true
	return surface
	end

local init_surface2 = function(surface,parent)
	surface.map_gen_settings = {
		autoplace_controls = {
			--[["enemy-base"] = { frequency = "none" },
			["iron-ore"] = { richness = "none"},
			["copper-ore"] = { richness = "none"},
			["stone"] = { richness = "none"},
			["coal"] = { richness = "none"},
			["uranium-ore"] = { richness = "none"},
			["crude-oil"] = { richness = "none"},
			--["alien-ore"] = { richness = "none"}]]
		},
		default_enable_all_autoplace_controls = false,
		autoplace_settings = {
			entity = { frequency = "none", treat_missing_as_default = false },
			tile = { frequency = "none", treat_missing_as_default = false },
			decorative = { frequency = "none", treat_missing_as_default = false }
		},
		water = "none",
		peaceful_mode = false,
		starting_area = "none",
		terrain_segmentation = "none",
		width = parent.map_gen_settings.width,
		height = parent.map_gen_settings.height,
		starting_points = {},
		research_queue_from_the_start = parent.map_gen_settings.research_queue_from_the_start,
		property_expression_names = {
			cliffiness = 0,
			["tile:water:probability"] = -1000,
			["tile:deep-water:probability"] = -1000
		}
	}
	surface.peaceful_mode = parent.map_gen_settings.peaceful_mode
	surface.daytime = 0.42
	surface.freeze_daytime = true
	
	return surface
	end

local local_ensure_underground_environment = function()	
	if game.surfaces["nauvis"] ~= nil then
		if not game.surfaces["underground"] then
			local surface = init_surface(game.create_surface("underground"),game.surfaces["nauvis"])
		end
		if not game.surfaces["underground2"] then
			local surface = init_surface2(game.create_surface("underground2"),game.surfaces["underground"])
		end
	end
	end


local local_ensure_can_place_entity_inner = function(entity,event)
	if entity.name == underground_access or entity.name == underground_access2 or entity.name == underground_accumulator then 		
		if entity.surface.name == "nauvis" then			
			if entity.name == underground_access2 then return false end
			local rocks = game.surfaces["underground"].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
			for index=1, #rocks do local r = rocks[index]
				if is_valid(r) then 
					r.destroy({raise_destroy = true}) 
				end			
			end			
			generate_surface_area(entity.position.x, entity.position.y,5,game.surfaces["underground"])
			return game.surfaces["underground"].can_place_entity{name=entity.name, position=entity.position, direction=entity.direction, force=entity.force}	
		elseif entity.surface.name == "underground" then
			if entity.name == underground_access or entity.name == underground_accumulator then
				if game.surfaces["nauvis"].can_place_entity{name=entity.name, position=entity.position, direction=entity.direction, force=entity.force} then
					return true
				end
			elseif entity.name == underground_access2 then
				local rocks = game.surfaces["underground2"].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names2}			
				for index=1, #rocks do local r = rocks[index]
					if is_valid(r) then 
						r.destroy({raise_destroy = true}) 
					end			
				end		
				generate_surface_area2(entity.position.x, entity.position.y,5,game.surfaces["underground2"])
				return game.surfaces["underground2"].can_place_entity{name=entity.name, position=entity.position, direction=entity.direction, force=entity.force}	
			end
		elseif entity.surface.name == "underground2" then			
			if entity.name == underground_access2 then
				local rocks = game.surfaces["underground"].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
				for index=1, #rocks do local r = rocks[index]
					if is_valid(r) then 
						r.destroy({raise_destroy = true}) 
					end			
				end		
				generate_surface_area(entity.position.x, entity.position.y,5,game.surfaces["underground"])
				return game.surfaces["underground"].can_place_entity{name=entity.name, position=entity.position, direction=entity.direction, force=entity.force}	
			end
		end		
	end
	return true
	end

local local_ensure_can_place_entity = function(entity,event)
	if local_ensure_can_place_entity_inner(entity,event) then	
		if entity.surface.name == "underground" and (entity.type=="solar-panel" or entity.type == "rocket-silo" or (entity.name == "wind-trap" and settings.startup["modmash-allow-air-filter-below"].value == false)) then
			if event.stack ~= nil then
				event.stack.count = event.stack.count + 1
			else
				entity.surface.spill_item_stack(entity.position, {name=entity.name, count=1})
			end
			entity.surface.create_entity{name="flying-text", position = entity.position, text={"modmash.underground-placement-disallowed"} , color={r=1,g=0.25,b=0.5}}
			entity.destroy()
			return false
		end
		if entity.surface.name == "underground2" and (entity.name == underground_accumulator or entity.name == underground_access or entity.type=="solar-panel" or entity.type == "rocket-silo" or (entity.name == "wind-trap" and settings.startup["modmash-allow-air-filter-below"].value == false)) then
			if event.stack ~= nil then
				event.stack.count = event.stack.count + 1
			else
				entity.surface.spill_item_stack(entity.position, {name=entity.name, count=1})
			end
			entity.surface.create_entity{name="flying-text", position = entity.position, text={"modmash.underground-placement-disallowed"} , color={r=1,g=0.25,b=0.5}}
			entity.destroy()
			return false
		end
		if entity.surface.name == "nauvis" and entity.name == underground_access2 then
			if event.stack ~= nil then
				event.stack.count = event.stack.count + 1
			else
				entity.surface.spill_item_stack(entity.position, {name=entity.name, count=1})
			end
			entity.surface.create_entity{name="flying-text", position = entity.position, text={"modmash.underground-placement-disallowed"} , color={r=1,g=0.25,b=0.5}}
			entity.destroy()
			return false
		end
	else
		if event.stack ~= nil then
			event.stack.count = event.stack.count + 1
		else
			entity.surface.spill_item_stack(entity.position, {name=entity.name, count=1})
		end
		entity.surface.create_entity{name="flying-text", position = entity.position, text={"modmash.underground-placement-disallowed"} , color={r=1,g=0.25,b=0.5}}
		entity.destroy()
		return false
	end
	return true
	end


local local_underground_added = function(entity,event)			
		if is_valid(entity) ~= true then return end	
		-- should  have been called by spawn		
		local_ensure_underground_environment()
		if entity.surface.name == "nauvis" or entity.surface.name == "underground" or entity.surface.name == "underground2" then
			if local_ensure_can_place_entity(entity,event) == false then 
				return
			end		
		end
		if entity.name == underground_access then 	
			entity.force = force_neutral
			if entity.surface.name == "nauvis" then
				local u = game.surfaces["underground"].create_entity{name = entity.name, position = entity.position, force = force_neutral}				
				table.insert(accesses,{bottom_entity = u, top_entity = entity})
			elseif entity.surface.name == "underground" then
				local u = game.surfaces["nauvis"].create_entity{name = entity.name, position = entity.position, force = force_neutral}
				table.insert(accesses,{bottom_entity = entity, top_entity = u})
			end
		elseif entity.name == underground_access2 then 	
			entity.force = force_neutral
			if entity.surface.name == "underground" then
				local u = game.surfaces["underground2"].create_entity{name = entity.name, position = entity.position, force = force_neutral}				
				table.insert(accesses2,{bottom_entity = u, top_entity = entity})
			elseif entity.surface.name == "underground2" then
				local u = game.surfaces["underground"].create_entity{name = entity.name, position = entity.position, force = force_neutral}
				table.insert(accesses2,{bottom_entity = entity, top_entity = u})
			end
		elseif entity.name == underground_accumulator then	
			if entity.surface.name == "nauvis" then
				local u = game.surfaces["underground"].create_entity{name = entity.name, position = entity.position, force = entity.force}
				table.insert(accumulators,{bottom_entity = u, top_entity = entity})
			elseif entity.surface.name == "underground" then
				local u = game.surfaces["nauvis"].create_entity{name = entity.name, position = entity.position, force = entity.force}
				table.insert(accumulators,{bottom_entity = entity, top_entity = u})
			end
		end
	end

local local_underground_removed = function(entity)
	if entity.name == underground_access then				
		for index, access in pairs(accesses) do
			if access.top_entity == entity then
				access.bottom_entity.destroy()
				table.remove(accesses, index)				
				return
			elseif access.bottom_entity == entity then
				access.top_entity.destroy()
				table.remove(accesses, index)				
				return
			end
		end
	elseif entity.name == underground_access2 then				
		for index, access in pairs(accesses2) do
			if access.top_entity == entity then
				access.bottom_entity.destroy()
				table.remove(accesses, index)				
				return
			elseif access.bottom_entity == entity then
				access.top_entity.destroy()
				table.remove(accesses, index)				
				return
			end
		end
	elseif entity.name == underground_accumulator then				
		for index, accumulator in pairs(accumulators) do
			if accumulator.top_entity == entity then	
				accumulator.bottom_entity.destroy()
				table.remove(accumulators, index)				
				return
			elseif accumulator.bottom_entity == entity then		
				accumulator.top_entity.destroy()
				table.remove(accumulators, index)				
				return
			end
		end
	elseif entity.surface.name == "underground" then
		if table_contains(rock_names, entity.name) then
			generate_surface_area(entity.position.x, entity.position.y,2,entity.surface)
		end		
	elseif entity.surface.name == "underground2" then
		if table_contains(rock_names2, entity.name) then
			generate_surface_area2(entity.position.x, entity.position.y,2,entity.surface)
		end
	end
	end

local local_accumulators_process = function(accumulator)
	local e = accumulator.bottom_entity.energy + accumulator.top_entity.energy
	e = e / 2
	accumulator.bottom_entity.energy = e
	accumulator.top_entity.energy = e
	end

local local_bitter_follow = function(entity)
	local enemy = entity.surface.find_enemy_units(entity.position, 5)
	for i = 1, #enemy do local e = enemy[i]
		e.set_command({type=defines.command.go_to_location, destination=entity.position, distraction=defines.distraction.none})
	end
end

local local_safe_teleport = function(player, surface, position)
	if player and player.character then
		position = surface.find_non_colliding_position(
			player.character.name, player.character.position, 5, 0.5, false
		) or position
	end
	player.teleport(position, surface)
end

local flip = true
local local_access_process = function(access)
	teleport_cooldown = teleport_cooldown -1
	if teleport_cooldown > 0 then return end
	for i = 1, #game.players do local p = game.players[i]
		if is_valid(p.character) and p.character.surface.name == "nauvis" and last_pos ~= p.character.position then
			if distance(p.character.position.x,p.character.position.y,access.top_entity.position.x,access.top_entity.position.y) < 1.5 then				
				local_safe_teleport(p, game.surfaces["underground"],p.character.position)
				teleport_cooldown = 60*3
				last_pos = p.character.position
				local_bitter_follow(access.top_entity)
			end
		elseif is_valid(p.character) and p.character.surface.name == "underground" and last_pos ~= p.character.position then
			if distance(p.character.position.x,p.character.position.y,access.bottom_entity.position.x,access.bottom_entity.position.y) < 1.5 then				
				local_safe_teleport(p, game.surfaces["nauvis"],p.character.position)
				teleport_cooldown = 60*3
				last_pos = p.character.position
				local_bitter_follow(access.bottom_entity)
			end
		end
	end			
	local inventory = {}
	if flip then
		flip = false
		local top = access.top_entity.get_inventory(defines.inventory.chest)
		local bottom = access.bottom_entity.get_inventory(defines.inventory.chest)
		if top ~= nil and bottom ~= nil then
			for n, c  in pairs (top.get_contents()) do
				if n~=nil then				
					local ic = bottom.get_item_count(n)
					if (ic == nil or ic < c) and bottom.can_insert({name=n,count=1}) then
						bottom.insert({name=n,count=1})
						top.remove({name=n,count=1})
					end
				end
			end		
			for n, c  in pairs (bottom.get_contents()) do
				if n ~= nil then
				local ic = top.get_item_count(n)
					if (ic == nil or ic < c) and top.can_insert({name=n,count=1}) then
					top.insert({name=n,count=1})
					bottom.remove({name=n,count=1})
				end
				end
			end	
		end
	else
		flip = true
		local bottom = access.top_entity.get_inventory(defines.inventory.chest)
		local top = access.bottom_entity.get_inventory(defines.inventory.chest)
		if top ~= nil and bottom ~= nil then
			for n, c  in pairs (top.get_contents()) do
				if n~=nil then				
					local ic = bottom.get_item_count(n)
					if (ic == nil or ic < c) and bottom.can_insert({name=n,count=1}) then
						bottom.insert({name=n,count=1})
						top.remove({name=n,count=1})
					end
				end
			end		
			for n, c  in pairs (bottom.get_contents()) do
				if n ~= nil then
				local ic = top.get_item_count(n)
					if (ic == nil or ic < c) and top.can_insert({name=n,count=1}) then
					top.insert({name=n,count=1})
					bottom.remove({name=n,count=1})
				end
				end
			end	
		end
	end

	if game.tick%60==0 then
		local moved = {}
		local enemy = game.surfaces["underground"].find_enemy_units(access.bottom_entity.position,2.5)
		for i = 1, #enemy do local e = enemy[i]
			if game.surfaces["nauvis"].can_place_entity{name=e.name, position=e.position, direction=e.direction, force=e.force} then
				local ne = game.surfaces["nauvis"].create_entity{name=e.name, position=e.position, direction=e.direction, force=e.force}
				ne.health = e.health
				table.insert(moved,ne)
				e.destroy()
			end
		end

		enemy = game.surfaces["nauvis"].find_enemy_units(access.bottom_entity.position,2.5)
		for i = 1, #enemy do local e = enemy[i]
			if table_contains(moved,e) == false and game.surfaces["underground"].can_place_entity{name=e.name, position=e.position, direction=e.direction, force=e.force} then
				local ne = game.surfaces["underground"].create_entity{name=e.name, position=e.position, direction=e.direction, force=e.force}
				ne.health = e.health
				e.destroy()
			end
		end
	end		
	end

local flip2 = true
local local_access_process2 = function(access)
	teleport_cooldown = teleport_cooldown -1
	if teleport_cooldown > 0 then return end
	for i = 1, #game.players do local p = game.players[i]
		if is_valid(p.character) and p.character.surface.name == "underground" and last_pos ~= p.character.position then
			if distance(p.character.position.x,p.character.position.y,access.top_entity.position.x,access.top_entity.position.y) < 1.5 then				
				local_safe_teleport(p, game.surfaces["underground2"],p.character.position)
				teleport_cooldown = 60*3
				last_pos = p.character.position
				local_bitter_follow(access.top_entity)
			end
		elseif is_valid(p.character) and p.character.surface.name == "underground2" and last_pos ~= p.character.position then
			if distance(p.character.position.x,p.character.position.y,access.bottom_entity.position.x,access.bottom_entity.position.y) < 1.5 then				
				local_safe_teleport(p, game.surfaces["underground"],p.character.position)
				teleport_cooldown = 60*3
				last_pos = p.character.position
				local_bitter_follow(access.bottom_entity)
			end
		end
	end			
	local inventory = {}
	if flip then
		flip = false
		local top = access.top_entity.get_inventory(defines.inventory.chest)
		local bottom = access.bottom_entity.get_inventory(defines.inventory.chest)
		if top ~= nil and bottom ~= nil then
			for n, c  in pairs (top.get_contents()) do
				if n~=nil then				
					local ic = bottom.get_item_count(n)
					if (ic == nil or ic < c) and bottom.can_insert({name=n,count=1}) then
						bottom.insert({name=n,count=1})
						top.remove({name=n,count=1})
					end
				end
			end		
			for n, c  in pairs (bottom.get_contents()) do
				if n ~= nil then
				local ic = top.get_item_count(n)
					if (ic == nil or ic < c) and top.can_insert({name=n,count=1}) then
					top.insert({name=n,count=1})
					bottom.remove({name=n,count=1})
				end
				end
			end	
		end
	else
		flip = true
		local bottom = access.top_entity.get_inventory(defines.inventory.chest)
		local top = access.bottom_entity.get_inventory(defines.inventory.chest)
		if top ~= nil and bottom ~= nil then
			for n, c  in pairs (top.get_contents()) do
				if n~=nil then				
					local ic = bottom.get_item_count(n)
					if (ic == nil or ic < c) and bottom.can_insert({name=n,count=1}) then
						bottom.insert({name=n,count=1})
						top.remove({name=n,count=1})
					end
				end
			end		
			for n, c  in pairs (bottom.get_contents()) do
				if n ~= nil then
				local ic = top.get_item_count(n)
					if (ic == nil or ic < c) and top.can_insert({name=n,count=1}) then
					top.insert({name=n,count=1})
					bottom.remove({name=n,count=1})
				end
				end
			end	
		end
	end

	if game.tick%60==0 then
		local moved = {}
		local enemy = game.surfaces["underground2"].find_enemy_units(access.bottom_entity.position,2.5)
		for i = 1, #enemy do local e = enemy[i]
			if game.surfaces["underground"].can_place_entity{name=e.name, position=e.position, direction=e.direction, force=e.force} then
				local ne = game.surfaces["underground"].create_entity{name=e.name, position=e.position, direction=e.direction, force=e.force}
				ne.health = e.health
				table.insert(moved,ne)
				e.destroy()
			end
		end

		enemy = game.surfaces["underground"].find_enemy_units(access.bottom_entity.position,2.5)
		for i = 1, #enemy do local e = enemy[i]
			if table_contains(moved,e) == false and game.surfaces["underground2"].can_place_entity{name=e.name, position=e.position, direction=e.direction, force=e.force} then
				local ne = game.surfaces["underground2"].create_entity{name=e.name, position=e.position, direction=e.direction, force=e.force}
				ne.health = e.health
				e.destroy()
			end
		end
	end		
	end

local local_underground_tick = function()		
	if game.tick%30==0 then
		for index=1, #accumulators do local accumulator = accumulators[index]
			if is_valid_and_persistant(accumulator.bottom_entity) and is_valid_and_persistant(accumulator.top_entity)  then
				local_accumulators_process(accumulator)
			end
		end
	end
	for index=1, #accesses do local access = accesses[index]
		if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity)  then
			local_access_process(access)
		end
	end
	for index=1, #accesses2 do local access = accesses2[index]
		if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity)  then
			local_access_process2(access)
		end
	end
end

local local_on_player_spawned = function(event)

	local player = game.get_player(event.player_index)
	if player == nil or player.character == nil then return end
	if table_contains(underground_origins,player.force) then return end
	
	local_ensure_underground_environment()
	if game.surfaces["underground"] ~= nil then
		table.insert(underground_origins,player.force)
		local pos = player.force.get_spawn_position(game.surfaces["underground"])
	
		local rocks = game.surfaces["underground"].find_entities_filtered{area = {{pos.x-2.5, pos.y-2.5}, {pos.x+2.5, pos.y+2.5}}, name = rock_names}			
		for index=1, #rocks do local r = rocks[index]				
			if is_valid(r) then 
				r.destroy({raise_destroy = true}) 
			end			
		end			
		generate_surface_area(pos.x, pos.y,6,game.surfaces["underground"])	
	end
	if game.surfaces["underground2"] ~= nil then
		table.insert(underground_origins,player.force)
		local pos = player.force.get_spawn_position(game.surfaces["underground2"])
	
		local rocks = game.surfaces["underground2"].find_entities_filtered{area = {{pos.x-2.5, pos.y-2.5}, {pos.x+2.5, pos.y+2.5}}, name = rock_names}			
		for index=1, #rocks do local r = rocks[index]				
			if is_valid(r) then 
				r.destroy({raise_destroy = true}) 
			end			
		end			
		generate_surface_area2(pos.x, pos.y,6,game.surfaces["underground2"])	
	end
	end	


local control = {
	on_tick = local_underground_tick,
	on_init = local_init,
	on_load = local_load,
	on_start = local_start,
	on_added = local_underground_added,
	on_removed = local_underground_removed,
	on_configuration_changed = local_on_configuration_changed,
	on_chunk_generated = local_chunk_generated,
	on_player_spawned = local_on_player_spawned	
}

if modmash.profiler == true then
	local profiler = modmash.util.get_profiler("underground")
	control.on_tick = function() 
		profiler.update(local_underground_tick) 
	end
end
modmash.register_script(control)