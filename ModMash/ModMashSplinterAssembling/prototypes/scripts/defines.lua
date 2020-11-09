if not modmashsplinterassembling then modmashsplinterassembling = {} end

if modmashsplinterassembling.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterassembling.util = get_modmashsplinterlib()		
	else 
		modmashsplinterassembling.util = get_modmashsplinterlib()
	end
end