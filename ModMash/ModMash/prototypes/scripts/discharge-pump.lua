--[[code reviewed 6.10.19
	Used defines for enitity name references
	use is valid]]
log("discharge-pump.lua")
--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end

--[[defines]]
local discharge_water_pump  = modmash.defines.names.discharge_water_pump 
	
--[[create local references]]
--[[util]]
local get_entities_to  = modmash.util.get_entities_to
local change_fluidbox_fluid = modmash.util.change_fluidbox_fluid
local is_valid = modmash.util.is_valid
local is_valid_and_persistant = modmash.util.is_valid_and_persistant
local table_index_of = modmash.util.table.index_of

--[[unitialized globals]]
local pumps = nil

--[[ensure globals]]
local local_init = function() 
	log("discharge-pump.local_init")
	if global.modmash.discharge_pumps == nil then global.modmash.discharge_pumps = {} end
	pumps = global.modmash.discharge_pumps
	end
local local_load = function() 
	log("discharge-pump.local_load")
	pumps = global.modmash.discharge_pumps
	end

local local_discharge_pump_process = function(entity)
	local connected_pumps = get_entities_to(entity.direction,entity)
	if #connected_pumps > 0 then	
		for index=1, #connected_pumps do local connection = connected_pumps[index]
			change_fluidbox_fluid(connection,entity.prototype.pumping_speed,entity)
		end
		local fluid =  entity.fluidbox[1]
		if fluid ~= nil then
			fluid.amount = 0
			entity.fluidbox[1] = fluid
		end
	end
end

local local_discharge_pump_tick = function()		
	--if true then return end
	for index=1, #pumps do local discharge_pump = pumps[index]
		if is_valid_and_persistant(discharge_pump) then
			local_discharge_pump_process(discharge_pump)
		end
	end
end

modmash.register_script({
	names = {discharge_water_pump},
	on_init = local_init,
	on_load = local_load,
	on_tick = {
		tick = local_discharge_pump_tick,		
		table = function() return pumps end,
		auto_add_remove = {discharge_water_pump}
		}
})
