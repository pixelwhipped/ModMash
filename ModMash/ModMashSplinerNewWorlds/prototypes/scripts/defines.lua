if not modmashsplinternewworlds then modmashsplinternewworlds = {} end
if not modmashsplinternewworlds.defines then modmashsplinternewworlds.defines = {} end

if modmashsplinternewworlds.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinternewworlds.util = get_modmashsplinterlib()	
	else 
		modmashsplinternewworlds.util = get_modmashsplinterlib()
	end
end

modmashsplinternewworlds.defines.queen_hive_min_distance = 30