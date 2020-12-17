require("prototypes.scripts.defines")


local table_contains = modmashsplinterfluid.util.table.contains
local is_valid  = modmashsplinterfluid.util.is_valid
local print  = modmashsplinterfluid.util.print
local starts_with  = modmashsplinterfluid.util.starts_with
local is_valid_and_persistant = modmashsplinterfluid.util.entity.is_valid_and_persistant
local get_entities_to  = modmashsplinterfluid.util.entity.get_entities_to
local change_fluidbox_fluid = modmashsplinterfluid.util.fluid.change_fluidbox_fluid
local get_connected_input_fluid = modmashsplinterfluid.util.fluid.get_connected_input_fluid
local opposite_direction = modmashsplinterfluid.util.opposite_direction



local boilers = nil
local discharge_pumps = nil

local local_init = function() 
	if global.modmashsplinterfluid.valves == nil then global.modmashsplinterfluid.valves = {} end
	if global.modmashsplinterfluid.valves.boilers == nil then global.modmashsplinterfluid.valves.boilers = {} end
	if global.modmashsplinterfluid.valves.discharge_pumps == nil then global.modmashsplinterfluid.valves.discharge_pumps = {} end
	boilers = global.modmashsplinterfluid.valves.boilers
	discharge_pumps = global.modmashsplinterfluid.valves.discharge_pumps
	end

local local_load = function() 
	boilers = global.modmashsplinterfluid.valves.boilers
	discharge_pumps = global.modmashsplinterfluid.valves.discharge_pumps
	end

local local_tick = function()	
	for k=1, #boilers  do
		local entity = boilers[k]
		if is_valid(entity) and entity.to_be_deconstructed(entity.force) ~= true and entity.is_crafting() then							
			local outpipe = get_connected_input_fluid(entity,2)
			if outpipe ~= nil then
				if entity.fluidbox[2] ~= nil then
					local t = entity.fluidbox[2]
					t.temperature = 90
					entity.fluidbox[2] = t
				end
				local t = outpipe.entity.fluidbox[outpipe.box]
				if t ~= nil then 
					t.temperature = 90
					outpipe.entity.fluidbox[outpipe.box] = t
				end
			end
		end
	end	
	for k=1, #discharge_pumps do 
		local entity = discharge_pumps[k]
		if is_valid(entity) and entity.to_be_deconstructed(entity.force) ~= true then				
			local connected_pumps = get_entities_to(opposite_direction(entity.direction),entity)
			if #connected_pumps > 0 then	
				for index=1, #connected_pumps do local connection = connected_pumps[index]
					change_fluidbox_fluid(connection,-10,0.01)
				end
				local fluid =  entity.fluidbox[1]
				if fluid ~= nil then
					fluid.amount = 0.01
					entity.fluidbox[1] = fluid
				end
			end
		end
	end
	end

local local_added = function(entity)	
	if entity.name == "mini-boiler" then
		table.insert(boilers, entity)
	elseif entity.name == "mm-discharge-water-pump" then
		table.insert(discharge_pumps, entity)
	end
end

local local_remove = function(tbl, element)
	for k = 1, #tbl do
		if tbl[k] == element then 
			table.remove(tbl,k)
			return
		end
	end
end

local local_removed = function(entity)	
	if entity.name == "mini-boiler" then
		local_remove(boilers, entity)
	elseif entity.name == "mm-discharge-water-pump" then
		local_remove(discharge_pumps, entity)		
	end
end

script.on_event(defines.events.on_tick, local_tick)

script.on_init(local_init)
script.on_load(local_load)
script.on_event(defines.events.on_entity_died,
	function(event) 
		if is_valid(event.entity) then local_removed(event.entity,event) end 
	end)

script.on_event(defines.events.on_robot_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_removed(event.entity,event) end 
	end)

script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_removed(event.entity,event) end 
	end)


script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_added(event.entity,event) end 
	end)
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_added(event.created_entity,event) end 
	end)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_added(event.created_entity,event) end 
	end)
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_added(event.entity,event) end 
	end)