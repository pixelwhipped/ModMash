if not modmashsplinterlogistics then modmashsplinterlogistics = {} end

if modmashsplinterlogistics.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterlogistics.util = get_modmashsplinterlib()
	else 
		modmashsplinterlogistics.util = get_modmashsplinterlib()
	end
end