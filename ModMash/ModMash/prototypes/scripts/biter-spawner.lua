--[[dsync checking 
local index change to gloab.modmash.biter_spawner_index in event
fixed use of global.modmash.droids_update_index
]]

--[[code reviewed 12.10.19]]
log("biter-spawner.lua")
--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end
local alerts_per_tick = 25

--[[defines]]
local force_neutral  = modmash.defines.names.force_neutral
local force_enemy  = modmash.defines.names.force_enemy

--[[create local references]]
--[[util]]
local starts_with  = modmash.util.starts_with
local ends_with  = modmash.util.ends_with

local local_on_added = function(entity)		
	entity.force = game.forces[force_neutral]
	end

local local_on_spawned = function(entity)
	if ends_with(entity.name,"-biter") and entity.force == game.forces[force_neutral] then		
		entity.force = game.forces[force_enemy]
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
	
	local alerts = game.players[1].get_alerts{type=alerts_id}
	alerts = alerts[alerts_id]
	if alerts == nil then return end
		
	local numiter = 0			
	local updates = math.min(#alerts,alerts_per_tick)
	for k=global.modmash.spawner_update_type_index[alerts_id], #alerts do 
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
				global.modmash.spawner_update_type_index[k] = k
				return
			end
		end
	end
end
local local_tick = function()	
	local_update_alert_type(defines.alert_type.entity_destroyed)
	local_update_alert_type(defines.alert_type.entity_under_attack)
	end

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version < "0.17.61" then	
		for _, surface in pairs(game.surfaces) do
			for _, f in pairs(surface.find_entities_filtered{name={"entity-ghost","tile-ghost"}}) do
				if f.ghost_name == "biter-spawner" then
					f.destroy()
				end
			end
		end
	end
	if f.mod_changes["modmash"].old_version < "0.18.35" then	
		if not global.modmash.spawner_update_type_index then global.modmash.spawner_update_type_index = {} end
		if not global.modmash.spawner_update_type_index[defines.alert_type.entity_destroyed] then  global.modmash.spawner_update_type_index[defines.alert_type.entity_destroyed] = 1 end
		if not global.modmash.spawner_update_type_index[defines.alert_type.entity_under_attack] then  global.modmash.spawner_update_type_index[defines.alert_type.entity_under_attack] = 1 end
	end
	end

local control = {
	names = {"biter-spawner"},
	on_tick = local_tick,
	on_added_by_name = local_on_added,
	on_spawned = local_on_spawned,
	on_post_entity_died = local_on_post_entity_died,
	on_configuration_changed = local_on_configuration_changed
}

if modmash.profiler == true then
	local profiler = modmash.util.get_profiler("biter spawner")
	control.on_tick = function() 
		profiler.update(local_tick) 
	end
end
modmash.register_script(control)