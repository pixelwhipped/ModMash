if not modmashsplinterenrichment then modmashsplinterenrichment = {} end

if modmashsplinterenrichment.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterenrichment.util = get_modmashsplinterlib()	
	else 
		modmashsplinterenrichment.util = get_modmashsplinterlib()
	end
end