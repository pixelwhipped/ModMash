if not modmashsplinterboom then modmashsplintervalkyries = {} end

if modmashsplinterboom.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterboom.util = get_modmashsplinterlib()
	else 
		modmashsplinterboom.util = get_modmashsplinterlib()
	end
end