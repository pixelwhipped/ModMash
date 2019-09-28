if not modmash or not modmash.util then require("prototypes.scripts.util") end

local get_biome  = modmash.util.get_biome
local try_set_recipe  = modmash.util.try_set_recipe

local local_wind_trap_pump_added = function(entity)
	if entity.name == "wind-trap" then
		local biome = get_biome(entity)
		try_set_recipe(entity,"wind-trap-action-" .. biome)
		entity.operable = false
	end
end

if modmash.ticks ~= nil then	
	table.insert(modmash.on_added,local_wind_trap_pump_added)
end