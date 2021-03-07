if not modmashsplinterthem then modmashsplinterthem = {} end
if not modmashsplinterthem.defines then modmashsplinterthem.defines = {} end
if not modmashsplinterthem.defines.defaults then modmashsplinterthem.defines.defaults = {} end
if not modmashsplinterthem.healing_per_tick then modmashsplinterthem.healing_per_tick = 0.1 end
if not modmashsplinterthem.resistances then modmashsplinterthem.resistances = 
{
	{
		type = "fire",
		percent = 60
	},
	{
		type = "electric",
		percent = 60
	},
	{
		type = "impact",
		percent = 30
	}
}
end
if not modmashsplinterthem.port_range then modmashsplinterthem.port_range = 256 end

modmashsplinterthem.debug = false

if modmashsplinterthem.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterthem.util = get_modmashsplinterlib()		
	else 
		modmashsplinterthem.util = get_modmashsplinterlib()
	end
end