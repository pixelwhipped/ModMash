if not util then require("prototypes.scripts.util") end

local local_wind_trap_pump_added = function(entity)
	if entity.name == "wind-trap" then
		local biome = util.get_biome(entity)
		entity.set_recipe("wind-trap-action-" .. biome)
		entity.operable = false
	end
end

if modmash.ticks ~= nil then	
	table.insert(modmash.on_added,local_wind_trap_pump_added)
end