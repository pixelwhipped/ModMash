if not modmashsplinterdefense then modmashsplinterdefense = {} end

if modmashsplinterdefense.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterdefense.util = get_modmashsplinterlib()
	else 
		modmashsplinterdefense.util = get_modmashsplinterlib()
	end
end