if not modmashsplinterfishing then modmashsplinterfishing = {} end

if modmashsplinterfishing.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterfishing.util = get_modmashsplinterlib()	
	else 
		modmashsplinterfishing.util = get_modmashsplinterlib()
	end
end