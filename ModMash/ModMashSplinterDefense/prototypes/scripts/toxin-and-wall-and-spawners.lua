require ("prototypes.scripts.defines")

--[[defines]]
local biter_neuro_toxin_cloud = modmashsplinterdefense.defines.names.biter_neuro_toxin_cloud
local enhance_biter_neuro_toxin_range = modmashsplinterdefense.defines.names.enhance_biter_neuro_toxin_range
local define_biter_nero_toxin_research_modifier = modmashsplinterdefense.defines.defaults.biter_nero_toxin_research_modifier 
local define_biter_nero_toxin_research_modifier_increment = modmashsplinterdefense.defines.defaults.biter_nero_toxin_research_modifier_increment
local alerts_per_tick = modmashsplinterdefense.defines.defaults.alerts_per_tick
local force_player = modmashsplinterdefense.util.defines.names.force_player
local force_enemy = modmashsplinterdefense.util.defines.names.force_enemy
local force_neutral  = modmashsplinterdefense.util.defines.names.force_neutral

--[[create local references]]
--[[util]]
local starts_with  = modmashsplinterdefense.util.starts_with
local ends_with  = modmashsplinterdefense.util.ends_with
local is_valid  = modmashsplinterdefense.util.is_valid

--[[unitialized globals]]
local biter_nero_toxin = nil

--[[ensure globals]]
local local_init = function()	
	if global.modmashsplinterdefense.biter_nero_toxin == nil then global.modmashsplinterdefense.biter_nero_toxin = {} end
	if global.modmashsplinterdefense.biter_nero_toxin.research_modifier == nil then global.modmashsplinterdefense.biter_nero_toxin.research_modifier = define_biter_nero_toxin_research_modifier end
	if not global.modmashsplinterdefense.spawner_update_type_index then global.modmashsplinterdefense.spawner_update_type_index = {} end
	if not global.modmashsplinterdefense.spawner_update_type_index[defines.alert_type.entity_destroyed] then  global.modmashsplinterdefense.spawner_update_type_index[defines.alert_type.entity_destroyed] = 1 end
	if not global.modmashsplinterdefense.spawner_update_type_index[defines.alert_type.entity_under_attack] then  global.modmashsplinterdefense.spawner_update_type_index[defines.alert_type.entity_under_attack] = 1 end
	if global.modmashsplinterdefense.friends_ttl == nil then  global.modmashsplinterdefense.friends_ttl = {} end

	biter_nero_toxin = global.modmashsplinterdefense.biter_nero_toxin
	remote.call("modmashsplinterregenerative","register_regenerative",{"regenerative-wall"})

	end
local local_load = function()
	biter_nero_toxin = global.modmashsplinterdefense.biter_nero_toxin
	remote.call("modmashsplinterregenerative","register_regenerative",{"regenerative-wall"})
	end

local local_get_random_point = function(x, y, radius)
	local randX, randY
	repeat
		randX, randY = math.random(-radius, radius), math.random(-radius, radius)
	until (((-randX) ^ 2) + ((-randY) ^ 2)) ^ 0.5 <= radius
	return {x + randX, y + randY}
	end

local local_toxin_added = function(event)	
	local entity = event.entity
	if entity.name == biter_neuro_toxin_cloud then
		local friends = global.modmashsplinterdefense.friends_ttl
		local count = 10 * (biter_nero_toxin.research_modifier/modmashsplinterdefense.defines.defaults.biter_nero_toxin_research_modifier)
		for i =1, count do
			entity.surface.create_entity{name="toxin-poison-cloud",position=local_get_random_point(entity.position.x,entity.position.y,biter_nero_toxin.research_modifier)}
		end
		local enemies = entity.surface.find_entities_filtered({
			type = {"unit-spawner","unit","turret"},
			position = entity.position,
			radius = biter_nero_toxin.research_modifier,
		})
		

		for _, enemy in ipairs(enemies) do
			if enemy.prototype.subgroup.name=="enemies" then
				if enemy.type == "unit-spawner" then local p = enemy.position
					local n = enemy.name
					enemy.destroy()
					local e = entity.surface.create_entity{name=n, position=p, force = game.forces[force_neutral]}
					table.insert(friends,{entity = e, ttl = 18000})
				elseif enemy.type == "turret" then
					local p = enemy.position
					local n = enemy.name
					enemy.destroy()
					local e = entity.surface.create_entity{name=n, position=p, force = game.forces[force_player]}
					
				else
					enemy.force = game.forces[force_player]
					--todo: record friends and add time out
					table.insert(friends,{entity = enemy, ttl =  18000})
				end
			end
		end
	elseif entity.name == "biter-neuro-toxin-puff" then
		local friends = global.modmashsplinterdefense.friends_ttl
		local enemies = entity.surface.find_entities_filtered({
			type = {"unit-spawner","unit","turret"},
			position = entity.position,
			radius = 1,
		})
		for _, enemy in ipairs(enemies) do
			if enemy.prototype.subgroup.name=="enemies" then
				if enemy.type == "unit-spawner" then 
					--local p = enemy.position
				elseif enemy.type == "turret" then
					--local p = enemy.position
					--local n = enemy.name
					--enemy.destroy()
					--entity.surface.create_entity{name=n, position=p, force = game.forces[force_player]}
					
				else
					--if math.random(1,50) > 25 then
					enemy.force = game.forces[force_player]
					table.insert(friends,{entity = enemy, ttl =  18000})
					--end
				end
			end
		end
	end
end

local local_toxin_research = function(event)
	if starts_with(event.research.name,enhance_biter_neuro_toxin_range) then		
		biter_nero_toxin.research_modifier =  biter_nero_toxin.research_modifier * define_biter_nero_toxin_research_modifier_increment
    end	
end

local local_on_added = function(entity)		
	entity.force = game.forces[force_neutral]
	end

local local_on_spawned = function(entity)
	--modmashsplinterdefense.util.print(force_enemy)
	if ends_with(entity.name,"-biter") == true then
		
		if entity.force == game.forces[force_neutral] then		
			entity.force = game.forces[force_enemy]
		end
	end
	end

local local_on_post_entity_died = function(event)
	if event.ghost ~= nil then	
		if event.ghost.ghost_name == "biter-spawner" then
			event.ghost.destroy()
		end
	end
	end

local local_update_alert_type = function(alerts_id)
	if alerts_id == nil then return end
	if game == nil or game.players == nil or game.players[1] == nil then return end
	local alerts = game.players[1].get_alerts{type=alerts_id}
	if alerts == nil then return end
	alerts = alerts[alerts_id]
	if alerts == nil then return end
		
	local numiter = 0			
	local updates = math.min(#alerts,alerts_per_tick)
	for k=global.modmashsplinterdefense.spawner_update_type_index[alerts_id], #alerts do 
		local j = alerts[k] 
		for w=1,#j do x=j[w]
			if  x~= nil and x.target~=nil then			
				if (x.target.name ~= nil and (starts_with(x.target.name,"biter") or ends_with(x.target.name,"biter"))) or x.target.prototype.subgroup.name=="enemies" then
					game.players[1].remove_alert{entity = x.target}
					
				end							
			end
			if k >= #alerts then k = 1 end
			numiter = numiter + 1
			if numiter >= updates then 
				global.modmashsplinterdefense.spawner_update_type_index[k] = k
				return
			end
		end
	end
end

--[[local local_on_script_trigger_effect = function(event)
	print("trigger")
	if event.effect_id == "neural-toxin-round" then
		--if event.source_entity.name == "them-roboport" then
	end
end]]



local local_on_configuration_changed = function(event) 	
	if global.modmashsplinterdefense.friends_ttl == nil then  global.modmashsplinterdefense.friends_ttl = {} end
end

local local_nth_tick = function()
	local nf = {}
	local f = global.modmashsplinterdefense.friends_ttl
	for k = 1, #f do local e = f[k]
		if is_valid(e.entity) and (e.ttl - 120) >0 then
			table.insert(nf,{entity = e.entity, ttl = (e.ttl-120)})
		elseif is_valid(e.entity) then
			if  e.entity.type == "unit-spawner" then 
					local p = e.entity.position
					local n = e.entity.name
					local s = e.entity.surface
					e.entity.destroy()
					s.create_entity{name=n, position=p, force = game.forces[force_enemy]}
			else
				e.entity.force = game.forces[force_enemy]
			end
		end
	end
	global.modmashsplinterdefense.friends_ttl = nf
end

local local_tick = function()	
	local_update_alert_type(defines.alert_type.entity_destroyed)
	local_update_alert_type(defines.alert_type.entity_under_attack)
	end

script.on_configuration_changed(local_on_configuration_changed)
script.on_nth_tick(120, local_nth_tick)

script.on_init(local_init)
script.on_load(local_load)
--script.on_event(defines.events.on_script_trigger_effect, local_on_script_trigger_effect)
script.on_event(defines.events.on_tick, local_tick)
script.on_event(defines.events.on_trigger_created_entity, local_toxin_added)
script.on_event(defines.events.on_post_entity_died,local_on_post_entity_died)
script.on_event(defines.events.on_entity_spawned,function(event) 
		if is_valid(event.entity) then 
			local_on_spawned(event.entity) 
		end 
		end)

local local_spawner_filter = {{filter = "type", type = "unit-spawner"}, {filter = "name", name = "biter-spawner", mode = "and"}}
script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_on_added(event.entity,event) end 
	end,local_spawner_filter)
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_on_added(event.created_entity) end 
	end,local_spawner_filter)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_on_added(event.created_entity) end 
	end,local_spawner_filter)
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_on_added(event.entity) end 
	end,local_spawner_filter)
