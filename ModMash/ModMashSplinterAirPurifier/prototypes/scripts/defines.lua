if not modmashsplinterairpurifier then modmashsplinterairpurifier = {} end

if modmashsplinterairpurifier.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterairpurifier.util = get_modmashsplinterlib()	
	else 
		modmashsplinterairpurifier.util = get_modmashsplinterlib()
	end
end

if not modmashsplinterairpurifier.defines then modmashsplinterairpurifier.defines = {} end
if not modmashsplinterairpurifier.defines.air_purifier then modmashsplinterairpurifier.defines.air_purifier = {} end
modmashsplinterairpurifier.defines.air_purifier.entity_crafting_speed = 1
modmashsplinterairpurifier.defines.air_purifier.entity_energy_source_emissions_per_minute = -6
modmashsplinterairpurifier.defines.air_purifier.entity_energy_usage = "200kW"
modmashsplinterairpurifier.defines.air_purifier.entity_energy_source_drain = "20kW"

if not modmashsplinterairpurifier.defines.advanced_air_purifier then modmashsplinterairpurifier.defines.advanced_air_purifier = {} end
modmashsplinterairpurifier.defines.advanced_air_purifier.entity_crafting_speed = 1.25
modmashsplinterairpurifier.defines.advanced_air_purifier.entity_energy_source_emissions_per_minute = -10
modmashsplinterairpurifier.defines.advanced_air_purifier.entity_energy_usage = "225kW"
modmashsplinterairpurifier.defines.advanced_air_purifier.entity_energy_source_drain = "20kW"

if not modmashsplinterairpurifier.defines.names then modmashsplinterairpurifier.defines.names = {} end
modmashsplinterairpurifier.defines.names.air_purifier = "air-purifier"
modmashsplinterairpurifier.defines.names.advanced_air_purifier = "advanced-air-purifier"
modmashsplinterairpurifier.defines.names.air_purifier_action_prefix = "air-purifier-action-"

modmashsplinterairpurifier.defines.pollution_chunks_per_tick  = 10
modmashsplinterairpurifier.defines.pollution_min_evolution_factor  = 0.025
modmashsplinterairpurifier.defines.pollution_reduce_evolution_factor  = 0.00005