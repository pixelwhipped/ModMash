--local local_roboport_removed was referencing type not name may need to clean

require("prototypes.scripts.defines") 
local distance = modmashsplintervalkyries.util.distance
local is_valid  = modmashsplintervalkyries.util.is_valid
local table_index_of  = modmashsplintervalkyries.util.table.index_of
local table_contains = modmashsplintervalkyries.util.table.contains
local starts_with  = modmashsplintervalkyries.util.starts_with
local local_table_remove = modmashsplintervalkyries.util.table.remove
local is_valid_and_persistant = modmashsplintervalkyries.util.entity.is_valid_and_persistant
local print = modmashsplintervalkyries.util.print

local targets = nil
local return_targets = nil
local all_roboports = nil
local all_spiders = nil
local max_targets = nil
local max_distance = nil

local roboports_per_tick = 5
local spiders_per_tick = 5
local targets_per_tick = 10
local return_targets_per_tick = 5

local local_active = function()	
	return #return_targets + #targets + global.modmashsplintervalkyries.valkyries.projectiles
end

local local_add_projectile = function()	
	global.modmashsplintervalkyries.valkyries.projectiles = global.modmashsplintervalkyries.valkyries.projectiles + 1
end

local local_remove_projectile = function()
	global.modmashsplintervalkyries.valkyries.projectiles = math.max(global.modmashsplintervalkyries.valkyries.projectiles - 1,0)
end

local player_spider_distance_mod = function()
	local mod = (settings.global["setting-player-distance"].value/100)*0.5
	mod = mod + 0.5
	return mod
end

local local_update_return_targets = function(target)
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
		elseif is_valid(target.spider) then		
			local d = distance(target.spider.position.x,target.spider.position.y,target.entity.position.x,target.entity.position.y)
			if d < 4 then
			
				if target.spider.can_insert({name="valkyrie-robot",count = 1}) then		
					target.entity.destroy() 
					target.spider.insert({name="valkyrie-robot",count = 1})					
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

local local_find_enemy_units = function(s, p, d)
	local ret = {}
	local e  = s.find_entities_filtered{position=p,  radius = d, force = "enemy", limit=10} 
	for k = 1, #e do local v =e[k]
	--	print(e)
		if is_valid(v) and v.health ~= nil and v.health>0 then
			table.insert(ret,v)
		end
	end
	return ret
	--return s.find_enemy_units(p, d)
end

local local_update_target = function(k)
		local t = targets[k] --potential nil? wait and see if re-occours
		if t ~= nil then
			local r = t.entity
			local is_player = t.player ~= false and is_valid(t.player)
			local is_spider = t.spider ~= false and is_valid(t.spider)
			if is_valid(r) then
				local p = r.position
				local enemy = local_find_enemy_units(r.surface,p, max_distance/5) -- r.surface.find_enemy_units(p, max_distance/5)
				if enemy == nil or #enemy < 1 then
					table.remove(targets,k)				
					if is_player and is_valid(t.player.surface) and r.destroy() then
						local s = t.player.surface						
						s.create_entity{name='valkyrie-robot-return-projectile', speed=0.06, position=p, force="player", source=t.player, target=t.player.position}
						local_add_projectile()
					elseif is_spider and is_valid(t.spider.surface) and r.destroy() then
						local s = t.spider.surface						
						s.create_entity{name='valkyrie-robot-return-projectile', speed=0.06, position=p, force="player", source=t.spider, target=t.spider.position}
						local_add_projectile()
					else					
						local s = r.surface
						if is_valid(s)  then 
							s.create_entity{name="valkyrie-robot", position=p, force="player"}
						end					
					end
					r.destroy()
				end
			else
				table.remove(targets,k)
				return
			end
		else
			table.remove(targets,k)
			return
	end end

local local_find_targets = function()
	
	if local_active() < max_targets then
		for _, player in pairs(game.connected_players) do
			if is_valid(player) and is_valid(player.character) and is_valid(player.character.logistic_network) then
				local logistic = player.character.logistic_network
				local grid = nil				
				if player ~= nil and player.character ~= nil then grid = player.character.grid end
				
				if logistic and logistic.all_construction_robots > 0 and logistic.robot_limit > 0 and grid ~= nil and player.character.allow_dispatching_robots then
					local enemy = local_find_enemy_units(player.surface,player.position, max_distance * player_spider_distance_mod()) 
					--local enemy = player.surface.find_enemy_units(player.position, max_distance * player_spider_distance_mod() ) --player.surface.find_entities_filtered{area = {{-d, -d}, {d, d}}, force = "enemy", limit=1} --				
					if enemy ~= nil and #enemy > 0 then 
						if player.remove_item({name='valkyrie-robot',count=1}) > 0 then
							local c = player.surface.create_entity({
								name='valkyrie-robot-projectile',
								force=player.force,
								position=player.position,
								speed=0.06,
								source=player.character,
								target=enemy[1].position,
							  })
							if is_valid(c) then
								  local_add_projectile()
							end
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
				--local enemy = r.entity.surface.find_enemy_units(r.entity.position, max_distance)	
				local enemy = local_find_enemy_units(r.entity.surface,r.entity.position, max_distance)	
				
				if enemy ~= nil and #enemy > 0 then 							
					local removed = r.entity.get_inventory(defines.inventory.roboport_robot).remove("valkyrie-robot")					
					if removed > 0 then			
					    local c = r.entity.surface.create_entity({
							name='valkyrie-robot-projectile',
							force=r.entity.force,
							position=r.entity.position,
							speed=0.8,
							source=r.entity,
							target=enemy[1].position
							})	
						if is_valid(c) then
							local_add_projectile()
						end
					elseif global.modmashsplintervalkyries.valkyries.valkyrie_network == true then --- only if researched											
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
												position=port.position,
												speed=0.8,
												source=r.entity,
												target=enemy[1].position
												})	
											if is_valid(c) then
												local_add_projectile()
											end
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
		--[[if all_spiders == nil then  --remove when release
			global.modmashsplintervalkyries.valkyries.all_spiders = {} 
			all_spiders = global.modmashsplintervalkyries.valkyries.all_spiders			
		end]]
		updates = math.min(#all_spiders,spiders_per_tick)
		for k = 1, updates do 		
			
			local x = math.random(1, #all_spiders)
			
			local r = all_spiders[x]
			if is_valid(r.entity) then
				r = r.entity
				local logistic = r.logistic_network
				
				local grid = nil
				if r ~= nil then grid = r.grid end
				if logistic and logistic.all_construction_robots > 0 and logistic.robot_limit > 0 and grid ~= nil then
					
					--local enemy = r.surface.find_enemy_units(r.position, max_distance * player_spider_distance_mod()) --player.surface.find_entities_filtered{area = {{-d, -d}, {d, d}}, force = "enemy", limit=1} --				
					local enemy = local_find_enemy_units(r.surface, r.position, max_distance * player_spider_distance_mod())
					if enemy ~= nil and #enemy > 0 then 
						if r.remove_item({name='valkyrie-robot',count=1}) > 0 then
							local c = r.surface.create_entity({
								name='valkyrie-robot-projectile',
								force=r.force,
								position=r.position,
								speed=0.06,
								source=r,
								target=enemy[1].position,
							  })
							if is_valid(c) then
								  local_add_projectile()
							end
						end
					end
				end
			else
				table.remove(all_spiders,x)
				return
			end
		end

	end end


local local_valkyrie_tick = function()
	if global.modmashsplintervalkyries.valkyries.enable_valkyries ~= true then return end	

	local tindex = global.modmashsplintervalkyries.valkyries.valkyries_update_index
	if not tindex then 
		global.modmashsplintervalkyries.valkyries.valkyries_update_index = 1
		tindex = 1
	end
	local tnumiter = 0
	local tupdates = math.min(#targets,targets_per_tick)

	for k = tindex, #targets do 
		local_update_target(tindex)
		if k >= #targets then k = 1 end
		tnumiter = tnumiter + 1
		if tnumiter >= tupdates then 
			global.modmashsplintervalkyries.valkyries.valkyries_update_index = k
			k = #targets + 1 -- break
		end
	end
	if local_active() < max_targets then
		local_find_targets()
	end

	if not global.modmashsplintervalkyries.return_valkyries_update_index then global.modmashsplintervalkyries.return_valkyries_update_index = 1 end --fix order
	local rindex = global.modmashsplintervalkyries.return_valkyries_update_index

	local rnumiter = 0
	local rupdates = math.min(#return_targets,return_targets_per_tick)

	--checks targets are close to source entity	
	for k = rindex, #return_targets do t = return_targets[k]
		if local_update_return_targets(t) == true then
			table.remove(return_targets,k)
		end
		if k >= #return_targets then k = 1 end
		rnumiter = rnumiter + 1
		if rnumiter >= rupdates then 
			global.modmashsplintervalkyries.valkyries.return_valkyries_update_index	= k
			k = #return_targets + 1 -- break

		end
	end end

local local_roboport_added = function(entity)	
	if entity.type == "roboport" then		
		local d = {entity = entity}		
		table.insert(all_roboports, d)
	elseif entity.type == "spider-vehicle" then
		local d = {entity = entity}		
		
		table.insert(all_spiders, d)
	end
	end

local local_init = function()	
	if global.modmashsplintervalkyries == nil then global.modmashsplintervalkyries = {} end
	if global.modmashsplintervalkyries.valkyries == nil then global.modmashsplintervalkyries.valkyries = {} end
	if global.modmashsplintervalkyries.valkyries.targets == nil then global.modmashsplintervalkyries.valkyries.targets = {} end
	if global.modmashsplintervalkyries.valkyries.return_targets == nil then global.modmashsplintervalkyries.valkyries.return_targets = {} end
	
	if global.modmashsplintervalkyries.valkyries.all_roboports == nil then global.modmashsplintervalkyries.valkyries.all_roboports = {} end
	if global.modmashsplintervalkyries.valkyries.all_spiders == nil then global.modmashsplintervalkyries.valkyries.all_spiders = {} end
	if global.modmashsplintervalkyries.valkyries.max_targets == nil then global.modmashsplintervalkyries.valkyries.max_targets = 25 end
	if global.modmashsplintervalkyries.valkyries.max_distance == nil then global.modmashsplintervalkyries.valkyries.max_distance = 55 end
	if global.modmashsplintervalkyries.valkyries.projectiles == nil then global.modmashsplintervalkyries.valkyries.projectiles = 0 end
	if global.modmashsplintervalkyries.valkyries.highlights == nil then global.modmashsplintervalkyries.valkyries.highlights = {} end
	if global.modmashsplintervalkyries.valkyries.projectiles == nil then global.modmashsplintervalkyries.valkyries.projectiles = 0 end

	targets = global.modmashsplintervalkyries.valkyries.targets
	all_roboports = global.modmashsplintervalkyries.valkyries.all_roboports
	all_spiders = global.modmashsplintervalkyries.valkyries.all_spiders
	return_targets = global.modmashsplintervalkyries.valkyries.return_targets
	max_targets = global.modmashsplintervalkyries.valkyries.max_targets
	max_distance = global.modmashsplintervalkyries.valkyries.max_distance
	if global.modmashsplintervalkyries.valkyries.enable_valkyries == nil then global.modmashsplintervalkyries.valkyries.enable_valkyries = true end

	--May have been added mid game
	if #all_roboports == 0 then
		for _, surface in pairs(game.surfaces) do
			for _, f in pairs(surface.find_entities_filtered{type={"roboport"}}) do
				local_roboport_added(f)
			end
		end
	end

	if #all_spiders == 0 then
		for _, surface in pairs(game.surfaces) do
			for _, f in pairs(surface.find_entities_filtered{type={"spider-vehicle"}}) do
				local_roboport_added(f)
			end
		end
	end
	end

local local_load = function()	
	targets = global.modmashsplintervalkyries.valkyries.targets 
	all_roboports = global.modmashsplintervalkyries.valkyries.all_roboports 
	all_spiders = global.modmashsplintervalkyries.valkyries.all_spiders
	return_targets = global.modmashsplintervalkyries.valkyries.return_targets 
	max_targets = global.modmashsplintervalkyries.valkyries.max_targets 
	max_distance = global.modmashsplintervalkyries.valkyries.max_distance 		
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
					player = event.source,
					spider = false
				}
				)
			elseif event.source.type == "spider-vehicle" then
				table.insert(return_targets,
				{
					entity=entity,
					player = false,
					spider = event.source
				})
			else
				table.insert(return_targets, 
				{
					entity = entity,
					player = false,
					spider = false
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
					player = event.source,
					spider = false
				})
			elseif event.source.type == "spider-vehicle" then
				table.insert(targets,
				{
					entity=entity,
					player = false,
					spider = event.source
				})
			else
				table.insert(targets,
				{
					entity=entity,
					player = false,
					spider = false
				})
			end
		else
			table.insert(targets,
				{
					entity=entity,
					player = false,
					spider = false
				})
		end
	end end

local local_on_configuration_changed = function() 
	--local_roboport_removed was checking type not name
	if global.modmashsplintervalkyries.valkyries.target_name_correction ~= true then
		for k = #targets, -1 do
			if is_valid(targets[k]) ~= true then
				 table.remove(targets,k)
			end
		end
		for k = #return_targets, -1 do
			if is_valid(return_targets[k]) ~= true then
				 table.remove(return_targets,k)
			end
		end
		global.modmashsplintervalkyries.valkyries.target_name_correction = true
	end
	end

local local_roboport_removed = function(entity)
	if entity.type == "roboport" then				
		for index, roboport in pairs(all_roboports) do
			if  roboport.entity == entity then
				table.remove(all_roboports, index)
			end
		end
	elseif entity.name == "valkyrie-robot-combat" then				
		for index, target in pairs(targets) do
			if target == entity then
				table.remove(targets, index)
			end
		end
	elseif entity.name == "valkyrie-robot-return" then				
		for index, target in pairs(return_targets) do
			if target == entity then
				table.remove(return_targets, index)
			end
		end
	elseif entity.type == "spider-vehicle" then				
		for index, spider in pairs(all_spiders) do
			if  spider.entity == entity then
				table.remove(all_spiders, index)
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


local local_valkyrie_research = function(event)
	if starts_with(event.research.name,"enable-valkyries") then
		global.modmashsplintervalkyries.valkyries.enable_valkyries = true	
	end	
	if starts_with(event.research.name,"valkyries-network") then
		global.modmashsplintervalkyries.valkyries.valkyrie_network = true	
	end	
	if starts_with(event.research.name,"valkyrie-range") then		
		global.modmashsplintervalkyries.valkyries.max_distance = global.modmashsplintervalkyries.valkyries.max_distance + 10	
		max_distance = global.modmashsplintervalkyries.valkyries.max_distance
    end	
	if starts_with(event.research.name,"valkyrie-force") then		
		global.modmashsplintervalkyries.valkyries.max_targets = global.modmashsplintervalkyries.valkyries.max_targets + 25	
		max_targets = global.modmashsplintervalkyries.valkyries.max_targets
    end	
end

local local_on_entity_selected = function(event)
	local player = game.players[event.player_index]
	local entity = player.selected	
	local player_index = player.index
	if global.modmashsplintervalkyries.valkyries.highlights == nil then global.modmashsplintervalkyries.valkyries.highlights = {} end
	
	if is_valid(entity) and entity.type == "roboport" then
		if global.modmashsplintervalkyries.valkyries.highlights[player_index] ~= nil then
			rendering.destroy(global.modmashsplintervalkyries.valkyries.highlights[player_index])
		end
		local id = rendering.draw_circle
		{
			surface = entity.surface,
			players = {player},
			color = {r = 1, g = 0.1, b = 0, a = 0.1},
			draw_on_ground = true,
			width = 64,
			filled = false,
			target = entity,
			only_in_alt_mode = false,
			time_to_live = 60*10,
			radius = max_distance
		}
		global.modmashsplintervalkyries.valkyries.highlights[player_index] = id
	elseif global.modmashsplintervalkyries.valkyries.highlights[player_index] ~= nil then
		rendering.destroy(global.modmashsplintervalkyries.valkyries.highlights[player_index])	
	end
end


script.on_init(local_init)
script.on_load(local_load)
script.on_event(defines.events.on_selected_entity_changed,local_on_entity_selected)
script.on_nth_tick(44, local_valkyrie_tick)

script.on_event(defines.events.on_entity_died,
	function(event) 
		if is_valid(event.entity) then local_roboport_removed(event.entity) end 
	end)
script.on_event(defines.events.on_robot_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_roboport_removed(event.entity) end 
	end)
script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_roboport_removed(event.entity) end 
	end)
script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_roboport_added(event.entity) end 
	end)
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_roboport_added(event.created_entity) end 
	end,local_land_mine_filter)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_roboport_added(event.created_entity) end 
	end)
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_roboport_added(event.entity) end 
	end)
script.on_event(defines.events.on_trigger_created_entity, local_valkyrie_added)

script.on_event(defines.events.on_entity_cloned,
	function(event) 
		if is_valid(event.source) then local_on_entity_cloned(event) end 
	end)

script.on_event(defines.events.on_research_finished, local_valkyrie_research)

script.on_configuration_changed(local_on_configuration_changed)