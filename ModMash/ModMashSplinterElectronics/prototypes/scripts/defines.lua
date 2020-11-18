if not modmashsplinterelectronics then modmashsplinterelectronics = {} end

if modmashsplinterelectronics.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterelectronics.util = get_modmashsplinterlib()
	else 
		modmashsplinterelectronics.util = get_modmashsplinterlib()
	end
end