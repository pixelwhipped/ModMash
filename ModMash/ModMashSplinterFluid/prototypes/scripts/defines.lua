if not modmashsplinterfluid then modmashsplinterfluid = {} end

if modmashsplinterfluid.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterfluid.util = get_modmashsplinterlib()	
	else 
		modmashsplinterfluid.util = get_modmashsplinterlib()
	end
end