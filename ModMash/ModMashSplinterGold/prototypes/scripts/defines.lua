if not modmashsplintergold then modmashsplintergold = {} end

if modmashsplintergold.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplintergold.util = get_modmashsplinterlib()		
	else 
		modmashsplintergold.util = get_modmashsplinterlib()
	end
end