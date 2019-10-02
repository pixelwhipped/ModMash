if not modmash or not modmash.util then require("prototypes.scripts.util") end

local distance  = modmash.util.distance
local get_entities_around  = modmash.util.get_entities_around
local is_valid  = modmash.util.is_valid
local table_index_of  = modmash.util.table.index_of
local starts_with  = modmash.util.starts_with

local local_loot_boxes = nil
local debug_droid = false

local droid_stack_size = 10
local droid_scan_radius = 32
local droids_per_tick = 10

local collection_mode = 0
local scout_mode = 1
local repair_mode = 2
local attack_mode = 3
local build_mode = 4

local no_command = 0
local wander_command = 1
local goto_command = 2
local attack_command = 3
local repair_command = 4
local build_command = 5
local destroy_command = 6
local get_stock_command = 7
local drop_stock_command = 8

local beam_dist = 8
local beam_time = 6

local local_add_ghost = function(ent)
	if ent ~= nil and ent.valid then
		table.insert(global.modmash.ghosts , ent)
	end
end

local local_remove_ghost = function(ent)
	local ghosts = global.modmash.ghosts 
	for index, e in ipairs(ghosts) do
		if  e == ent then
			table.remove(ghosts, index)			
			return
		end
	end
end

local local_clean_ghosts = function()
	local new_ghosts = {}
	local ghosts = global.modmash.ghosts 
	for index, e in ipairs(ghosts) do
		if  e ~= nil and e.valid then
			table.insert(new_ghosts, e)
		end
	end
	global.modmash.ghosts = new_ghosts
end

local local_get_ghost = function(entity,rad)
	local ghosts = global.modmash.ghosts 
	if rad == nil then
		local_clean_ghosts()
		return ghosts
	end
	local clean = {}
	local entities = {}
	for index, e in ipairs(ghosts) do
		if e == nil or not e.valid then 
			table.insert(clean, index)
		elseif rad == nil then
			table.insert(entities, e)
		elseif distance(entity.position.x,entity.position.y,e.position.x,e.position.y) < rad then
			table.insert(entities, e)
		end
	end 
	if #clean > 0 then
		for k=#clean, 1  do local i = clean[k]
			table.remove(ghosts,i)
		end
		global.modmash.ghosts = ghosts
	end
	--table.sort (entities, function (k1, k2) return util.distance(entity.position.x,entity.position.y,k2.position.x,k2.position.y) < util.distance(entity.position.x,entity.position.y,k1.position.x,k1.position.y) end)
	return entities
end

local function local_rebuild_ghosts()    
    if not global.modmash.ghosts then global.modmash.ghosts = {} end	
	for _, surface in pairs(game.surfaces) do
		for _, f in pairs(surface.find_entities_filtered{name={"entity-ghost","tile-ghost"}}) do
			local_add_ghost(f)
		end
	end	
end
local local_create_beam = function(droid,target,beam_name,time)
	if droid ~= nil and droid.valid and target~=nil and target.valid then
		droid.surface.create_entity
		{
		  name = beam_name,
		  source = droid,
		  target_position = target.position,
		  position = droid.position,
		  force = droid.force,
		  duration = time
		}
	end
end

local local_set_sticker = function(entity, sticker)
	for _,e in pairs(entity.surface.find_entities_filtered{type="sticker", area=entity.bounding_box}) do 
		e.destroy() 
	end
	entity.surface.create_entity{ name=sticker, position=entity.position, target=entity }
end

local local_refresh_sticker = function(droid)
	if droid.mode == collection_mode then
		local_set_sticker(droid.entity,"droid-collect-sticker")
	elseif droid.mode == scout_mode then
		local_set_sticker(droid.entity,"droid-scout-sticker")
	elseif droid.mode == repair_mode then
		local_set_sticker(droid.entity,"droid-repair-sticker")
	elseif droid.mode == build_mode then
		local_set_sticker(droid.entity,"droid-build-sticker")
	elseif droid.mode == attack_mode then
		local_set_sticker(droid.entity,"droid-attack-sticker")
	end
end

local local_clear_droid_command = function(droid)
	droid.goto_pos = nil
	droid.target = nil
	droid.command = no_command
	local_refresh_sticker(droid)	
end

local local_set_mode = function(droid, mode)	
	global.modmash.droids.last_mode = mode
	droid.mode = mode
	if droid.mode == attack_mode then
		droid.entity.force = "player"
	else
		droid.entity.force = "neutral"
	end
	local_clear_droid_command(droid)
end


local local_droid_select_target= function(droid,name)
	if not droid.entity.valid then return end
	local rad = (droid_scan_radius + global.modmash.droids.research_modifier) 
	local entities = get_entities_around(droid.entity,rad,nil,name)		
	if entities ~= nil then		
		table.sort (entities, function (k1, k2) return distance(droid.entity.position.x,droid.entity.position.y,k2.position.x,k2.position.y) < distance(droid.entity.position.x,droid.entity.position.y,k1.position.x,k1.position.y) end)
		for k=1, #entities do local ent = entities[k];			
			if ent.name == name then	
				if name == "item-on-ground" then
					if droid.stack ~= nil and droid.stack.name ~=nil then
						if droid.stack.name == ent.stack.name then droid.target = ent end
						return
					else
						droid.target = ent
						return
					end				
				else
					droid.target = ent	
					return
				end
			end	
		end
	else
		droid.target = nil
		droid.command = no_command	
	end
end
 
local local_is_player = function(entity)
	for i = 1, #game.players do local p = game.players[i]
		if p == entity then return true end
	end
	return false
end

local local_droid_select_player = function(droid)
	local entities = {}
	for i = 1, #game.players do local p = game.players[i]
		table.insert(entities, p)
	end
	table.sort (entities, function (k1, k2) return distance(droid.entity.position.x,droid.entity.position.y,k2.position.x,k2.position.y) < distance(droid.entity.position.x,droid.entity.position.y,k1.position.x,k1.position.y) end)
	if #entities > 0 then
		droid.target = entities[1]
	end
end

local local_droid_select_dropoff = function(droid)
	droid.goto_pos = nil
	droid.target = nil
	local_droid_select_target(droid,"droid-chest")
	if droid.target == nil then
		local_droid_select_player(droid)
	end
	if is_valid(droid.target) then 
		droid.command = goto_command	
		droid.goto_pos = droid.target.position
		droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})
	else
		droid.goto_pos = nil
		droid.target = nil
		droid.command = no_command
	end
end

local local_droid_select_pickup = function(droid)
	local_droid_select_target(droid,"item-on-ground")
	if is_valid(droid.target) then 
		droid.command = goto_command	
		droid.goto_pos = droid.target.position
		droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})
	else
		local_droid_select_dropoff(droid)
	end
end

local local_dropoff = function(droid) 	
	if is_valid(droid.target) and droid.target.valid then	
		if droid.stack ~= nil and droid.stack.name ~= nil and droid.stack.count > 0 then
			local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
			if droid.target.can_insert(droid.stack) then				
				droid.target.insert(droid.stack)
			else
				droid.entity.surface.spill_item_stack(droid.entity.position, {name=droid.stack.name, count=droid.stack.count})
			end
			droid.stack = nil
		end
	end
	local_clear_droid_command(droid)
end

local local_pickup = function(droid) 
	if is_valid(droid.target) and droid.target.valid and droid.target.name == "item-on-ground" then		
		local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
		droid.stack = {name = droid.target.stack.name, count = droid.stack.count + droid.target.stack.count}
		droid.target.stack.clear()			
	end
	local_clear_droid_command(droid)
end
local local_remove_from_proxy = function(proxy,target,what)
	if proxy ~= nil and proxy.valid then
		if proxy.item_requests ~= nil then
			local new_request = {}
			local sum =0
			for key,val in pairs(proxy.item_requests) do						
				if key == what then
					local n = val-1
					if n ~= 0 then
						new_request[key] = n
						sum = sum +	n
					end
				else
					new_request[key] = val
					sum = sum +	new_request[key]
				end

			end
			if sum == 0 then
				proxy.destroy()
			else
				proxy.item_requests = new_request
				--proxy.surface.create_entity{name="item-request-proxy", target=target, modules=new_request, position=proxy.position, force=proxy.force}
				--proxy.destroy()
			end
		else
			proxy.destroy()
		end
	end
end

local local_select_module_target = function(droid,module)

	local rad = (droid_scan_radius + global.modmash.droids.research_modifier) 

	local proxies = get_entities_around(droid.entity,rad,nil,{"item-request-proxy"})
	for k=1, #proxies do local proxy = proxies[k]
		if proxy.item_requests ~= nil then
			for key,val in pairs(proxy.item_requests) do
				local entities = droid.entity.surface.find_entities({{proxy.position.x-0.1, proxy.position.y-0.1}, {proxy.position.x+0.1, proxy.position.y+0.1}})
				for k=1, #entities do local ent = entities[k]
					local inv = ent.get_module_inventory()
					local x = key
					if module ~= nil then
						x = {name=module,count =1}
					end
					if inv ~= nil and inv.can_insert(x)  then						
						droid.target = ent	
						droid.proxy = proxy
						return key
					end
				end
			end
		end
	end
end
local local_select_deconstruct_target = function(droid)

	local rad = (droid_scan_radius + global.modmash.droids.research_modifier)
	local entities = get_entities_around(droid.entity,rad,nil,name)		
	--table.sort (entities, function (k1, k2) return util.distance(droid.entity.position.x,droid.entity.position.y,k2.position.x,k2.position.y) < util.distance(droid.entity.position.x,droid.entity.position.y,k1.position.x,k1.position.y) end)
	for k=1, #entities do local ent = entities[k]
		if ent.to_be_deconstructed(droid.entity.force) then			
			if droid.stack ~= nil and droid.stack.name ~= nil then
				if ent.name == "item-on-ground" and ent.stack.name == droid.stack.name then
					droid.target = ent
					return
				elseif ent.name == droid.stack.name then
					droid.target = ent
					return
				end
			else
				droid.target = ent
				return
			end
		end
	end
end

local local_is_entity = function(name)
	local e = game.entity_prototypes[name]
	return e ~= nil
end

local local_is_item = function(name)
	local e = game.item_prototypes[name]
	return e ~= nil
end

local local_is_tile = function(name)
	local e = game.tile_prototypes[name]
	return e ~= nil
end

local local_select_ghost = function(droid,name)	
	if is_valid(droid.target) and droid.target.name.ghost_name ~= nil then		
		droid.stack.name = droid.target.ghost_name
	end
	local rad = (droid_scan_radius + global.modmash.droids.research_modifier)
	local entities = local_get_ghost(droid.entity,rad)	
	if #entities == 0  then 		
		local m = local_select_module_target(droid,name)
		if is_valid(droid.target) then
			droid.stack.name = m 
			return m
		end
		return nil
	end
	local ex = {}
	local droids = global.modmash.droids	
	for e=1, #entities do ent = entities[e]
		local add = true
		local aleady_targeted = false
		for k=1, #droids do local d = droids[k];				
			if add ~= false and d.entity.valid and not d.entity.to_be_deconstructed(d.entity.force) and d.target ~= nil then	
				if ent == d.target then 
					aleady_targeted = aleady_targeted or d.entity==droid.entity
					add = aleady_targeted
				end
			end
		end
		if add then		
			table.insert(ex,ent) 
		end
	end
	entities = ex	
	if #entities == 0  then return nil end
	table.sort (entities, function (k1, k2) return distance(droid.entity.position.x,droid.entity.position.y,k2.position.x,k2.position.y) < distance(droid.entity.position.x,droid.entity.position.y,k1.position.x,k1.position.y) end)
	if name == nil then		
		droid.target = entities[1]
		if local_is_tile(droid.target.ghost_name) and droid.target.name == "tile-ghost" then			
			local mp = game.tile_prototypes[droid.target.ghost_name].items_to_place_this				
			if #mp == 1 then
				return mp[1].name		
			end				
		else
			return droid.target.ghost_name
		end
	else
		for k=1, #entities do local ent = entities[k]			
			if local_is_tile(ent.ghost_name) and ent.name == "tile-ghost" then			
				local mp = game.tile_prototypes[ent.ghost_name].items_to_place_this				
				if #mp == 1  and name == mp[1].name then
					droid.target = ent		
					return name
				end				
			elseif ent.ghost_name == name then
				droid.target = ent
				return name
			end
		end
	end	
	return nil
end

local local_extract_inventory = function(entity,type,tble)
	local inventory = entity.get_inventory(type)
	if inventory ~= nil then
		local contents = inventory.get_contents()			
		for name, count in pairs(contents) do
			if name ~= "void-item" then
				table.insert(tble,{name=name, count=count})	
			end
		end
	end
end

local local_get_spill_products = function(entity)
	
	local prods = {}
	if entity.name == "item-on-ground" then
		table.insert(prods,{name=entity.stack.name, count=entity.stack.count})
	elseif entity.name == "deconstructible-tile-proxy" then
		local tile = entity.surface.get_tile(entity.position.x, entity.position.y)
		local current_prototype = tile.prototype
		local products = current_prototype.mineable_properties.products
		for k=1, #products do local prod = products[k]
			if prod.name ~= "void-item" then
				table.insert(prods,{name=prod.name, count=prod.amount})		
			end
		end					
	elseif entity.health ~= nil and entity.health == entity.prototype.max_health then		
		local mineable_properties = entity.prototype.mineable_properties
		for k=1, #mineable_properties.products do local prod = mineable_properties.products[k]
			if prod.name ~= "void-item" then
				table.insert(prods,{name=prod.name, count=prod.amount})			
			end
		end
		local_extract_inventory(entity,defines.inventory.fuel,prods)
		local_extract_inventory(entity,defines.inventory.burnt_result,prods)
		local_extract_inventory(entity,defines.inventory.chest,prods)
		local_extract_inventory(entity,defines.inventory.furnace_source,prods)
		local_extract_inventory(entity,defines.inventory.furnace_result,prods)
		local_extract_inventory(entity,defines.inventory.furnace_modules,prods)
		local_extract_inventory(entity,defines.inventory.roboport_robot,prods)
		local_extract_inventory(entity,defines.inventory.roboport_material,prods)
		local_extract_inventory(entity,defines.inventory.assembling_machine_input,prods)
		local_extract_inventory(entity,defines.inventory.assembling_machine_output,prods)
		--local_extract_inventory(entity,defines.inventory.assembling_machine_modules,prods)
		local_extract_inventory(entity,defines.inventory.lab_modules,prods)
		local_extract_inventory(entity,defines.inventory.mining_drill_modules,prods)
		local_extract_inventory(entity,defines.inventory.rocket_silo_rocket,prods)
		local_extract_inventory(entity,defines.inventory.car_trunk,prods)
		local_extract_inventory(entity,defines.inventory.car_ammo,prods)
		local_extract_inventory(entity,defines.inventory.cargo_wagon,prods)
		local_extract_inventory(entity,defines.inventory.turret_ammo,prods)
		local_extract_inventory(entity,defines.inventory.beacon_modules,prods)
		local_extract_inventory(entity,defines.inventory.artillery_turret_ammo,prods)
		local_extract_inventory(entity,defines.inventory.artillery_wagon_ammo,prods)
		
		local prototype = entity.prototype
		if entity.prototype.name == "inserter" and entity.held_stack ~= nil and entity.held_stack.valid_for_read == true and entity.held_stack.count > 0 then
			table.insert(prods,{name=entity.held_stack.name, count=entity.held_stack.count})	
		end
		if prototype ~= nil and (prototype.type=="transport-belt" or prototype.type=="underground-belt" or prototype.type=="splitter" or prototype.type=="loader") then
			local lines = 2
			if prototype.type=="underground-belt" then lines = 4 end
			if prototype.type=="splitter" then lines = 4 end

			for k = 1, lines do
				local contents = entity.get_transport_line(k).get_contents()		
				if contents ~= nil then
					for name, count in pairs(contents) do
						table.insert(prods,{name=name, count=count})	
					end
				end
			end
		end
	end
	return prods
end

local local_pickup_stock = function(droid)
	if droid.target == nil or droid.stack == nil or droid.stack.name == nil then return end
	local entities = get_entities_around(droid.entity,beam_dist,nil,{"item-on-ground","droid-chest","character"})
	for k=1, #entities do local ent = entities[k]
		if ent.name == "item-on-ground" and ent.stack.name == droid.stack.name then
			local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
			droid.stack = {name = droid.target.stack.name, count = droid.stack.count + droid.target.stack.count}
			droid.target.stack.clear()	
			droid.goto_pos = nil
			droid.target = nil			
			return
		elseif ent.name == "droid-chest" then
			local inv = ent.get_inventory(defines.inventory.chest)
			local r = inv.remove({name=droid.stack.name, count=1})
			if r > 0 then
				local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
				droid.stack = {name = droid.stack.name, count = droid.stack.count + r}
				droid.goto_pos = nil
				droid.target = nil					
				return
			end
		elseif ent.name == "character" then
			local inv = ent.get_inventory(defines.inventory.character_main)
			local r = inv.remove({name=droid.stack.name, count=1})
			if r > 0 then
				local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
				droid.stack = {name = droid.stack.name, count = droid.stack.count + r}
				droid.goto_pos = nil
				droid.target = nil					
				return
			end
		end
	end
end

local local_find_location_for = function(droid)	
	if droid.target == nil then return end
	local rad = (droid_scan_radius + global.modmash.droids.research_modifier)
	local entities = get_entities_around(droid.entity,rad,nil,{"item-on-ground","droid-chest"})
	local name = nil
	if droid.stack ~= nil and droid.stack.name ~= nil 
		then name = droid.stack.name
	else
		name = droid.target.ghost_name
	end
	if #entities > 0 then
		table.sort (entities, function (k1, k2) return distance(droid.entity.position.x,droid.entity.position.y,k2.position.x,k2.position.y) < distance(droid.entity.position.x,droid.entity.position.y,k1.position.x,k1.position.y) end)
		for k=1, #entities do local ent = entities[k]
			if ent.name == "item-on-ground" and ent.stack.name == name then
				droid.stack.name = name
				droid.goto_pos = ent.position
				droid.target = ent
				return
			elseif ent.name == "droid-chest" then
				local prods = {}
				local_extract_inventory(ent,defines.inventory.chest,prods)
				for k=1, #prods do local p = prods[k]
					if p.name == name then
						droid.stack.name = name
						droid.goto_pos = ent.position
						droid.target = ent
						return
					end
				end
			end
		end
	end
	for i = 1, #game.players do local p = game.players[i]	
		local prods = {}
		local_extract_inventory(p,defines.inventory.character_main,prods)
		for k=1, #prods do local i = prods[k]
			if i.name == name then				
				droid.goto_pos = p.position
				droid.target = p
				droid.stack.name = name
				return
			end
		end
	end
end

local local_droid_process_build_no_command = function(droid) 	
	if droid.target == nil then		
		local_select_deconstruct_target(droid)
		if droid.target  ~= nil then
			droid.goto_pos = droid.target.position
			droid.command = destroy_command				
			droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})
			return
		end
	end	
	local name = nil
	if droid.stack ~= nil and droid.stack.name ~=nil then
		name = droid.stack.name
	end

	local require = local_select_ghost(droid,name)
	if is_valid(droid.target) then	
		droid.goto_pos = droid.target.position
		if droid.stack.count == 0 then
			droid.stack.name = require
			local_find_location_for(droid)			
			if droid.goto_pos == nil then
				droid.goto_pos = nil
				droid.target = nil
				droid.command = no_command
			else		
				droid.command = get_stock_command
				droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})				
			end
			return
		end
		droid.command = build_command
		droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})
		return
	end		

	local_droid_select_dropoff(droid)
	if is_valid(droid.target) then
		droid.command = drop_stock_command
		droid.goto_pos = droid.target.position
		droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})
		return
	end
	local_clear_droid_command(droid)	

	if droid.target == nil then
		local_select_ghost(droid)				
		if is_valid(droid.target) then		
			if droid.target.name == "tile-ghost" then
				
				local mp = game.tile_prototypes[droid.target.ghost_name].items_to_place_this
				if #mp== 1 then
					droid.stack.name = mp[1].name
				end
			else
				droid.stack.name = droid.target.ghost_name
			end				
			droid.goto_pos = nil
			local_find_location_for(droid)
			if droid.goto_pos == nil then
				droid.goto_pos = nil
				droid.target = nil
				droid.command = no_command
			else
				droid.command = get_stock_command
				droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})
			end
		elseif droid.stack ~= nil and droid.stack.name ~= nil then
			local_droid_select_dropoff(droid)
			if is_valid(droid.target) then
				droid.command = drop_stock_command
				droid.goto_pos = droid.target.position
				droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})					
				return
			end		
		elseif droid.stack.count == 0 and droid.target == nil then				
			local m = local_select_module_target(droid)			
			if m~= nil and droid.target  ~= nil then		
				droid.stack.name = m
				droid.goto_pos = nil
				local_find_location_for(droid)
			
				if droid.goto_pos == nil then
					droid.goto_pos = nil
					droid.target = nil
					droid.command = no_command
				else		
					droid.command = get_stock_command
					droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})
					return
				end
			end
		else
			local_clear_droid_command(droid)			
		end
	end	
end

local local_droid_process_build_get_stock_command = function(droid)
	if (distance(droid.goto_pos.x,droid.goto_pos.y,droid.entity.position.x,droid.entity.position.y)<beam_dist) then
		local_pickup_stock(droid)
		local_clear_droid_command(droid)
	end
end

local local_droid_process_build_drop_stock_command = function(droid)
	if droid.stack.count == 0 then
		local_clear_droid_command(droid)
	elseif (distance(droid.goto_pos.x,droid.goto_pos.y,droid.entity.position.x,droid.entity.position.y)<beam_dist) then			
		local_dropoff(droid)
		local_clear_droid_command(droid)
	end
end



local local_droid_process_build_build_command = function(droid)
	if not (is_valid(droid.target) and droid.target.valid) then
		local_clear_droid_command(droid)
	elseif (distance(droid.goto_pos.x,droid.goto_pos.y,droid.entity.position.x,droid.entity.position.y)<beam_dist) then
		if local_is_entity(droid.stack.name) and droid.entity.surface.can_place_entity{name=droid.stack.name, position=droid.target.position, direction=droid.target.direction, force=droid.target.force} then
			droid.target.revive()		
			local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
			if droid.stack.name ~= nil and droid.stack.count > 1 then
				droid.stack.count = droid.stack.count - 1
			else
				droid.stack = nil
			end
			local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
		elseif droid.target.name == "tile-ghost" then
			droid.entity.surface.set_tiles({{name = droid.target.ghost_name, position = droid.target.position}}, true)
			if droid.stack.name ~= nil and droid.stack.count > 1 then
				droid.stack.count = droid.stack.count - 1
			else
				droid.stack = nil
			end
			local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
		else			
		    local m = droid.target.get_module_inventory()
			if m~= nil and m.can_insert({name = droid.stack.name, count = 1}) then
				local i = m.insert({name = droid.stack.name, count = 1})
				if i > 0 then 
					local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
					local_remove_from_proxy(droid.proxy,droid.target,droid.stack.name)
					if droid.stack.name ~= nil and droid.stack.count > 1 then
						droid.stack.count = droid.stack.count - 1						
					else
						droid.stack = nil
					end
				end
				
			end
		end
		local_clear_droid_command(droid)
	end
end

local local_droid_process_build_destroy_command = function(droid)
	if is_valid(droid.target) and droid.target.valid and droid.target.to_be_deconstructed(droid.entity.force) then
		if distance(droid.goto_pos.x,droid.goto_pos.y,droid.entity.position.x,droid.entity.position.y)<beam_dist then							
			if droid.target.name == "item-on-ground" then		
				local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
				droid.stack = {name = droid.target.stack.name, count = droid.stack.count + droid.target.stack.count}
				droid.target.stack.clear()	
				local_clear_droid_command(droid)
			elseif droid.target.health ~= nil then							
				if droid.target.prototype.max_health == droid.target.health then
					local spill = local_get_spill_products(droid.target)
					for k=1, #spill do local s = spill[k]							
						droid.entity.surface.spill_item_stack(droid.target.position, {name=s.name, count=s.count},false,droid.entity.force)							
					end
					local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
					droid.target.destroy()
					local_clear_droid_command(droid)	
					
				else
					local need = math.min(droid.target.prototype.max_health - droid.target.health,1)
					droid.target.health = droid.target.health + need
					local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
				end
			elseif droid.target.minable ~= nil and droid.target.minable then
				local spill = local_get_spill_products(droid.target)
				for k=1, #spill do local s = spill[k]
					droid.entity.surface.spill_item_stack(droid.target.position, {name=s.name, count=s.count},false,droid.entity.force)							
				end
				local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
				if droid.target.name == "deconstructible-tile-proxy" then
					local tile = droid.target.surface.get_tile(droid.target.position.x, droid.target.position.y)
					local hidden = tile.hidden_tile or "out-of-map"
					droid.target.surface.set_tiles({{name = hidden, position = tile.position}}, true)
				end
				droid.target.destroy()
				local_clear_droid_command(droid)					
			end
		end	
	else
		local_clear_droid_command(droid)
	end
end

local local_droid_process_build = function(droid) 
	local rad = (droid_scan_radius + global.modmash.droids.research_modifier)
	if droid.stack == nil then droid.stack = {name = nil, count = 0} end	
	if droid.command == no_command then				
		local_droid_process_build_no_command(droid)
	elseif droid.command == get_stock_command then		
		local_droid_process_build_get_stock_command(droid)
	elseif droid.command == drop_stock_command then
		local_droid_process_build_drop_stock_command(droid)
	elseif droid.command == build_command then
		local_droid_process_build_build_command(droid)
	elseif droid.command == destroy_command then
		local_droid_process_build_destroy_command(droid)
	else
		local_clear_droid_command(droid)
	end
end

local local_droid_process_collection = function(droid) 
	local rad = (droid_scan_radius + global.modmash.droids.research_modifier)

	if droid.command == no_command then		
		if droid.stack.count < droid_stack_size then
			local_droid_select_pickup(droid)
		else
			local_droid_select_dropoff(droid)
		end
	elseif droid.goto_pos ~= nil and is_valid(droid.target) and droid.target.valid then		
		if (distance(droid.goto_pos.x,droid.goto_pos.y,droid.entity.position.x,droid.entity.position.y)<beam_dist) then
			if droid.target.name == "droid-chest" or local_is_player(droid.target) then				
				local_dropoff(droid)
			else
				local_pickup(droid)
			end
			local_clear_droid_command(droid)
		end
	else
		local_clear_droid_command(droid)
	end
end

local local_droid_process_attack = function(droid) 
	local local_droid_select_enemy = function(droid)
		if not droid.entity.valid then return end
		local rad = droid_scan_radius + global.modmash.droids.research_modifier
		local enemy = droid.entity.surface.find_nearest_enemy({position = droid.entity.position, max_distance = rad, force = "enemy"})
		if enemy ~= nil then droid.target = enemy end
	end
	local rad = droid_scan_radius + global.modmash.droids.research_modifier
	if droid.command == no_command then
		local_droid_select_enemy(droid)
		if is_valid(droid.target) then	
			droid.command = attack_command
			droid.goto_pos = droid.target.position
			droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})	
			local_set_sticker(droid.entity,"droid-attack-sticker")
		end
		local_set_sticker(droid.entity,"droid-attack-sticker")	
	elseif droid.command == attack_command and (droid.target == nil or droid.target.valid) then
		droid.target = nil
		droid.goto_pos = nil
		droid.command = no_command
		local_set_sticker(droid.entity,"droid-attack-sticker")
	else
		droid.target = nil
		droid.command = no_command
		droid.goto_pos = nil
		local_set_sticker(droid.entity,"droid-attack-sticker")
	end
end

local local_droid_process_scout = function(droid)
	local rad = droid_scan_radius + global.modmash.droids.research_modifier		
	for i = 1, #game.players do local p = game.players[i]
			p.force.chart(p.surface, {{droid.entity.position.x-rad, droid.entity.position.y-rad}, {droid.entity.position.x+rad, droid.entity.position.y+rad}})
			local chests = p.surface.find_entities_filtered	{area = {{droid.entity.position.x-rad, droid.entity.position.y-rad}, {droid.entity.position.x+rad, droid.entity.position.y+rad}},name={"crash-site-chest-1","crash-site-chest-2","loot_science_a"}}
			for k=1, #chests do local v = chests[k] 
				local id = v.position.x.."_"..v.position.y
				if table_index_of(local_loot_boxes,id) == nil then
					table.insert(local_loot_boxes,id)
					game.players[1].add_custom_alert(v, {type = "item", name = "good-alert"}, "Droid found some Loot", true)
				end
			end
		end
	if droid.command == no_command then
		local_clear_droid_command(droid)
		droid.command = wander_command
		droid.goto_pos = droid.entity.position
		droid.entity.set_command({type = defines.command.wander ,radius = rad})					
	elseif droid.goto_pos ~= nil and (distance(droid.goto_pos.x,droid.goto_pos.y,droid.entity.position.x,droid.entity.position.y)>(rad/2)) then
		local_clear_droid_command(droid)
	else
		local_clear_droid_command(droid)
	end
end

local local_droid_process_repair = function(droid) 
	local local_droid_select_repair = function(droid)
		if not droid.entity.valid then return end
		if is_valid(droid.target) and droid.target.valid and droid.target.health ~= nil and not(droid.target.health < droid.target.prototype.max_health) then return end	
		local rad = (droid_scan_radius + global.modmash.droids.research_modifier)
		local entities = droid.entity.surface.find_entities({{droid.entity.position.x-rad, droid.entity.position.y-rad},{droid.entity.position.x+rad, droid.entity.position.y+rad}})	
		for k=1, #entities do local ent = entities[k]
			if ent.health ~= nil and ent.health < ent.prototype.max_health and ent.force ~= "enemy" then
				droid.target = ent
				droid.goto_pos = ent.position
				return
			end
		end
	end
	local rad = droid_scan_radius + global.modmash.droids.research_modifier
	if droid.command == no_command then
		local_droid_select_repair(droid)
		if is_valid(droid.target) then 			
			droid.command = repair_command
			droid.goto_pos = droid.target.position
			droid.entity.set_command({type=defines.command.go_to_location, destination=droid.goto_pos, distraction=defines.distraction.none})
		end
	elseif droid.goto_pos ~= nil and is_valid(droid.target) and droid.target.valid and droid.target.health ~= nil then		
		if (distance(droid.goto_pos.x,droid.goto_pos.y,droid.entity.position.x,droid.entity.position.y)<beam_dist) then
			local need = math.min(droid.target.prototype.max_health - droid.target.health,1)
			droid.target.health = droid.target.health + need
			local_create_beam(droid.entity,droid.target,"droid_standard_beam",beam_time)
			if droid.target.health >= droid.target.prototype.max_health then
				local_clear_droid_command(droid)
			end
		end
	else
		local_clear_droid_command(droid)
	end
end

if modmash.ticks ~= nil then	
	local init = function()	
		if global.modmash == nil then global.modmash = {} end
		if global.modmash.droids == nil then global.modmash.droids = {} end
		if global.modmash.ghosts == nil then global.modmash.ghosts = {} end
		if global.modmash.loot_boxes == nil then global.modmash.loot_boxes = {} end
		local_loot_boxes = global.modmash.loot_boxes
		global.modmash.droids_update_index = nil	
		if global.modmash.droids.research_modifier == nil then global.modmash.droids.research_modifier = 1 end
		global.modmash.droids.research_modifier = math.max(global.modmash.droids.research_modifier,5.55)
		local_rebuild_ghosts()
		return nil
	end

	local local_droid_tick = function()
		if init ~= nil then init = init() end
		if game.tick % 30 == 0 then							
			local droids = global.modmash.droids
			local index = global.modmash.droids_update_index
			if not index then index = 1 end
			local numiter = 0
			local updates = math.min(#droids,droids_per_tick)
			if global.modmash.droids.research_modifier == nil then global.modmash.droids.research_modifier = 1 end
			global.modmash.droids.research_modifier = math.max(global.modmash.droids.research_modifier,5.55)

			for k=index, #droids do local droid = droids[k];					
				if droid.entity.valid and not droid.entity.to_be_deconstructed(droid.entity.force) then				
					if droid.stack == nil then droid.stack = {name = nil, count = 0} end
					
					if droid.mode == collection_mode then
						local_droid_process_collection(droid)
					elseif droid.mode == scout_mode then				
						local_droid_process_scout(droid)
					elseif droid.mode == attack_mode then	
						local_droid_process_attack(droid)
					elseif droid.mode == repair_mode then	
						local_droid_process_repair(droid)
					elseif droid.mode == build_mode then	
						local_droid_process_build(droid)
					end
				end
				if k >= #droids then k = k + 1 end
				numiter = numiter + 1
				if numiter >= updates then return end
			end
		end
	end

	local local_droid_added = function(ent)
		if ent.name == "entity-ghost" or ent.name == "tile-ghost" then
			local_add_ghost(ent)
		end
		if global.modmash.droids == nil then end global.modmash.droids = {}
		if global.modmash.droids.last_mode == nil then global.modmash.droids.last_mode = scout_mode end
		if ent.name == "droid" then		
			ent.operable = false
			local d = {entity = ent}		
			table.insert(global.modmash.droids, d)
			local_set_mode(d,global.modmash.droids.last_mode)
		end
	end

	local local_droid_removed = function(entity)
		if entity.name == "entity-ghost" or entity.name == "tile-ghost" then
			local_remove_ghost(entity)
		end

		if entity.name == "droid" then				
			for _,e in pairs(entity.surface.find_entities_filtered{type="sticker", area=entity.bounding_box}) do 
				e.destroy() 
			end
			for index, droid in ipairs(global.modmash.droids) do
				if  droid.entity == entity then
					table.remove(global.modmash.droids, index)
					if droid.entity.valid and droid.stack ~=nil and droid.stack.count > 0 and droid.stack.count > 0 then  droid.entity.surface.spill_item_stack(droid.entity.position, {name=droid.stack.name, count=droid.stack.count}) end
					return
				end
			end
		end
	end

	local local_droid_adjust = function(entity)
		if entity.name == "droid" then
			for _, droid in ipairs(global.modmash.droids) do
				if droid.entity.valid then
					if not droid.entity.to_be_deconstructed(droid.entity.force) then
						if droid.entity == entity then		
							if droid.mode == attack_mode then
								local_set_mode(droid,scout_mode)
							elseif droid.mode == scout_mode then	
								local_set_mode(droid,collection_mode)
							elseif droid.mode == collection_mode then	
								local_set_mode(droid,repair_mode)
							elseif droid.mode == repair_mode then	
								local_set_mode(droid,build_mode)
							else
								local_set_mode(droid,attack_mode)
							end
							return
						end
					end
				end
			end
		end
	end

	local local_droid_research = function(event)
		if starts_with(event.research.name,"enhance-drone-targeting") then
			if global.modmash.droids.research_modifier == nil then global.modmash.droids.research_modifier = 1 end
			global.modmash.droids.research_modifier =  global.modmash.droids.research_modifier * 1.1		
		end	

	end

	table.insert(modmash.ticks,local_droid_tick)
	table.insert(modmash.on_added,local_droid_added)
	table.insert(modmash.on_remove,local_droid_removed)	
	table.insert(modmash.on_adjust,local_droid_adjust)
	table.insert(modmash.on_research,local_droid_research)

end