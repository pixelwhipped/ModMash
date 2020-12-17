if not modmashsplinterrecycling then modmashsplinterrecycling = {} end

if modmashsplinterrecycling.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterrecycling.util = get_modmashsplinterlib()	
	else 
		modmashsplinterrecycling.util = get_modmashsplinterlib()
	end
end