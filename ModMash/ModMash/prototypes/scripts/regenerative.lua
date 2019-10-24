log("regenerative.lua")
if not modmash or not modmash.util then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end

--[[defines]]
local medium_priority = modmash.events.medium_priority

local starts_with  = modmash.util.starts_with
local is_valid  = modmash.util.is_valid
local is_valid_and_persistant = modmash.util.is_valid_and_persistant

--[[unitialized globals]]
local regenerative = nil
local regenerables = nil

local local_init = function()	
	log("regenerative.local_init")
	if global.modmash.regenerative == nil then global.modmash.regenerative = {} end
	if global.modmash.regenerative.regenerables == nil then global.modmash.regenerative.regenerables = {} end
	if global.modmash.regenerative.research_modifier == nil then global.modmash.regenerative.research_modifier = 0.1 end
	regenerative = global.modmash.regenerative
	regenerables = global.modmash.regenerative.regenerables
	return end

local local_load = function() 
	log("regenerative.local_load")
	regenerative = global.modmash.regenerative
	regenerables = global.modmash.regenerative.regenerables
	end

local local_regenerative_notify_damaged = function(entity)
	if starts_with(entity.name,"regenerative") then
		for index=1, #regenerables do local regenerable = regenerables[index]	
			if is_valid_and_persistant(regenerable) then
				if entity == regenerable then	
					return
				end
			end
		end
		table.insert(regenerables, entity)	
	end end

local local_new_health = function(health,max_health)
	return math.min(max_health,regenerative.research_modifier+health)	
	end


local local_regenerative_tick = function()	
	--if true then return end
	for index=1, #regenerables do local regenerable = regenerables[index]		
		if is_valid_and_persistant(regenerable) then
			local max_health = regenerable.prototype.max_health
			if regenerable.health < max_health then
				regenerable.health = local_new_health(regenerable.health,max_health)
			end					
		else
			table.remove(global.modmash.regenerative, index)
		end
	end end

local local_regenerative_added = function(entity)
	if starts_with(entity.name,"regenerative") then
		if entity.health < entity.prototype.max_health then
			table.insert(regenerables, entity)	
		end
	end end

local local_regenerative_research = function(event)		
	if starts_with(event.research.name,"enhance-regenerative-speed") then
		if regenerative.research_modifier == nil then regenerative.research_modifier = 0.1 end
		regenerative.research_modifier = regenerative.research_modifier * 1.3
    end	end

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version < "0.17.61" then	
		--fix tech
		for _, tech in pairs(game.players[1].force.technologies) do
			if tech.researched == true and starts_with(tech.name,"enhance-regenerative-speed") then
				if global.modmash.regenerative.research_modifier == nil then global.modmash.regenerative.research_modifier = 1 end
				global.modmash.regenerative.research_modifier =  global.modmash.regenerative.research_modifier * 1.1
			end	
		end
		--fix entites
		global.modmash.regenerative.regenerables = {} -- just rebuild
		for _, surface in pairs(game.surfaces) do
			for c in surface.get_chunks() do
				local entities = surface.find_entities_filtered{area = c.area}
				for _, entity in pairs(entities) do
					local_regenerative_added(entity)
				end
			end
		end
	end
	end

modmash.register_script({
	on_tick = {
		priority = medium_priority,
		tick = local_regenerative_tick
		},
	on_init = local_init,
	on_load = local_load,
	on_added = local_regenerative_added,
	on_damage = local_regenerative_notify_damaged,
	on_research = local_regenerative_research,
	on_configuration_changed = local_on_configuration_changed
})