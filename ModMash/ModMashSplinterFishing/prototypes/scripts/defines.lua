if not modmashsplintefishing then modmashsplintefishing = {} end

if modmashsplintefishing.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplintefishing.util = get_modmashsplinterlib()	
	else 
		modmashsplintefishing.util = get_modmashsplinterlib()
	end
end