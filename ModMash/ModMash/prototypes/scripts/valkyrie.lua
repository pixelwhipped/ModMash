--[[dsync checking 
ok only locals are reference to globals or a constant
]]

log("valkyrie.lua")
if not modmash or not modmash.util then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end

local low_priority = modmash.events.low_priority

local distance  = modmash.util.distance
local get_entities_around  = modmash.util.get_entities_around
local is_valid  = modmash.util.is_valid
local table_index_of  = modmash.util.table.index_of
local table_contains = modmash.util.table.contains
local starts_with  = modmash.util.starts_with
local local_table_remove = modmash.util.table.remove
local is_valid_and_persistant = modmash.util.is_valid_and_persistant

local targets = nil
local return_targets = nil
local all_roboports = nil
local max_targets = nil
local max_distance = nil

local roboports_per_tick = 5
local targets_per_tick = 10
local return_targets_per_tick = 5

local local_active = function()
	if global.modmash.valkyries.projectiles == nil then global.modmash.valkyries.projectiles = 0 end
	return #return_targets + #targets + global.modmash.valkyries.projectiles
end

local local_add_projectile = function()
	if global.modmash.valkyries.projectiles == nil then global.modmash.valkyries.projectiles = 0 end
	global.modmash.valkyries.projectiles = global.modmash.valkyries.projectiles + 1
end

local local_remove_projectile = function()
	if global.modmash.valkyries.projectiles == nil then global.modmash.valkyries.projectiles = 0 end
	global.modmash.valkyries.projectiles = math.max(global.modmash.valkyries.projectiles - 1,0)
end

local local_init = function()	
	if global.modmash == nil then global.modmash = {} end
	if global.modmash.valkyries == nil then global.modmash.valkyries = {} end
	if global.modmash.valkyries.targets == nil then global.modmash.valkyries.targets = {} end
	if global.modmash.valkyries.return_targets == nil then global.modmash.valkyries.return_targets = {} end
	
	if global.modmash.valkyries.all_roboports == nil then global.modmash.valkyries.all_roboports = {} end
	if global.modmash.valkyries.max_targets == nil then global.modmash.valkyries.max_targets = 25 end
	if global.modmash.valkyries.max_distance == nil then global.modmash.valkyries.max_distance = 55 end
	if global.modmash.valkyries.projectiles == nil then global.modmash.valkyries.projectiles = 0 end
	
	targets = global.modmash.valkyries.targets
	all_roboports = global.modmash.valkyries.all_roboports
	return_targets = global.modmash.valkyries.return_targets
	max_targets = global.modmash.valkyries.max_targets
	max_distance = global.modmash.valkyries.max_distance
	if global.modmash.valkyries.enable_valkyries == nil then global.modmash.valkyries.enable_valkyries = true end
	end

local local_load = function()	
		targets = global.modmash.valkyries.targets 
		all_roboports = global.modmash.valkyries.all_roboports 
		return_targets = global.modmash.valkyries.return_targets 
		max_targets = global.modmash.valkyries.max_targets 
		max_distance = global.modmash.valkyries.max_distance 		
	end

local local_update_return_targets = function(target)
	 -- invalid?
	if target ~= nil and is_valid(target.entity) then	
		if is_valid(target.player) then		
		
			local d = distance(target.player.position.x,target.player.position.y,target.entity.position.x,target.entity.position.y)
			if d < 4 then
			
				if target.player.can_insert({name="valkyrie-robot",count = 1}) then		
					target.entity.destroy() 
					target.player.insert({name="valkyrie-robot",count = 1})					
					return true
				end
			end
		else --player no longer valid
			local s = target.entity.surface
			if is_valid(s) then
				target.entity.destroy()
				s.create_entity{name="valkyrie-robot", position=p, force="player"}
				return true
			end				
		end
	end	return false
end

local local_update_target = function(k)
	--for k = #targets, 1, -1 do t = targets[k]
		--if target == nil then return end
		local t = targets[k]
		local r = t.entity
		local is_player = t.player ~= false
		if is_valid(r) then
			local p = r.position
			local enemy = r.surface.find_enemy_units(p, max_distance/5)
			if enemy == nil or #enemy < 1 then
				table.remove(targets,k)				
				if is_valid(t.player) and is_valid(t.player.surface) and r.destroy() then
					local s = t.player.surface
					if is_player then
						if is_valid(t.player)then							
							s.create_entity{name='valkyrie-robot-return-projectile', speed=0.06, position=p, force="player", source=t.player, target=t.player.position}
							local_add_projectile()
						else
							s.create_entity{name="valkyrie-robot", position=p, force="player"}
						end
					else
						s.create_entity{name="valkyrie-robot", position=p, force="player"}
					end
				else					
					local s = r.surface
					if is_valid(s)  then 
						s.create_entity{name="valkyrie-robot", position=p, force="player"}
					end
					r.destroy()
				end
			end
		else
			table.remove(targets,k)
			return
		--end
	end end

local local_find_targets = function()
	
	if local_active() < max_targets then
		for _, player in pairs(game.connected_players) do
			if is_valid(player) and is_valid(player.character) and is_valid(player.character.logistic_network) then
				local logistic = player.character.logistic_network
				local grid = nil
				if player ~= nil and player.character ~= nil then grid = player.character.grid end
				if logistic and logistic.all_construction_robots > 0 and logistic.robot_limit > 0 and grid ~= nil then
					--local d = max_distance/5
					local enemy = player.surface.find_enemy_units(player.position, max_distance) --player.surface.find_entities_filtered{area = {{-d, -d}, {d, d}}, force = "enemy", limit=1} --				
					if enemy ~= nil and #enemy > 0 then 
						if player.remove_item({name='valkyrie-robot',count=1}) > 0 then
							  player.surface.create_entity({
								name='valkyrie-robot-projectile',
								force=player.force,
								position=player.position,
								speed=0.06,
								source=player.character,
								target=enemy[1].position,
							  })
							  local_add_projectile()
						end
					end
				end
			end
		end
		
		local updates = math.min(#all_roboports,roboports_per_tick)
		
		for k = 1, updates do 		
			local x = math.random(1, #all_roboports)
			r = all_roboports[x]
			if is_valid(r.entity) then			
				local enemy = r.entity.surface.find_enemy_units(r.entity.position, max_distance)		
				
				if enemy ~= nil and #enemy > 0 then 							
					local removed = r.entity.get_inventory(defines.inventory.roboport_robot).remove("valkyrie-robot")
					--modmash.util.print(x .. " of " .. #all_roboports .. " " .. serpent.block(r.entity.get_inventory(defines.inventory.roboport_robot).get_contents()))
					if removed > 0 then			
					    local c = r.entity.surface.create_entity({
							name='valkyrie-robot-projectile',
							force=r.entity.force,
							position=r.entity.position,
							speed=0.8,
							source=r.entity,
							target=enemy[1].position
							})	
							local_add_projectile()
					elseif global.modmash.valkyries.valkyrie_network == true then --- only if researched					
						
						local net = r.entity.logistic_network
						if net ~= nil then							
							local cells = net.cells
							if cells ~= nil then								
								for z = 1, #cells do local port = cells[z].owner									
									if port.type == "roboport" then									
										removed = port.get_inventory(defines.inventory.roboport_robot).remove("valkyrie-robot")
										if removed > 0 then			
											local c = port.surface.create_entity({
												name='valkyrie-robot-projectile',
												force=r.entity.force,
												position=r.entity.position,
												speed=0.8,
												source=r.entity,
												target=enemy[1].position
												})	
											return
										end
									end
								end
							end
						end
					end
				end
			else
				table.remove(all_roboports,x)
				return
			end
		end
	end end

local local_valkyrie_tick = function()		
	--if global.modmash.valkyries.projectiles == nil then global.modmash.valkyries.projectiles = 0 end
	--modmash.util.print(#return_targets .. " " .. #targets .. " " .. global.modmash.valkyries.projectiles)
	if global.modmash.valkyries.enable_valkyries ~= true then return end	

	local tindex = global.modmash.valkyries.valkyries_update_index
	if not tindex then 
		global.modmash.valkyries.valkyries_update_index = 1
		tindex = 1
	end
	local tnumiter = 0
	local tupdates = math.min(#targets,targets_per_tick)

	for k = tindex, #targets do 
		local_update_target(tindex)
		if k >= #targets then k = 1 end
		tnumiter = tnumiter + 1
		if tnumiter >= tupdates then 
			global.modmash.valkyries.valkyries_update_index	= k
			k = #targets + 1 -- break
		end
	end
	if local_active() < max_targets then
		local_find_targets()
	end

	if not global.modmash.return_valkyries_update_index then global.modmash.return_valkyries_update_index = 1 end --fix order
	local rindex = global.modmash.return_valkyries_update_index

	local rnumiter = 0
	local rupdates = math.min(#return_targets,return_targets_per_tick)

	for k = rindex, #return_targets do t = return_targets[k]
		if local_update_return_targets(t) == true then
			table.remove(return_targets,k)
		end
		if k >= #return_targets then k = 1 end
		rnumiter = rnumiter + 1
		if rnumiter >= rupdates then 
			global.modmash.valkyries.return_valkyries_update_index	= k
			k = #return_targets + 1 -- break

		end
	end end

local local_roboport_added = function(entity)
	
	if entity.type == "roboport" then		
		local d = {entity = entity}		
		table.insert(all_roboports, d)
	end
	end

local local_valkyrie_added = function(event)
	
	local entity = event.entity		
	if entity.name == "valkyrie-robot-return" then
		local_remove_projectile()
		if is_valid(event.source) then
			if event.source.name == "character" then
				table.insert(return_targets, 
				{
					entity = entity,
					player = event.source
				}
				)
			else
				table.insert(return_targets, 
				{
					entity = entity,
					player = false
				}
				)
			end
		end
	elseif entity.name == "valkyrie-robot-combat" then
		local_remove_projectile()
		if is_valid(event.source) then
			if event.source.name == "character" then
				table.insert(targets,
				{
					entity=entity,
					player = event.source
				})
			else
				table.insert(targets,
				{
					entity=entity,
					player = false
				})
			end
		else
			table.insert(targets,
				{
					entity=entity,
					player = false
				})
		end
	end end

local local_roboport_removed = function(entity)
	if entity.type == "roboport" then				
		for index, roboport in pairs(all_roboports) do
			if  roboport.entity == entity then
				table.remove(all_roboports, index)
			end
		end
	elseif entity.type == "valkyrie-robot-combat" then				
		for index, target in pairs(targets) do
			if target == entity then
				table.remove(targets, index)
			end
		end
	elseif entity.type == "valkyrie-robot-return" then				
		for index, target in pairs(return_targets) do
			if target == entity then
				table.remove(return_targets, index)
			end
		end
	end end

local local_on_entity_cloned = function(event)
	if is_valid(event.source) then
		if event.source.type == "roboport" then 		
			for index, roboport in pairs(all_roboports) do
				if  roboport.entity == event.source then
					roboport.entity = event.destination
					return
				end
			end
		elseif event.source.type == "valkyrie-robot-combat" then 		
			local_table_remove(targets, event.source)	
			table.insert(targets, event.destination)	
		elseif event.source.type == "valkyrie-robot-return" then 		
			local_table_remove(return_targets, event.source)	
			table.insert(return_targets, event.destination)	
		end
	end end

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version < "0.17.82" then	
		--if global.modmash.valkyries.return_targets == nil then global.modmash.valkyries.return_targets = {} end
		local_init()
	end
	if f.mod_changes["modmash"].old_version < "0.17.79" then	
		for _, tech in pairs(game.players[1].force.technologies) do
			if tech.researched == true and starts_with(tech.name,"enable-valkyries") then
				global.modmash.valkyries.enable_valkyries = true
			end	
		end
		for _, surface in pairs(game.surfaces) do
			for _, f in pairs(surface.find_entities_filtered{type={"roboport"}}) do
				local_roboport_added(f)
			end
		end
	end end

local local_valkyrie_research = function(event)
	if starts_with(event.research.name,"enable-valkyries") then
		global.modmash.valkyries.enable_valkyries = true	
	end	
	if starts_with(event.research.name,"valkyries-network") then
		global.modmash.valkyries.valkyrie_network = true	
	end	
	if starts_with(event.research.name,"valkyrie-range") then		
		global.modmash.valkyries.max_distance = global.modmash.valkyries.max_distance + 10	
		max_distance = global.modmash.valkyries.max_distance
    end	
	if starts_with(event.research.name,"valkyrie-force") then		
		global.modmash.valkyries.max_targets = global.modmash.valkyries.max_targets + 25	
		max_targets = global.modmash.valkyries.max_targets
    end	
end

modmash.register_script({
	on_tick = {
		tick = local_valkyrie_tick,
		priority = low_priority
		},
	on_init = local_init,
	on_load = local_load,
	on_added = local_roboport_added,
	on_trigger_created_entity = local_valkyrie_added,
	on_removed = local_roboport_removed,
	on_research = local_valkyrie_research,
	on_configuration_changed = local_on_configuration_changed,
	on_entity_cloned = local_on_entity_cloned
})