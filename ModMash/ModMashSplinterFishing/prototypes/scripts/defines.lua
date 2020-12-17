if not modmashsplinterfishing then modmashsplinterfishing = {} end
if not modmashsplinterfishing.defines then modmashsplinterfishing.defines = {} end
if not modmashsplinterfishing.defines.names then modmashsplinterfishing.defines.names = {} end
modmashsplinterfishing.defines.names.allow_fishing = "allow-fishing"

if modmashsplinterfishing.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterfishing.util = get_modmashsplinterlib()	
	else 
		modmashsplinterfishing.util = get_modmashsplinterlib()
	end
end