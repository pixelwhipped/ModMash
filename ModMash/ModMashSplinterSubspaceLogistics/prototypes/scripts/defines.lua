if not modmashsplintersubspacelogistics then modmashsplintersubspacelogistics = {} end
if not modmashsplintersubspacelogistics.defines then modmashsplintersubspacelogistics.defines = {} end
if not modmashsplintersubspacelogistics.defines.defaults then modmashsplintersubspacelogistics.defines.defaults = {} end
modmashsplintersubspacelogistics.defines.defaults.super_container_stack_size = 5

if modmashsplintersubspacelogistics.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplintersubspacelogistics.util = get_modmashsplinterlib()		
	else 
		modmashsplintersubspacelogistics.util = get_modmashsplinterlib()
	end
end