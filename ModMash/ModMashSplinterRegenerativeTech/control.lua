require("prototypes.scripts.defines") 
if not global.modmashsplinterregenerative then global.modmashsplinterregenerative = {} end
local starts_with  = modmashsplinterregenerative.util.starts_with
local table_contains = modmashsplinterregenerative.util.table.contains
local is_valid  = modmashsplinterregenerative.util.is_valid
local is_valid_and_persistant = modmashsplinterregenerative.util.entity.is_valid_and_persistant
local print = modmashsplinterregenerative.util.print

local regenerative_names = {}
--[[unitialized globals]]
local regenerative = nil
local regenerables = nil
local local_init = function()	
	if global.modmashsplinterregenerative.regenerative == nil then global.modmashsplinterregenerative.regenerative = {} end
	if global.modmashsplinterregenerative.regenerative.regenerables == nil then global.modmashsplinterregenerative.regenerative.regenerables = {} end
	if global.modmashsplinterregenerative.regenerative.research_modifier == nil then global.modmashsplinterregenerative.regenerative.research_modifier = 0.05 end
	regenerative = global.modmashsplinterregenerative.regenerative
	regenerables = global.modmashsplinterregenerative.regenerative.regenerables
	return end

local local_load = function() 
	regenerative = global.modmashsplinterregenerative.regenerative
	regenerables = global.modmashsplinterregenerative.regenerative.regenerables
	end

local local_regenerative_notify_damaged = function(event)
	local entity = event.entity
	if is_valid(entity) ~= true then return end
	if table_contains(regenerative_names,entity.name) then
		for index=1, #regenerables do local regenerable = regenerables[index]	
			if is_valid_and_persistant(regenerable) then
				if entity == regenerable then	
					return
				end
			end
		end
		table.insert(regenerables, entity)	
	end end

local local_inner_register_regenerative = function(name)
	if table_contains(regenerative_names,name) ~= true then table.insert(regenerative_names,name) end
	end

local local_register_regenerative = function(name)	
	if type(name) == "table" then
		for k=1, #name do local n = name[k]
			if type(n) == "string" then
				local_inner_register_regenerative(n)
			end
		end
	elseif type(name) == "string" then
		local_inner_register_regenerative(name)
	else
		log("register_regenerative requires string or table of strings")
	end
	end

local local_regenerative_tick = function()	
	for index=#regenerables,1,-1 do local regenerable = regenerables[index]	
		if is_valid_and_persistant(regenerable) then
			local max_health = regenerable.prototype.max_health
			if regenerable.health < max_health then
				regenerable.health = math.min(regenerative.research_modifier+regenerable.health+regenerable.prototype.healing_per_tick,max_health)
			else
				table.remove(regenerables, index)
			end					
		else
			table.remove(regenerables, index)
		end
	end end

local local_regenerative_research = function(event)		
	if starts_with(event.research.name,"enhance-regenerative-speed") then
		if regenerative.research_modifier == nil then regenerative.research_modifier = 0.1 end
		regenerative.research_modifier = regenerative.research_modifier * 1.3
    end	end


script.on_event({defines.events.on_entity_damaged},local_regenerative_notify_damaged)
script.on_init(local_init)
script.on_load(local_load)
script.on_event(defines.events.on_tick, local_regenerative_tick)
script.on_event(defines.events.on_research_finished, local_regenerative_research)

remote.add_interface("modmashsplinterregenerative",{
	register_regenerative = local_register_regenerative,
	})