if not modmashsplinterresources then modmashsplinterresources = {} end

if modmashsplinterresources.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterresources.util = get_modmashsplinterlib()		
	else 
		modmashsplinterresources.util = get_modmashsplinterlib()
	end
end