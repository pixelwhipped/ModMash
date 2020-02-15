--[[dsync checking 
local index change to gloab.modmash.biter_spawner_index in event
fixed use of global.modmash.droids_update_index
]]

--[[code reviewed 12.10.19]]
log("biter-spawner.lua")
--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end
local alerts_per_tick = 50

--[[defines]]
local force_neutral  = modmash.defines.names.force_neutral
local force_enemy  = modmash.defines.names.force_enemy

--[[create local references]]
--[[util]]
local starts_with  = modmash.util.starts_with
local ends_with  = modmash.util.ends_with

local local_on_added = function(entity)		
	modmash.util.print(entity.name)
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

local local_tick = function()
	local numiter = 0	
	if not global.modmash.spawner_update_index then  global.modmash.spawner_update_index = 1 end
	--dsync?
	local alerts = game.players[1].get_alerts{}
	if #alerts>0 then
		local updates = math.min(#alerts,alerts_per_tick)
		for k=global.modmash.spawner_update_index, #alerts do local v = alerts[k] 
			if v ~= nil then
				for j=1, #v do local w = v[j] 
					for l=1, #w do local x = w[l] 
						if  x~= nil and x.target~=nil then							
							if (x.target.name ~= nil and starts_with(x.target.name,"biter")) or x.target.prototype.subgroup.name=="enemies" then
								game.players[1].remove_alert{entity = x.target}
							end							
						end
					end
				end
			end
			if k >= #alerts then k = 1 end
			numiter = numiter + 1
			if numiter >= updates then 
				global.modmash.spawner_update_index = k
				return
			end
		end
	end
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
	end

modmash.register_script({
	names = {"biter-spawner"},
	on_tick = local_tick,
	on_added_by_name = local_on_added,
	on_spawned = local_on_spawned,
	on_post_entity_died = local_on_post_entity_died,
	on_configuration_changed = local_on_configuration_changed
})