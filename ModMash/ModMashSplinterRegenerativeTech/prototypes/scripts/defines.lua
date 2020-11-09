if not modmashsplinterregenerative then modmashsplinterregenerative = {} end

if modmashsplinterregenerative.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterregenerative.util = get_modmashsplinterlib()	
	else 
		modmashsplinterregenerative.util = get_modmashsplinterlib()
	end
end