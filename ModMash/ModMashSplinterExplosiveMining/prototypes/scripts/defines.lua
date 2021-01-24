if not modmashsplinterexplosivemining then modmashsplinterexplosivemining = {} end

if modmashsplinterexplosivemining.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterexplosivemining.util = get_modmashsplinterlib()	
	else 
		modmashsplinterexplosivemining.util = get_modmashsplinterlib()
	end
end