if not modmash or not modmash.util then require("prototypes.scripts.util") end

local is_valid  = modmash.util.is_valid
local get_connected_input_fluid  = modmash.util.get_connected_input_fluid
local set_new_signal  = modmash.util.signal.set_new_signal
local try_set_recipe  = modmash.util.try_set_recipe
local table_contains = modmash.util.table.contains
local valve_types = {"modmash-super-boiler-valve", "mini-boiler", "modmash-check-valve", "modmash-overflow-valve", "condenser-valve", "modmash-underflow-valve"}		

local local_get_connected_input_fluid_for_valve = function(valve,box)
	if box == 1 then
		if valve.box1 ~= nil and is_valid(valve.box1.entity) then return valve.box1
		else valve.box1 = get_connected_input_fluid(valve.entity,box) end
	elseif box == 2 then
		if valve.box2 ~= nil and is_valid(valve.box2.entity) then return valve.box2
		else valve.box2 = get_connected_input_fluid(valve.entity,box) end
	else
		return get_connected_input_fluid(valve.entity,box)
	end
end

local local_set_sticker = function(valve, variation)
	if valve.signal ~= nil then
		valve.signal.destroy() 
	end
	if variation > 0 then
		valve.signal = set_new_signal(valve.entity,"valve-indicator",variation)
	end
end

local local_refresh_sticker = function(valve)
	if valve.value == 0.25 then
		local_set_sticker(valve,1)
	elseif valve.value == 0.50 then
		local_set_sticker(valve,2)
	elseif valve.value == 0.75 then
		local_set_sticker(valve,3)
	else
		local_set_sticker(valve,0)
	end
end

local local_rebuild_lables = function()
	local valves = global.modmash.valves
	for k=1, #valves do local valve = valves[k];			
		if valve ~= nil and valve.entity ~= nil and valve.entity.valid then	
			if not valve.entity.to_be_deconstructed(valve.entity.force) then
				if valve.entity.name == "modmash-overflow-valve" or valve.entity.name == "modmash-underflow-valve" then
					local_refresh_sticker(valve)
				end
			end
		end
	end
end

local init = function()	
	if global.modmash.valves == nil then global.modmash.valves = {} end	
	local_rebuild_lables()
	return nil end

local local_clear_fluid_recipe = function(entity)		
	local call = function(e)
		local sum = 0
		for i = 1, #e.fluidbox do local f = e.fluidbox[i]
			if f ~= nil then sum = sum + f.amount end
		end
		if sum == 0 then e.set_recipe(nil) end
	end
	if entity.get_recipe() == nil then return true end
	local status, retval = pcall(call,entity)
	if status == true then return end
end

local local_check_valve_process = function(valve)
	local entity = valve.entity
	entity.energy = 100000
	if valve.entity.is_crafting() then return end
	local fluid = nil
	local pipe = local_get_connected_input_fluid_for_valve(valve,1)
	if pipe ~= nil then
		fluid = pipe.entity.fluidbox[pipe.box]	
	end

	local pipe2 = local_get_connected_input_fluid_for_valve(valve,2)
	if pipe ~= nil then
		local fluid2 = pipe.entity.fluidbox[pipe.box]	
	--[[	if fluid2 ~= nil and fluid2~= fluid then
			local name1 = nil
			local name2 = nil
			if fluid ~= nil and fluid.name ~= nil then name1 = fluid.name else name1 = "nil" end
			if fluid2 ~= nil and fluid2.name ~= nil then name2 = fluid2.name else name2 = "nil" end
			modmash.util.print("1="..name1.." 2="..name2)
		end]]
	end

	if fluid ~= nil then		
		local valve_fluid = "valve-"..fluid.name
		local current = entity.get_recipe()		
		if current == nil then
			try_set_recipe(entity,valve_fluid)
		elseif valve_fluid ~= current.name then
			local_clear_fluid_recipe(entity)
		end	
	else
		local_clear_fluid_recipe(entity)
	end	
	end


local local_overflow_valve_process = function(valve)	
	local entity = valve.entity
	entity.energy = 100000
	if valve.entity.is_crafting() then return end
	local fluid = nil
	local pipe = local_get_connected_input_fluid_for_valve(valve,1)
	if pipe ~= nil then
		fluid = pipe.entity.fluidbox[pipe.box]	
	end
	if fluid == nil then
		pipe = local_get_connected_input_fluid_for_valve(valve,2)
		if pipe ~= nil then
			fluid = pipe.entity.fluidbox[pipe.box]	
		end

	end
	if fluid ~= nil then
		if fluid.amount/pipe.entity.fluidbox.get_capacity(pipe.box) > valve.value then
			local valve_fluid = "valve-"..fluid.name		
			local current = entity.get_recipe()			
			if fluid.amount == 0 then
				local_clear_fluid_recipe(entity)
			elseif current == nil then
				try_set_recipe(entity,valve_fluid)
			elseif current.name ~= valve_fluid then
				local_clear_fluid_recipe(entity)
			end	
		end
	else
		local_clear_fluid_recipe(entity)
	end	
end

local local_undeflow_valve_process = function(valve)
	local entity = valve.entity
	entity.energy = 100000
	local fluid = nil
	local outpipe = local_get_connected_input_fluid_for_valve(valve,2)
	local inpipe = local_get_connected_input_fluid_for_valve(valve,1)
		
	local cap = nil
	if outpipe ~= nil then	
		fluid = outpipe.entity.fluidbox[outpipe.box]	
		cap = outpipe.entity.fluidbox.get_capacity(outpipe.box)
	end
	if fluid == nil and inpipe ~= nil then
		fluid = inpipe.entity.fluidbox[inpipe.box]	
	end
	if fluid ~= nil then		
		if cap == nil or fluid.amount/cap < valve.value then
			local valve_fluid = "valve-"..fluid.name		
			local current = entity.get_recipe()			
			if fluid.amount == 0 then
				local_clear_fluid_recipe(entity)
			elseif current == nil then
				try_set_recipe(entity,valve_fluid)
			elseif current.name ~= valve_fluid then
				local_clear_fluid_recipe(entity)
			end	
		else
			local_clear_fluid_recipe(entity)
		end
	else
		local_clear_fluid_recipe(entity)
	end	
end

local local_mini_boiler_process = function(valve)
	local entity = valve.entity
	if not entity.is_crafting() then return end
	local outpipe = get_connected_input_fluid(entity,2)
	if outpipe ~= nil then
		if entity.fluidbox[2] ~= nil then
			local t = entity.fluidbox[2]
			t.temperature = 90
			entity.fluidbox[2] = t
		end
		local t = outpipe.entity.fluidbox[outpipe.box]
		t.temperature = 90
		outpipe.entity.fluidbox[outpipe.box] = t
	end
end

local local_super_boiler_process = function(valve)
	local entity = valve.entity
	if not entity.is_crafting() then return end
	
	local outpipe = get_connected_input_fluid(entity,2)
	if outpipe ~= nil then
		if entity.fluidbox[2] ~= nil then
			local t = entity.fluidbox[2]
			t.temperature = 400
			entity.fluidbox[2] = t
		end
		local t = outpipe.entity.fluidbox[outpipe.box]
		t.temperature = 400
		outpipe.entity.fluidbox[outpipe.box] = t
	end
end

local local_remove = function(entity)
	for index, valve in ipairs(global.modmash.valves) do
		if valve.entity == entity then
			valve.value = 0
			local_refresh_sticker(valve)
			table.remove(global.modmash.valves, index)
		end
	end
end

local local_valve_removed = function(entity)
	if table_contains(valve_types,entity.name) then	
		local_remove(entity)
	end
end

local local_valves_tick = function()
	if init ~= nil then init = init() end		
	local valves = global.modmash.valves	
	for k=1, #valves do local valve = valves[k];			
		if valve ~= nil and is_valid(valve.entity) and valve.entity.to_be_deconstructed(valve.entity.force) ~= true then							
				if valve.entity.name == "modmash-check-valve" then local_check_valve_process(valve)					
				elseif valve.entity.name == "modmash-check-valve" then local_check_valve_process(valve) 
				elseif valve.entity.name == "modmash-overflow-valve" then local_overflow_valve_process(valve) 
				elseif valve.entity.name == "mini-boiler" then local_mini_boiler_process(valve) 
				elseif valve.entity.name == "modmash-underflow-valve" then local_undeflow_valve_process(valve) 				
				elseif valve.entity.name == "modmash-super-boiler-valve" then local_super_boiler_process(valve) end
		else
			local_remove(valve.entity)
		end
	end
end

local local_valve_added = function(entity)
	if table_contains(valve_types,entity.name) then		
		detail = {
			entity = entity,
			value = 0.75,
		}
		table.insert(global.modmash.valves, detail)
		if entity.name ~= "modmash-super-boiler-valve" then
			entity.operable = false
		end
	end
end

local local_valve_adjust = function(entity)		
	if entity.name == "modmash-overflow-valve" or entity.name == "modmash-underflow-valve" then
		for _, valve in ipairs(global.modmash.valves) do
			if valve.entity.valid then
				if not valve.entity.to_be_deconstructed(valve.entity.force) then
					if valve.entity == entity then
						if valve.value == 0.75 then valve.value = 0.5
						elseif valve.value == 0.5 then valve.value = 0.25
						elseif valve.value == 0.25 then valve.value = 0.75 end
						local_refresh_sticker(valve)
						return
					end
				end
			end
		end
	end
end

if modmash.ticks ~= nil then	
	table.insert(modmash.ticks,local_valves_tick)
	table.insert(modmash.on_added,local_valve_added)
	table.insert(modmash.on_remove,local_valve_removed)
	table.insert(modmash.on_adjust,local_valve_adjust)
end