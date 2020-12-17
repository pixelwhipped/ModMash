if not modmashsplinterunderground then modmashsplinterunderground = {} end
if not modmashsplinterunderground.defines then modmashsplinterunderground.defines = {} end
if not modmashsplinterunderground.defines.names then modmashsplinterunderground.defines.names = {} end

if modmashsplinterunderground.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterunderground.util = get_modmashsplinterlib()		
	else 
		modmashsplinterunderground.util = get_modmashsplinterlib()
	end
end

modmashsplinterunderground.defines.names.underground_access = "underground-access"
modmashsplinterunderground.defines.names.underground_access2 = "underground-access2"
modmashsplinterunderground.defines.names.underground_accessml = "underground-accessml"
modmashsplinterunderground.defines.names.underground_accumulator = "underground-accumulator"
modmashsplinterunderground.defines.names.battery_cell = "battery-cell"
modmashsplinterunderground.defines.names.used_battery_cell = "used-battery-cell"
modmashsplinterunderground.defines.names.recharged_battery_cell = "recharged-battery-cell"
modmashsplinterunderground.defines.names.level_one_rock_prefix = "underground-rock-"
modmashsplinterunderground.defines.names.level_two_rock_prefix = "deep-underground-rock-"
modmashsplinterunderground.defines.names.dirt_prefix = "underground-dark-"
modmashsplinterunderground.defines.names.level_one_attack_rock = "underground-attack-rock"
modmashsplinterunderground.defines.names.level_two_attack_rock = "deep-underground-attack-rock"

modmashsplinterunderground.defines.names.rock_names = {
  "rock-huge",
  "rock-big",
  "sand-rock-big"
}
