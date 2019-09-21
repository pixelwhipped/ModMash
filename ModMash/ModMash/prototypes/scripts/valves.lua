if not util then require("prototypes.scripts.util") end

local function get_signal_position_from(entity)
    local left_top = entity.prototype.selection_box.left_top
    local right_bottom = entity.prototype.selection_box.right_bottom
    --Calculating center of the selection box
    local center = (left_top.x + right_bottom.x) / 2
    local width = math.abs(left_top.x) + right_bottom.x
    -- Set Shift here if needed, The offset looks better as it doesn't cover up fluid input information
    -- Ignore shift for 1 tile entities
    local x = (width > 1.25 and center - 0.5) or center
    local y = right_bottom.y
    --Calculating bottom center of the selection box
    return {x = entity.position.x + x, y = entity.position.y + y}
end

local function new_signal(entity, sticker)
    local signal = entity.surface.create_entity{name = "valve-indicator", position = get_signal_position_from(entity), force = entity.force}
    signal.graphics_variation = sticker
    signal.destructible = false
    return signal
end

local local_set_sticker = function(valve, sticker)
	if valve.signal ~= nil then
		valve.signal.destroy() 
	end
	if sticker > 0 then
		valve.signal = new_signal(valve.entity,sticker)
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
				valve.entity.set_recipe("void-recipe")
			end
		end
	end
end
local init = function()	
	if global.modmash.valves == nil then global.modmash.valves = {} end	
	local_rebuild_lables()
	return nil end

local local_animate = function(valve)
	local inventory = valve.entity.get_inventory(defines.inventory.assembling_machine_input)				
	if inventory~= nil and inventory.can_insert({name = "void-item", count = 1}) then
		inventory.insert({name = "void-item", count = 1})
	end	
end

local local_check_valve_process = function(valve)
	local entity = valve.entity
	entity.energy = 100000
	local inpipe = util.get_connected_input_fluid(entity,1)
	local outpipe =util.get_connected_input_fluid(entity,2)	
	if inpipe ~= nil and outpipe ~= nil then		
		local_animate(valve)
		util.transfer_fluid(inpipe.entity,inpipe.box,entity,2,20,100)
	end	end

local local_overflow_valve_process = function(valve)	
	local overflow_can_transfer_fluid = function(from,findex,mincap,percentage)
		if from ~= nil then
			local from_boxes = from.fluidbox
			local from_box = from_boxes[findex]				
			if from_box ~= nil then		
				local cap = math.max(from_boxes.get_capacity(findex),mincap)
				local amt = math.min(from_box.amount,cap)
				local p = amt/cap
				
				return p >= percentage
			end
		end
		return false end																																	
	local entity = valve.entity
	entity.energy = 100000
	local inpipe = util.get_connected_input_fluid(entity,1)
	local outpipe = util.get_connected_input_fluid(entity,2)
	if inpipe ~= nil and outpipe ~= nil then
		if overflow_can_transfer_fluid(inpipe.entity,inpipe.box,100,valve.value) then
			local_animate(valve)
			util.transfer_fluid(inpipe.entity,inpipe.box,entity,2,20,100)	
		end
	end	end

local local_undeflow_valve_process = function(valve)
	local underflow_can_transfer_fluid = function(from,findex,mincap,percentage)
		if from ~= nil then
			local from_boxes = from.fluidbox
			local from_box = from_boxes[findex]				
			if from_box ~= nil then		
				local cap = math.max(from_boxes.get_capacity(findex),mincap)
				local amt = math.min(from_box.amount,cap)
				local p = amt/cap				
				return p <= percentage
			else
				return true
			end
		end
		return false end
	local entity = valve.entity
	entity.energy = 100000
	local inpipe = util.get_connected_input_fluid(entity,1)
	local outpipe = util.get_connected_input_fluid(entity,2)	
	if inpipe ~= nil and outpipe ~= nil then
		if underflow_can_transfer_fluid(outpipe.entity,outpipe.box,100,valve.value) then
			local_animate(valve)
			util.transfer_fluid(inpipe.entity,inpipe.box,entity,2,20,100)
			--util.transfer_fluid(entity,2,entity,1,20,100)
			--util.transfer_fluid(entity,1,outpipe.entity,outpipe.box,20,100)	
		end
	end	end

local local_condenser_valve_process = function(valve)
	local condenser_can_transfer_fluid = function(from,findex)
		if from ~= nil then
			local from_boxes = from.fluidbox
			local from_box = from_boxes[findex]				
			if from_box ~= nil then		
				return from_box.name == "steam"
			else
				return false
			end
		end
		return false end
	local entity = valve.entity
	local inpipe = util.get_connected_input_fluid(entity,1)
	local outpipe = util.get_connected_input_fluid(entity,2)

	if inpipe ~= nil and outpipe ~= nil then
		if condenser_can_transfer_fluid(inpipe.entity,inpipe.box) then				
			if entity.energy == 0 then return end	
			local_animate(valve)
			--entity.get_output_inventory().clear()
			util.transfer_fluid_and_convert(inpipe.entity,inpipe.box,entity,2,5,5,"water",15)
			--util.transfer_fluid(entity,2,entity,1,5,5)
			--util.transfer_fluid(entity,1,outpipe.entity,outpipe.box,5,5)	
		end
	end	end

local local_mini_boiler_process = function(valve)
	local mini_boiler_can_transfer_fluid = function(from,findex)	
		if from ~= nil then
			local from_boxes = from.fluidbox
			local from_box = from_boxes[findex]				
			if from_box ~= nil then		
				return from_box.name == "water"
			else
				return false
			end
		end
		return false end
	local entity = valve.entity	
	local inpipe = util.get_connected_input_fluid(entity,1)
	local outpipe = util.get_connected_input_fluid(entity,2)
	if inpipe ~= nil and outpipe ~= nil then
		if mini_boiler_can_transfer_fluid(inpipe.entity,inpipe.box) then
			if entity.energy == 0 then return end	
			local_animate(valve)
		--	entity.get_output_inventory().clear()
			util.transfer_fluid_and_convert(inpipe.entity,inpipe.box,entity,2,5,5,"steam",90)
		--	util.transfer_fluid(entity,2,entity,1,5,5)
		--	util.transfer_fluid(entity,1,outpipe.entity,outpipe.box,5,5)	
		end
	end	end

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
	if entity.name == "mini-boiler" or entity.name == "modmash-check-valve" or  entity.name == "modmash-overflow-valve" or  entity.name == "condenser-valve" or  entity.name == "modmash-underflow-valve" then						
		local_remove(entity)
	end
end


local local_valves_tick = function()
	if init ~= nil then init = init() end		
	local valves = global.modmash.valves	
	for k=1, #valves do local valve = valves[k];	
		
		if valve ~= nil and valve.entity ~= nil and valve.entity.valid then	
			if not valve.entity.to_be_deconstructed(valve.entity.force) then			
				local inventory = valve.entity.get_inventory(defines.inventory.assembling_machine_input)				
				inventory.clear()
				--if valve.entity.name == "modmash-check-valve" and (not game.active_mod["underground-pipe-pack"]) then local_check_valve_process(valve) end
				if valve.entity.name == "modmash-check-valve" then local_check_valve_process(valve) end
				if valve.entity.name == "modmash-overflow-valve" then local_overflow_valve_process(valve) end
				if valve.entity.name == "condenser-valve" then local_condenser_valve_process(valve) end
				if valve.entity.name == "mini-boiler" then local_mini_boiler_process(valve) end
				if valve.entity.name == "modmash-underflow-valve" then local_undeflow_valve_process(valve) end							
				inventory = valve.entity.get_inventory(defines.inventory.assembling_machine_output)
	inventory.clear()
			else
				local inventory = valve.entity.get_inventory(defines.inventory.assembling_machine_input)				
				inventory.clear()
				inventory = valve.entity.get_inventory(defines.inventory.assembling_machine_output)
				inventory.clear()
			end
		elseif valve ~= nil then
			local_remove(valve.entity)
		end
	end
end

local local_valve_added = function(ent)
	if ent.name == "mini-boiler" or ent.name == "modmash-check-valve" or  ent.name == "modmash-overflow-valve" or  ent.name == "condenser-valve" or  ent.name == "modmash-underflow-valve" then		
		detail = {
			entity = ent,
			value = 0.75,
		}
		table.insert(global.modmash.valves, detail)
		ent.operable = false
		ent.set_recipe("void-recipe")
		local_refresh_sticker(detail)
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
						--util.print("Valve set to " .. (valve.value*100) .."%")
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