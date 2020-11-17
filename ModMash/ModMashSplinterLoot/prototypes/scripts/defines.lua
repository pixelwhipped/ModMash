if not modmashsplinterloot then modmashsplinterloot = {} end
if not modmashsplinterloot.defines then modmashsplinterloot.defines = {} end
if not modmashsplinterloot.defines.names then modmashsplinterloot.defines.names = {} end

if modmashsplinterloot.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterloot.util = get_modmashsplinterlib()	
	else 
		modmashsplinterloot.util = get_modmashsplinterlib()
	end
end

modmashsplinterloot.defines.names.loot_science_prefix = "loot_science_"
modmashsplinterloot.defines.names.loot_science_a = modmashsplinterloot.defines.names.loot_science_prefix .. "a"
modmashsplinterloot.defines.names.loot_science_b = modmashsplinterloot.defines.names.loot_science_prefix .. "b"
modmashsplinterloot.defines.names.crash_site_prefix = "crash-site-chest-"

modmashsplinterloot.defines.loot_probability = 13
modmashsplinterloot.defines.loot_tech_probability = 39
modmashsplinterloot.defines.loot_exclude_distance_from_origin = 224
modmashsplinterloot.defines.loot_max_distance_reduction_modifier = modmashsplinterloot.defines.loot_exclude_distance_from_origin * 8
modmashsplinterloot.defines.crash_site_chest_inventory = 48
modmashsplinterloot.defines.crash_site_chest_health = 50