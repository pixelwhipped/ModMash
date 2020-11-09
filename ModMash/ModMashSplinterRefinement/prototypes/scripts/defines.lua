if not modmashsplinterrefinement then modmashsplinterrefinement = {} end

if modmashsplinterrefinement.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterrefinement.util = get_modmashsplinterlib()	
	else 
		modmashsplinterrefinement.util = get_modmashsplinterlib()
	end
end