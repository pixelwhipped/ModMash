if not modmashsplintervalkyries then modmashsplintervalkyries = {} end

if modmashsplintervalkyries.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplintervalkyries.util = get_modmashsplinterlib()	
	else 
		modmashsplintervalkyries.util = get_modmashsplinterlib()
	end
end