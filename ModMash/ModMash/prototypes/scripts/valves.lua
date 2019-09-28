if not util then require("prototypes.scripts.util") end

local valve_types = {"modmash-super-boiler-valve", "mini-boiler", "modmash-check-valve", "modmash-overflow-valve", "condenser-valve", "modmash-underflow-valve"}		

local local_get_connected_input_fluid_for_valve = function(valve,box)
	if box == 1 then
		if valve.box1 ~= nil and util.is_valid(valve.box1.entity) then return valve.box1
		else valve.box1 = util.get_connected_input_fluid(valve.entity,box) end
	elseif box == 2 then
		if valve.box2 ~= nil and util.is_valid(valve.box2.entity) then return valve.box2
		else valve.box2 = util.get_connected_input_fluid(valve.entity,box) end
	else
		return util.get_connected_input_fluid(valve.entity,box)
	end
end

local local_set_sticker = function(valve, variation)
	if valve.signal ~= nil then
		valve.signal.destroy() 
	end
	if variation > 0 then
		valve.signal = util.signal.set_new_signal(valve.entity,"valve-indicator",variation)
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
	local status, retval = pcall(call,entity)
	if status == true then return end
end

local local_check_valve_process = function(valve)
	--log("Start Check Valve")
	local entity = valve.entity
	entity.energy = 100000
	if valve.entity.is_crafting() then return end
	local fluid = nil
	--log("Phase A")
	local pipe = local_get_connected_input_fluid_for_valve(valve,1)
	if pipe ~= nil then
		--log("Phase B")
		fluid = pipe.entity.fluidbox[pipe.box]	
	end
	if fluid == nil then
		--log("Phase C")
		pipe = local_get_connected_input_fluid_for_valve(valve,2)
		if pipe ~= nil then
			--log("Phase D")
			fluid = pipe.entity.fluidbox[pipe.box]	
		end
	end
	if fluid ~= nil then		
		local valve_fluid = "valve-"..fluid.name
		--log("Phase E")
		local current = entity.get_recipe()		
		if current == nil then
		--	log("Phase F")
			util.try_set_recipe(entity,valve_fluid)
		elseif valve_fluid ~= current.name then
		--	log("Phase G")
			local_clear_fluid_recipe(entity)
		end	
	end	
	--log("End Check Valve")
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
				util.try_set_recipe(entity,valve_fluid)
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
				util.try_set_recipe(entity,valve_fluid)
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
	local outpipe = util.get_connected_input_fluid(entity,2)
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
	
	local outpipe = util.get_connected_input_fluid(entity,2)
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
	if entity~=nil and entity.valid then
		local inventory = entity.get_inventory(defines.inventory.assembling_machine_input)
		if inventory ~= nil then inventory.clear() end
		inventory = entity.get_inventory(defines.inventory.assembling_machine_output)
		if inventory ~= nil then inventory.clear() end
	end
	for index, valve in ipairs(global.modmash.valves) do
		if valve.entity == entity then
			valve.value = 0
			local_refresh_sticker(valve)
			table.remove(global.modmash.valves, index)
		end
	end
end

local local_valve_removed = function(entity)
	if util.table.contains(valve_types,entity.name) then	
		local_remove(entity)
	end
end

local local_valves_tick = function()
	if init ~= nil then init = init() end		
	local valves = global.modmash.valves	
	for k=1, #valves do local valve = valves[k];			
		if valve ~= nil and valve.entity ~= nil and valve.entity.valid then	
			if not valve.entity.to_be_deconstructed(valve.entity.force) then							
				if valve.entity.name == "modmash-check-valve" then local_check_valve_process(valve)					
				elseif valve.entity.name == "modmash-check-valve" then local_check_valve_process(valve) 
				elseif valve.entity.name == "modmash-overflow-valve" then local_overflow_valve_process(valve) 
				elseif valve.entity.name == "mini-boiler" then local_mini_boiler_process(valve) 
				elseif valve.entity.name == "modmash-underflow-valve" then local_undeflow_valve_process(valve) 				
				elseif valve.entity.name == "modmash-super-boiler-valve" then local_super_boiler_process(valve) end
			end
		elseif valve ~= nil then
			local_remove(valve.entity)
		end
	end
end

local local_valve_added = function(entity)
	if util.table.contains(valve_types,entity.name) then		
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