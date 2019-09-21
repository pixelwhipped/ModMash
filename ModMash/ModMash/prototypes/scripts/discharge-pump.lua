if not util then require("prototypes.scripts.util") end

local init = function()	
	if global.modmash.discharge_pumps == nil then global.modmash.discharge_pumps = {} end	
	return nil end

local local_discharge_pump_process = function(entity)
	local pumps = util.get_entities_to(entity.direction,entity)
	if #pumps > 0 then	
		for index=1, #pumps do local connection = pumps[index]
			util.change_fluidbox_fluid(connection,entity.prototype.pumping_speed,entity)
		end
		local fluid =  entity.fluidbox[1]
		if fluid ~= nil then
			fluid.amount = 0
			entity.fluidbox[1] = fluid
		end
	end
end

local local_discharge_pump_tick = function()
	if init ~= nil then init = init() end	
	local pumps = global.modmash.discharge_pumps
	if pumps ~= nil then	
		for index=1, #pumps do local discharge_pump = pumps[index]
			if discharge_pump.valid then
				if not discharge_pump.to_be_deconstructed(discharge_pump.force) then
					local_discharge_pump_process(discharge_pump)
				end
			end
		end
	end
end

local local_discharge_pump_added = function(entity)
	if entity.name == "mm-discharge-water-pump" then		
		table.insert(global.modmash.discharge_pumps, entity)
	end
end

local local_discharge_pump_removed = function(entity)
	if entity.name == "mm-discharge-water-pump" then		
		local pumps = global.modmash.discharge_pumps
		for index=1, #pumps do local pump = pumps[index]
			if pump.valid and pump == entity then
				table.remove(global.modmash.discharge_pumps, index)
				return
			end
		end
	end
end

if modmash.ticks ~= nil then
	table.insert(modmash.ticks,local_discharge_pump_tick)
	table.insert(modmash.on_added,local_discharge_pump_added)
	table.insert(modmash.on_remove,local_discharge_pump_removed)
end